import * as fs from 'fs-extra';
import * as path from 'path';
import {writeXml} from './XmlWriter';
import * as log from './log';

function copyAndReplace(from: string, to: string, names: string[], values: string[]) {
	let data = fs.readFileSync(from, { encoding: 'utf8' });
	for (let i = 0; i < names.length; ++i) {
		data = data.replace(new RegExp(names[i], 'g'), values[i]);
	}
	fs.writeFileSync(to, data, { encoding: 'utf8' });
}

function IntelliJ(projectdir: string, options: any) {
	let indir = path.join(__dirname, '..', 'Data', 'intellij');
	let outdir = path.join(projectdir, options.safeName + '-' + options.system + '-intellij');

	let sources = '';
	for (let i = 0; i < options.sources.length; ++i) {
		if (path.isAbsolute(options.sources[i])) {
			sources += '      <sourceFolder url="file://' + options.sources[i] + '" isTestSource="false" />\n';
		}
		else {
			sources += '      <sourceFolder url="file://$MODULE_DIR$/' + path.relative(outdir, path.resolve(options.from, options.sources[i])).replace(/\\/g, '/') + '" isTestSource="false" />\n';
		}
	}
		let libraries = '';
		for (let i = 0; i < options.libraries.length; ++i) {
		if (path.isAbsolute(options.libraries[i].libpath)) {
			libraries += '    <content url="file://' + options.libraries[i].libroot + '">\n';
			libraries += '      <sourceFolder url="file://' + options.libraries[i].libpath + '" isTestSource="false" />\n';
		}
		else {
			libraries += '    <content url="file://$MODULE_DIR$/' + path.relative(outdir, path.resolve(options.from, options.libraries[i].libroot)).replace(/\\/g, '/') + '">\n';
			libraries += '      <sourceFolder url="file://$MODULE_DIR$/' + path.relative(outdir, path.resolve(options.from, options.libraries[i].libpath)).replace(/\\/g, '/') + '" isTestSource="false" />\n';
		}
		libraries += '    </content>\n';
	}

	let args = '';

	let defines = '';
	for (let i = 0; i < options.defines.length; ++i) {
		defines += options.defines[i];
		if (i < options.defines.length - 1) defines += ',';
	}
	for (let param of options.parameters) {
		defines += param + ',';
	}

	let target: string;
	switch (options.language) {
		case 'hl':
		case 'cpp':
			target = 'C++';
			break;
		case 'as':
			target = 'Flash';
			args = '-swf-version 16.0';
			break;
		case 'cs':
			target = 'C#';
			if (fs.existsSync(options.haxeDirectory) && fs.statSync(options.haxeDirectory).isDirectory() && fs.existsSync(path.join(options.haxeDirectory, 'netlib'))) {
				args = '-net-std ' + path.relative(outdir, path.join(options.haxeDirectory, 'netlib'));
			}
			break;
		case 'java':
			target = 'Java';
			if (fs.existsSync(options.haxeDirectory) && fs.statSync(options.haxeDirectory).isDirectory() && fs.existsSync(path.join(options.haxeDirectory, 'hxjava', 'hxjava-std.jar'))) {
				args = '-java-lib ' + path.relative(outdir, path.join(options.haxeDirectory, 'hxjava', 'hxjava-std.jar'));
			}
			break;
		case 'js':
			target = 'JavaScript';
			break;
	}

	fs.copySync(path.join(indir, 'name.iml'), path.join(outdir, options.name + '.iml'), { clobber: true });
	copyAndReplace(path.join(indir, 'name.iml'), path.join(outdir, options.name + '.iml'), ['{name}', '{sources}', '{libraries}', '{target}', '{system}', '{args}'], [options.safeName, sources, libraries, target, options.system, args]);

	fs.copySync(path.join(indir, 'idea', 'compiler.xml'), path.join(outdir, '.idea', 'compiler.xml'), { clobber: true });
	copyAndReplace(path.join(indir, 'idea', 'haxe.xml'), path.join(outdir, '.idea', 'haxe.xml'), ['{defines}'], [defines]);
	fs.copySync(path.join(indir, 'idea', 'misc.xml'), path.join(outdir, '.idea', 'misc.xml'), { clobber: true });
	copyAndReplace(path.join(indir, 'idea', 'modules.xml'), path.join(outdir, '.idea', 'modules.xml'), ['{name}'], [options.name]);
	fs.copySync(path.join(indir, 'idea', 'vcs.xml'), path.join(outdir, '.idea', 'vcs.xml'), { clobber: true });
	copyAndReplace(path.join(indir, 'idea', 'name'), path.join(outdir, '.idea', '.name'), ['{name}'], [options.name]);
	fs.copySync(path.join(indir, 'idea', 'copyright', 'profiles_settings.xml'), path.join(outdir, '.idea', 'copyright', 'profiles_settings.xml'), { clobber: true });
}

function hxml(projectdir: string, options: any) {
	let data = '';
	for (let i = 0; i < options.sources.length; ++i) {
		if (path.isAbsolute(options.sources[i])) {
			data += '-cp ' + options.sources[i] + '\n';
		}
		else {
			data += '-cp ' + path.relative(projectdir, path.resolve(options.from, options.sources[i])) + '\n'; // from.resolve('build').relativize(from.resolve(this.sources[i])).toString());
		}
	}
	for (let i = 0; i < options.libraries.length; ++i) {
		if (path.isAbsolute(options.libraries[i].libpath)) {
			data += '-cp ' + options.libraries[i].libpath + '\n';
		}
		else {
			data += '-cp ' + path.relative(projectdir, path.resolve(options.from, options.libraries[i].libpath)) + '\n'; // from.resolve('build').relativize(from.resolve(this.sources[i])).toString());
		}
	}
	for (let d in options.defines) {
		let define = options.defines[d];
		data += '-D ' + define + '\n';
	}
	if (options.language === 'cpp') {
		data += '-cpp ' + path.normalize(options.to) + '\n';
	}
	else if (options.language === 'cs') {
		data += '-cs ' + path.normalize(options.to) + '\n';
		if (fs.existsSync(options.haxeDirectory) && fs.statSync(options.haxeDirectory).isDirectory() && fs.existsSync(path.join(options.haxeDirectory, 'netlib'))) {
			data += '-net-std ' + path.relative(projectdir, path.join(options.haxeDirectory, 'netlib')) + '\n';
		}
	}
	else if (options.language === 'java') {
		data += '-java ' + path.normalize(options.to) + '\n';
		if (fs.existsSync(options.haxeDirectory) && fs.statSync(options.haxeDirectory).isDirectory() && fs.existsSync(path.join(options.haxeDirectory, 'hxjava', 'hxjava-std.jar'))) {
			data += '-java-lib ' + path.relative(projectdir, path.join(options.haxeDirectory, 'hxjava', 'hxjava-std.jar')) + '\n';
		}
	}
	else if (options.language === 'js') {
		data += '-js ' + path.normalize(options.to) + '\n';
	}
	else if (options.language === 'as') {
		data += '-swf ' + path.normalize(options.to) + '\n';
		data += '-swf-version ' + options.swfVersion + '\n';
		data += '-swf-header ' + options.width + ':' + options.height + ':' + options.framerate + ':' + options.stageBackground + '\n';
	}
	else if (options.language === 'xml') {
		data += '-xml ' + path.normalize(options.to) + '\n';
		data += '--macro include(\'kha\')\n';
	}
	else if (options.language === 'hl') {
		data += '-hl ' + path.normalize(options.to) + '\n';
	}
	for (let param of options.parameters) {
		data += param + '\n';
	}
	data += '-main Main' + '\n';
	fs.outputFileSync(path.join(projectdir, 'project-' + options.system + '.hxml'), data);
}

function FlashDevelop(projectdir: string, options: any) {
	let platform: string;

	switch (options.language) {
		case 'hl':
		case 'cpp':
			platform = 'C++';
			break;
		case 'as':
			platform = 'Flash Player';
			break;
		case 'cs':
			platform = 'C#';
			break;
		case 'java':
			platform = 'Java';
			break;
		case 'js':
			platform = 'JavaScript';
			break;
	}

	options.swfVersion = 'swfVersion' in options ? options.swfVersion : 16.0;
	options.stageBackground = 'stageBackground' in options ? options.stageBackground : 'ffffff';
	options.framerate = 'framerate' in options ? options.framerate : 30;

	let swfVersion = parseFloat(options.swfVersion).toFixed(1).split('.');

	let output: any = {
		n: 'output',
		e: [
			{
				n: 'movie',
				outputType: 'Application'
			},
			{
				n: 'movie',
				input: ''
			},
			{
				n: 'movie',
				path: path.normalize(options.to)
			},
			{
				n: 'movie',
				fps: options.framerate
			},
			{
				n: 'movie',
				width: options.width
			},
			{
				n: 'movie',
				height: options.height
			},
			{
				n: 'movie',
				version: swfVersion[0]
			},
			{
				n: 'movie',
				minorVersion: swfVersion[1]
			},
			{
				n: 'movie',
				platform: platform
			},
			{
				n: 'movie',
				background: '#' + options.stageBackground
			}
		]
	};

	if (fs.existsSync(options.haxeDirectory) && fs.statSync(options.haxeDirectory).isDirectory()) {
		output.e.push({
			n: 'movie',
			preferredSDK: path.relative(projectdir, options.haxeDirectory)
		});
	}

	let classpaths: string[] = [];

	for (let i = 0; i < options.sources.length; ++i) {
		classpaths.push(path.relative(projectdir, path.resolve(options.from, options.sources[i])));
	}

	for (let i = 0; i < options.libraries.length; ++i) {
		classpaths.push(path.relative(projectdir, path.resolve(options.from, options.libraries[i].libpath)));
	}

	let otheroptions: any = [
		{
			n: 'option',
			showHiddenPaths: 'False'
		}
	];

	if (options.language === 'cpp' || options.system === 'krom') {
		otheroptions.push({
			n: 'option',
			testMovie: 'Custom'
		});
		otheroptions.push({
			n: 'option',
			testMovieCommand: 'run_' + options.system + '.bat'
		});
	}
	else if (options.language === 'cs' || options.language === 'java') {
		otheroptions.push({
			n: 'option',
			testMovie: 'OpenDocument'
		});
		otheroptions.push({
			n: 'option',
			testMovieCommand: ''
		});
	}
	else if (options.language === 'js') {
		otheroptions.push({
			n: 'option',
			testMovie: 'Webserver'
		});
		otheroptions.push({
			n: 'option',
			testMovieCommand: path.join(path.parse(options.to).dir, 'index.html')
		});
	}
	else {
		otheroptions.push({
			n: 'option',
			testMovie: 'Default'
		});
	}

	let def = '';
	for (let d of options.defines) {
		def += '-D ' + d + '&#xA;';
	}
	if (options.language === 'java' && fs.existsSync(options.haxeDirectory) && fs.statSync(options.haxeDirectory).isDirectory() && fs.existsSync(path.join(options.haxeDirectory, 'hxjava', 'hxjava-std.jar'))) {
		def += '-java-lib ' + path.relative(projectdir, path.join(options.haxeDirectory, 'hxjava', 'hxjava-std.jar')) + '&#xA;';
	}
	if (options.language === 'cs' && fs.existsSync(options.haxeDirectory) && fs.statSync(options.haxeDirectory).isDirectory() && fs.existsSync(path.join(options.haxeDirectory, 'netlib'))) {
		def += '-net-std ' + path.relative(projectdir, path.join(options.haxeDirectory, 'netlib')) + '&#xA;';
	}
	def += '-D kha_output=&quot;' + path.resolve(path.join(projectdir, options.to)) + '&quot;&#xA;';
	for (let param of options.parameters) {
		def += param + '&#xA;';
	}

	let project = {
		n: 'project',
		version: '2',
		e: [
			'Output SWF options',
			output,
			'Other classes to be compiled into your SWF',
			{
				n: 'classpaths',
				e: classpaths
				.reduce((a, b) => {
					if (a.indexOf(b) < 0) a.push(b);
					return a;
				}, [] )
				.map((e) => {
					return {n: 'class', path: e};
				})
			},
			'Build options',
			{
				n: 'build',
				e: [
					{
						n: 'option',
						directives: ''
					},
					{
						n: 'option',
						flashStrict: 'False'
					},
					{
						n: 'option',
						noInlineOnDebug: 'False'
					},
					{
						n: 'option',
						mainClass: 'Main'
					},
					{
						n: 'option',
						enabledebug: options.language === 'as' ? 'True' : 'False'
					},
					{
						n: 'option',
						additional: def
					}
				]
			},
			'haxelib libraries',
			{
				n: 'haxelib',
				e: [
					'example: <library name="..." />'
				]
			},
			'Class files to compile (other referenced classes will automatically be included)',
			{
				n: 'compileTargets',
				e: [
					{
						n: 'compile',
						path: '..\\Sources\\Main.hx'
					}
				]
			},
			'Paths to exclude from the Project Explorer tree',
			{
				n: 'hiddenPaths',
				e: [
					'example: <hidden path="..." />'
				]
			},
			'Executed before build',
			{
				n: 'preBuildCommand'
			},
			'Executed after build',
			{
				n: 'postBuildCommand',
				alwaysRun: 'False'
			},
			'Other project options',
			{
				n: 'options',
				e: otheroptions
			},
			'Plugin storage',
			{
				n: 'storage'
			}
		]
	};

	writeXml(project, path.join(projectdir, options.safeName + '-' + options.system + '.hxproj'));
}

export function writeHaxeProject(projectdir: string, options: any) {
	hxml(projectdir, options);
	FlashDevelop(projectdir, options);
	IntelliJ(projectdir, options);
}
