import * as child_process from 'child_process';
import * as fs from 'fs-extra';
import * as os from 'os';
import * as path from 'path';
import * as log from './log';
import {GraphicsApi} from './GraphicsApi';
import {Options} from './Options';
import {Project} from './Project';
import {Platform} from './Platform';
import * as exec from './exec';
import {VisualStudioVersion} from './VisualStudioVersion';
import {Exporter} from './Exporters/Exporter';
import {AndroidExporter} from './Exporters/AndroidExporter';
import {LinuxExporter} from './Exporters/LinuxExporter';
import {EmscriptenExporter} from './Exporters/EmscriptenExporter';
import {TizenExporter} from './Exporters/TizenExporter';
import {VisualStudioExporter} from './Exporters/VisualStudioExporter';
import {XCodeExporter} from './Exporters/XCodeExporter';

let _global: any = global;
_global.__base = __dirname + '/';

let debug = false;

function fromPlatform(platform: string): string {
	switch (platform.toLowerCase()) {
		case Platform.Windows:
			return 'Windows';
		case Platform.WindowsApp:
			return 'Windows App';
		case Platform.iOS:
			return 'iOS';
		case Platform.OSX:
			return 'OS X';
		case Platform.Android:
			return 'Android';
		case Platform.Linux:
			return 'Linux';
		case Platform.HTML5:
			return 'HTML5';
		case Platform.Tizen:
			return 'Tizen';
		case Platform.Pi:
			return 'Pi';
		case Platform.tvOS:
			return 'tvOS';
		case Platform.PS4:
			return 'PlayStation4';
		case Platform.XboxOne:
			return 'Xbox One';
		case Platform.Switch:
			return 'Switch';
		default:
			throw 'Unknown platform ' + platform + '.';
	}
}

function shaderLang(platform: string): string {
	switch (platform) {
		case Platform.Windows:
			switch (Options.graphicsApi) {
				case GraphicsApi.OpenGL:
					return 'glsl';
				case GraphicsApi.Direct3D9:
					return 'd3d9';
				case GraphicsApi.Direct3D11:
					return 'd3d11';
				case GraphicsApi.Direct3D12:
					return 'd3d11';
				case GraphicsApi.Vulkan:
					return 'spirv';
				default:
					return 'd3d9';
			}
		case Platform.WindowsApp:
			return 'd3d11';
		case Platform.iOS:
		case Platform.tvOS:
			switch (Options.graphicsApi) {
				case GraphicsApi.Metal:
					return 'metal';
				default:
					return 'essl';
			}
		case Platform.OSX:
			switch (Options.graphicsApi) {
				case GraphicsApi.Metal:
					return 'metal';
				default:
					return 'glsl';
			}
		case Platform.Android:
			switch (Options.graphicsApi) {
				case GraphicsApi.Vulkan:
					return 'spirv';
				default:
					return 'essl';
			}
		case Platform.Linux:
			switch (Options.graphicsApi) {
				case GraphicsApi.Vulkan:
					return 'spirv';
				default:
					return 'glsl';
			}
		case Platform.HTML5:
			return 'essl';
		case Platform.Tizen:
			return 'essl';
		case Platform.Pi:
			return 'essl';
		default:
			return platform;
	}
}

async function compileShader(projectDir: string, type: string, from: string, to: string, temp: string, platform: string, builddir: string) {
	return new Promise<void>((resolve, reject) => {
		let compilerPath = '';
		
		if (Project.koreDir !== '') {
			compilerPath = path.resolve(Project.koreDir, 'Tools', 'krafix', 'krafix' + exec.sys());
		}

		if (fs.existsSync(path.join(projectDir, 'Backends'))) {
			let libdirs = fs.readdirSync(path.join(projectDir, 'Backends'));
			for (let ld in libdirs) {
				let libdir = path.join(projectDir, 'Backends', libdirs[ld]);
				if (fs.statSync(libdir).isDirectory()) {
					let exe = path.join(libdir, 'krafix', 'krafix-' + platform + '.exe');
					if (fs.existsSync(exe)) {
						compilerPath = exe;
					}
				}
			}
		}

		if (compilerPath !== '') {
			if (type === 'metal') {
				fs.ensureDirSync(path.join(builddir, 'Sources'));
				let fileinfo = path.parse(from);
				let funcname = fileinfo.name;
				funcname = funcname.replace(/-/g, '_');
				funcname = funcname.replace(/\./g, '_');
				funcname += '_main';

				fs.writeFileSync(to, funcname, 'utf8');

				to = path.join(builddir, 'Sources', fileinfo.name + '.' + type);
				temp = to + '.temp';
			}

			let params = [type, from, to, temp, platform];
			if (debug) params.push('--debug');
			let compiler = child_process.spawn(compilerPath, params);
			
			compiler.stdout.on('data', (data: any) => {
				log.info(data.toString());
			});

			let errorLine = '';
			let newErrorLine = true;
			let errorData = false;
			
			function parseData(data: string) {

			}

			compiler.stderr.on('data', (data: any) => {
				let str: string = data.toString();
				for (let char of str) {
					if (char === '\n') {
						if (errorData) {
							parseData(errorLine.trim());
						}
						else {
							log.error(errorLine.trim());
						}
						errorLine = '';
						newErrorLine = true;
						errorData = false;
					}
					else if (newErrorLine && char === '#') {
						errorData = true;
						newErrorLine = false;
					}
					else {
						errorLine += char;
						newErrorLine = false;
					}
				}
			});

			compiler.on('close', (code: number) => {
				if (code === 0) {
					resolve();
				}
				else {
					// process.exitCode = 1;
					reject('Shader compiler error.');
				}
			});
		}
		else {
			throw 'Could not find shader compiler.';
		}
	});
}

async function exportKoremakeProject(from: string, to: string, platform: string, options: any) {
	log.info('korefile found.');
	log.info('Creating ' + fromPlatform(platform) + ' project files.');

	let project: Project;
	try {
		project = await Project.create(from, platform);
		if (shaderLang(platform) === 'metal') {
			project.addFile('build/Sources/*', {});
		}
		project.searchFiles(undefined);
		project.flatten();
	}
	catch (error) {
		log.error(error);
		throw error;
	}

	fs.ensureDirSync(to);

	let files = project.getFiles();
	if (!options.noshaders) {
		let shaderCount = 0;
		for (let file of files) {
			if (file.file.endsWith('.glsl')) {
				++shaderCount;
			}
		}
		let shaderIndex = 0;
		for (let file of files) {
			if (file.file.endsWith('.glsl')) {
				let outfile = file.file;
				const index = outfile.lastIndexOf('/');
				if (index > 0) outfile = outfile.substr(index);
				outfile = outfile.substr(0, outfile.length - 5);

				let parsedFile = path.parse(file.file);
				log.info('Compiling shader ' + (shaderIndex + 1) + ' of ' + shaderCount + ' (' + parsedFile.name + ').');
				
				++shaderIndex;
				await compileShader(from, shaderLang(platform), file.file, path.join(project.getDebugDir(), outfile), 'build', platform, 'build');
			}
		}
	}

	// Run again to find new shader files for Metal
	project.searchFiles(undefined);
	project.flatten();

	let exporter: Exporter = null;
	if (platform === Platform.iOS || platform === Platform.OSX || platform === Platform.tvOS) exporter = new XCodeExporter();
	else if (platform === Platform.Android) exporter = new AndroidExporter();
	else if (platform === Platform.HTML5) exporter = new EmscriptenExporter();
	else if (platform === Platform.Linux || platform === Platform.Pi) exporter = new LinuxExporter();
	else if (platform === Platform.Tizen) exporter = new TizenExporter();
	else if (platform === Platform.PS4 || platform === Platform.XboxOne || platform === Platform.Switch) {
		let libsdir = path.join(from.toString(), 'Backends');
		if (fs.existsSync(libsdir) && fs.statSync(libsdir).isDirectory()) {
			let libdirs = fs.readdirSync(libsdir);
			for (let libdir of libdirs) {
				if (fs.statSync(path.join(from.toString(), 'Backends', libdir)).isDirectory()
				&& (libdir.toLowerCase() === platform.toLowerCase() || libdir.toLowerCase() === fromPlatform(platform).toLowerCase() )) {
					let libfiles = fs.readdirSync(path.join(from.toString(), 'Backends', libdir));
					for (let libfile of libfiles) {
						if (libfile.endsWith('Exporter.js')) {
							let Exporter = require(path.relative(__dirname, path.join(from.toString(), 'Backends', libdir, libfile)));
							exporter = new Exporter();
							break;
						}
					}
				}
			}
		}
	}
	else exporter = new VisualStudioExporter();

	if (exporter === null) {
		throw 'No exporter found for platform ' + platform + '.';
	}

	exporter.exportSolution(project, from, to, platform, options.vrApi, options);

	return project;
}

function isKoremakeProject(directory: string): boolean {
	return fs.existsSync(path.resolve(directory, 'korefile.js'));
}

async function exportProject(from: string, to: string, platform: string, options: any): Promise<Project> {
	if (isKoremakeProject(from)) {
		return exportKoremakeProject(from, to, platform, options);
	}
	else {
		throw 'korefile.js not found.';
	}
}

function compileProject(make: child_process.ChildProcess, project: Project, solutionName: string, options: any): Promise<void> {
	return new Promise<void>((resolve, reject) => {
		make.stdout.on('data', function (data: any) {
			log.info(data.toString(), false);
		});

		make.stderr.on('data', function (data: any) {
			log.error(data.toString(), false);
		});

		make.on('close', function (code: number) {
			if (code === 0) {
				if ((options.customTarget && options.customTarget.baseTarget === Platform.Linux) || options.target === Platform.Linux) {
					fs.copySync(path.join(path.join(options.to.toString(), options.buildPath), solutionName), path.join(options.from.toString(), project.getDebugDir(), solutionName), { overwrite: true });
				}
				else if ((options.customTarget && options.customTarget.baseTarget === Platform.Windows) || options.target === Platform.Windows) {
					fs.copySync(path.join(options.to.toString(), 'Release', solutionName + '.exe'), path.join(options.from.toString(), project.getDebugDir(), solutionName + '.exe'), { overwrite: true });
				}
				if (options.run) {
					if ((options.customTarget && options.customTarget.baseTarget === Platform.OSX) || options.target === Platform.OSX) {
						child_process.spawn('open', ['build/Release/' + solutionName + '.app/Contents/MacOS/' + solutionName], {stdio: 'inherit', cwd: options.to});
					}
					else if ((options.customTarget && (options.customTarget.baseTarget === Platform.Linux || options.customTarget.baseTarget === Platform.Windows)) || options.target === Platform.Linux || options.target === Platform.Windows) {
						child_process.spawn(path.resolve(path.join(options.from.toString(), project.getDebugDir(), solutionName)), [], {stdio: 'inherit', cwd: path.join(options.from.toString(), project.getDebugDir())});
					}
					else {
						log.info('--run not yet implemented for this platform');
					}
				}
			}
			else {
				log.error('Compilation failed.');
				process.exit(code);
			}
		});
	});
}

export let api = 2;

export async function run(options: any, loglog: any): Promise<string> {
	log.set(loglog);
	
	if (options.graphics !== undefined) {
		Options.graphicsApi = options.graphics;
	}
	
	if (options.visualstudio !== undefined) {
		Options.visualStudioVersion = options.visualstudio;	
	}

	if (!options.kore) {
		let p = path.join(__dirname, '..', '..', '..');
		if (fs.existsSync(p) && fs.statSync(p).isDirectory()) {
			options.kore = p;
		}
	}
	else {
		options.kore = path.resolve(options.kore);
	}

	debug = options.debug;
	
	if (options.vr !== undefined) {
		Options.vrApi = options.vr;
	}
	options.buildPath = options.debug ? 'Debug' : 'Release';
	
	let project: Project = null;
	try {
		project = await exportProject(options.from, options.to, options.target, options);
	}
	catch (error) {
		log.error(error);
		return '';
	}
	let solutionName = project.getName();
	
	if (options.compile && solutionName !== '') {
		log.info('Compiling...');
		
		let make: child_process.ChildProcess = null;

		if ((options.customTarget && options.customTarget.baseTarget === Platform.Linux) || options.target === Platform.Linux) {
			make = child_process.spawn('make', [], { cwd: path.join(options.to, options.buildPath) });
		}
		else if ((options.customTarget && (options.customTarget.baseTarget === Platform.OSX || options.customTarget.baseTarget === Platform.iOS)) || options.target === Platform.OSX || options.target === Platform.iOS) {
			make = child_process.spawn('xcodebuild', ['-configuration', options.debug ? 'Debug' : 'Release', '-project', solutionName + '.xcodeproj'], { cwd: options.to });
		}
		else if ((options.customTarget && options.customTarget.baseTarget === Platform.Windows) || options.target === Platform.Windows
			|| (options.customTarget && options.customTarget.baseTarget === Platform.WindowsApp) || options.target === Platform.WindowsApp) {
			let vsvars: string = null;
			switch (options.visualstudio) {
				case VisualStudioVersion.VS2017:
					const vspath = child_process.execFileSync(path.join(__dirname, '..', 'Data', 'windows', 'vswhere.exe'), ['-latest', '-property', 'installationPath'], {encoding: 'utf8'});
					const varspath = path.join(vspath.trim(), 'VC', 'Auxiliary', 'Build', 'vcvars32.bat');
					if (fs.existsSync(varspath)) {
						vsvars = varspath;
					}
					break;
				case VisualStudioVersion.VS2015:
					if (process.env.VS140COMNTOOLS) {
						vsvars = process.env.VS140COMNTOOLS + '\\vsvars32.bat';
					}
					break;
				case VisualStudioVersion.VS2013:
					if (process.env.VS120COMNTOOLS) {
						vsvars = process.env.VS120COMNTOOLS + '\\vsvars32.bat';
					}
					break;
				case VisualStudioVersion.VS2012:
					if (process.env.VS110COMNTOOLS) {
						vsvars = process.env.VS110COMNTOOLS + '\\vsvars32.bat';
					}
					break;
				case VisualStudioVersion.VS2010:
					if (process.env.VS100COMNTOOLS) {
						vsvars = process.env.VS100COMNTOOLS + '\\vsvars32.bat';
					}
					break;
			}
			if (vsvars !== null) {
				fs.writeFileSync(path.join(options.to, 'build.bat'), '@call "' + vsvars + '"\n' + '@MSBuild.exe "' + solutionName + '.vcxproj" /m /p:Configuration=' + (options.debug ? 'Debug' : 'Release') + ',Platform=Win32');
				make = child_process.spawn('build.bat', [], {cwd: options.to});
			}
			else {
				log.error('Visual Studio not found.');
			}
		}
		else if ((options.customTarget && options.customTarget.baseTarget === Platform.Android) || options.target === Platform.Android) {
			let gradlew = (process.platform === 'win32') ? 'gradlew.bat' : 'bash';
			let args = (process.platform === 'win32') ? [] : ['gradlew'];
			args.push('assemble' + (options.debug ? 'Debug' : 'Release') + 'Arm7');
			make = child_process.spawn(gradlew, args, { cwd: path.join(options.to, solutionName) });
		}

		if (make !== null) {
			await compileProject(make, project, solutionName, options);
			return solutionName;
		}
		else {
			log.info('--compile not yet implemented for this platform');
			return solutionName;
		}
	}
	return solutionName;
}
