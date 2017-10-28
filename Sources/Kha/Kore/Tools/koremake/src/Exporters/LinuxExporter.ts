import {Exporter} from './Exporter';
import {GraphicsApi} from '../GraphicsApi';
import {Options} from '../Options';
import {Platform} from '../Platform';
import {Project} from '../Project';
import * as fs from 'fs-extra';
import * as path from 'path';

export class LinuxExporter extends Exporter {
	constructor() {
		super();
	}

	exportSolution(project: Project, from: string, to: string, platform: string, vrApi: any, options: any) {
		this.exportMakefile(project, from, to, platform, vrApi, options);
		this.exportCodeBlocks(project, from, to, platform, vrApi, options);
		this.exportCLion(project, from, to, platform, vrApi, options);
	}
	
	exportMakefile(project: Project, from: string, to: string, platform: string, vrApi: any, options: any) {
		let objects: any = {};
		let ofiles: any = {};
		let outputPath = path.resolve(to, options.buildPath);
		fs.ensureDirSync(outputPath);

		for (let fileobject of project.getFiles()) {
			let file = fileobject.file;
			if (file.endsWith('.cpp') || file.endsWith('.c') || file.endsWith('.cc')) {
				let name = file.toLowerCase();
				if (name.indexOf('/') >= 0) name = name.substr(name.lastIndexOf('/') + 1);
				name = name.substr(0, name.lastIndexOf('.'));
				if (!objects[name]) {
					objects[name] = true;
					ofiles[file] = name;
				}
				else {
					while (objects[name]) {
						name = name + '_';
					}
					objects[name] = true;
					ofiles[file] = name;
				}
			}
		}
		
		let gchfilelist = '';
		let precompiledHeaders: string[] = [];
		for (let file of project.getFiles()) {
			if (file.options && file.options.pch && precompiledHeaders.indexOf(file.options.pch) < 0) {
				precompiledHeaders.push(file.options.pch);
			}
		}
		for (let file of project.getFiles()) {
			let precompiledHeader: string = null;
			for (let header of precompiledHeaders) {
				if (file.file.endsWith(header)) {
					precompiledHeader = header;
					break;
				}
			}
			if (precompiledHeader !== null) {
				// let realfile = path.relative(outputPath, path.resolve(from, file.file));
				gchfilelist += path.basename(file.file) + '.gch ';
			}
		}
		
		let ofilelist = '';
		for (let o in objects) {
			ofilelist += o + '.o ';
		}
		
		this.writeFile(path.resolve(outputPath, 'makefile'));

		let incline = '-I./ '; // local directory to pick up the precompiled header hxcpp.h.gch
		for (let inc of project.getIncludeDirs()) {
			inc = path.relative(outputPath, path.resolve(from, inc));
			incline += '-I' + inc + ' ';
		}
		this.p('INC=' + incline);

		let libsline = '-static-libgcc -static-libstdc++ -pthread';
		for (let lib of project.getLibs()) {
			libsline += ' -l' + lib;
		}
		this.p('LIB=' + libsline);

		let defline = '';
		for (let def of project.getDefines()) {
			defline += '-D' + def + ' ';
		}
		this.p('DEF=' + defline);
		this.p();

		let optimization = '';
		if (!options.debug) optimization = '-O2';

		this.p(project.getName() + ': ' + gchfilelist + ofilelist);
		
		let cpp = '';
		if (project.cpp11) {
			cpp = '-std=c++11';
		}

		this.p('\tg++ ' + cpp + ' ' + optimization + ' ' + ofilelist + ' -o "' + project.getName() + '" $(LIB)');
		
		for (let file of project.getFiles()) {
			let precompiledHeader: string = null;
			for (let header of precompiledHeaders) {
				if (file.file.endsWith(header)) {
					precompiledHeader = header;
					break;
				}
			}
			if (precompiledHeader !== null) {
				let realfile = path.relative(outputPath, path.resolve(from, file.file));
				this.p(path.basename(realfile) + '.gch: ' + realfile);
				let compiler = 'g++';
				this.p('\t' + compiler + ' ' + cpp + ' ' + optimization + ' $(INC) $(DEF) -c ' + realfile + ' -o ' + path.basename(file.file) + '.gch $(LIB)');
			}
		}

		for (let fileobject of project.getFiles()) {
			let file = fileobject.file;
			if (file.endsWith('.c') || file.endsWith('.cpp') || file.endsWith('cc')) {
				this.p();
				let name = ofiles[file];
				let realfile = path.relative(outputPath, path.resolve(from, file));
				this.p(name + '.o: ' + realfile);
				let compiler = 'g++';
				if (file.endsWith('.c')) compiler = 'gcc';
				this.p('\t' + compiler + ' ' + cpp + ' ' + optimization + ' $(INC) $(DEF) -c ' + realfile + ' -o ' + name + '.o $(LIB)');
			}
		}

		// project.getDefines()
		// project.getIncludeDirs()

		this.closeFile();
	}

	exportCodeBlocks(project: Project, from: string, to: string, platform: string, vrApi: any, options: any) {
		this.writeFile(path.resolve(to, project.getName() + '.cbp'));
		this.p('<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>');
		this.p('<CodeBlocks_project_file>');
		this.p('<FileVersion major="1" minor="6" />', 1);
		this.p('<Project>', 1);
		this.p('<Option title="' + project.getName() + '" />', 2);
		this.p('<Option pch_mode="2" />', 2);
		this.p('<Option compiler="gcc" />', 2);
		this.p('<Build>', 2);
		this.p('<Target title="Debug">', 3);
		this.p('<Option output="bin/Debug/' + project.getName() + '" prefix_auto="1" extension_auto="1" />', 4);
		if (project.getDebugDir().length > 0) this.p('<Option working_dir="' + path.resolve(from, project.getDebugDir()) + '" />', 4);
		this.p('<Option object_output="obj/Debug/" />', 4);
		this.p('<Option type="1" />', 4);
		this.p('<Option compiler="gcc" />', 4);
		this.p('<Compiler>', 4);
		if (project.cpp11) {
			this.p('<Add option="-std=c++11" />', 5);
		}
		this.p('<Add option="-g" />', 5);
		this.p('</Compiler>', 4);
		this.p('</Target>', 3);
		this.p('<Target title="Release">', 3);
		this.p('<Option output="bin/Release/' + project.getName() + '" prefix_auto="1" extension_auto="1" />', 4);
		if (project.getDebugDir().length > 0) this.p('<Option working_dir="' + path.resolve(from, project.getDebugDir()) + '" />', 4);
		this.p('<Option object_output="obj/Release/" />', 4);
		this.p('<Option type="0" />', 4);
		this.p('<Option compiler="gcc" />', 4);
		this.p('<Compiler>', 4);
		if (project.cpp11) {
			this.p('<Add option="-std=c++11" />', 5);
		}
		this.p('<Add option="-O2" />', 5);
		this.p('</Compiler>', 4);
		this.p('<Linker>', 4);
		this.p('<Add option="-s" />', 5);
		this.p('</Linker>', 4);
		this.p('</Target>', 3);
		this.p('</Build>', 2);
		this.p('<Compiler>', 2);
		if (project.cpp11) {
			this.p('<Add option="-std=c++11" />', 3);
		}
		this.p('<Add option="-Wall" />', 3);
		for (let def of project.getDefines()) {
			this.p('<Add option="-D' + def.replace(/\"/g, '\\"') + '" />', 3);
		}
		for (let inc of project.getIncludeDirs()) {
			this.p('<Add directory="' + path.resolve(from, inc) + '" />', 3);
		}
		this.p('</Compiler>', 2);
		this.p('<Linker>', 2);
		this.p('<Add option="-pthread" />', 3);
		this.p('<Add option="-static-libgcc" />', 3);
		this.p('<Add option="-static-libstdc++" />', 3);
		this.p('<Add option="-Wl,-rpath,." />', 3);
		for (let lib of project.getLibs()) {
			this.p('<Add library="' + lib + '" />', 3);
		}
		if (platform === Platform.Pi) {
			this.p('<Add directory="/opt/vc/lib" />', 3);
		}
		this.p('</Linker>', 2);
		
		let precompiledHeaders: string[] = [];
		for (let file of project.getFiles()) {
			if (file.options && file.options.pch && precompiledHeaders.indexOf(file.options.pch) < 0) {
				precompiledHeaders.push(file.options.pch);
			}
		}
		for (let file of project.getFiles()) {
			let precompiledHeader: string = null;
			for (let header of precompiledHeaders) {
				if (file.file.endsWith(header)) {
					precompiledHeader = header;
					break;
				}
			}
			
			if (file.file.endsWith('.c') || file.file.endsWith('.cc') || file.file.endsWith('.cpp')) {
				this.p('<Unit filename="' + path.resolve(from, file.file) + '">', 2);
				this.p('<Option compilerVar="CC" />', 3);
				this.p('</Unit>', 2);
			}
			else if (file.file.endsWith('.h')) {
				this.p('<Unit filename="' + path.resolve(from, file.file) + '">', 2);
				if (precompiledHeader !== null) {
					this.p('<Option compile="1" />', 3);
					this.p('<Option weight="0" />', 3);
				}
				this.p('</Unit>', 2);
			}
		}
		this.p('<Extensions>', 2);
		this.p('<code_completion />', 3);
		this.p('<debugger />', 3);
		this.p('</Extensions>', 2);
		this.p('</Project>', 1);
		this.p('</CodeBlocks_project_file>');
		this.closeFile();
	}

	exportCLion(project: Project, from: string, to: string, platform: string, vrApi: any, options: any) {
		let name = project.getName().replace(/ /g, '_');

		const indir = path.join(__dirname, '..', '..', 'Data', 'linux');
		fs.ensureDirSync(path.resolve(to, project.getName(), '.idea'));
		
		let misc = fs.readFileSync(path.join(indir, 'idea', 'misc.xml'), 'utf8');
		misc = misc.replace(/{root}/g, path.resolve(from));
		fs.writeFileSync(path.join(to, project.getName(), '.idea', 'misc.xml'), misc, 'utf8');

		let workspace = fs.readFileSync(path.join(indir, 'idea', 'workspace.xml'), 'utf8');
		workspace = workspace.replace(/{workingdir}/g, path.resolve(project.getDebugDir()));
		workspace = workspace.replace(/{project}/g, project.getName());
		workspace = workspace.replace(/{target}/g, name);
		fs.writeFileSync(path.join(to, project.getName(), '.idea', 'workspace.xml'), workspace, 'utf8');

		this.writeFile(path.resolve(to, project.getName(), 'CMakeLists.txt'));

		this.p('cmake_minimum_required(VERSION 3.6)');
		this.p('project(' + name + ')');
		
		if (project.cpp11) {
			this.p('set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -pthread -static-libgcc -static-libstdc++")');
		}
		else {
			this.p('set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pthread -static-libgcc -static-libstdc++")');
		}

		let defines = '';
		for (let def of project.getDefines()) {
			defines += '  -D' + def + '\n';
		}
		this.p('add_definitions(\n' + defines + ')');

		let includes = '';
		for (let inc of project.getIncludeDirs()) {
			includes += '  "' + path.resolve(inc).replace(/\\/g, '/') + '"\n';
		}
		this.p('include_directories(\n' + includes + ')');

		let files = '';
		for (let file of project.getFiles()) {
			if (file.file.endsWith('.c') || file.file.endsWith('.cc') || file.file.endsWith('.cpp') || file.file.endsWith('.h')) {
				files += '  "' + path.resolve(file.file).replace(/\\/g, '/') + '"\n';
			}
		}
		this.p('set(SOURCE_FILES\n' + files + ')');

		this.p('add_executable(' + name + ' ${SOURCE_FILES})');

		let libraries = '';
		for (let lib of project.getLibs()) {
			libraries += '  ' + lib + '\n';
		}
		this.p('target_link_libraries(' + name + '\n' + libraries + ')');

		this.closeFile();
	}
}
