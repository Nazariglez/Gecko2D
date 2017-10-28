import * as fs from 'fs-extra';
import * as path from 'path';
import {KhaExporter} from './KhaExporter';
import {convert} from '../Converter';
import {executeHaxe} from '../Haxe';
import {Options} from '../Options';
import {exportImage} from '../ImageTool';
import {Library} from '../Project';

export class JavaExporter extends KhaExporter {
	constructor(options: Options) {
		super(options);
		fs.removeSync(path.join(this.options.to, this.sysdir(), 'Sources'));
	}

	haxeOptions(name: string, targetOptions: any, defines: Array<string>) {
		defines.push('no-compilation');

		defines.push('sys_' + this.options.target);
		defines.push('sys_g1');
		defines.push('sys_g2');
		defines.push('sys_a1');

		defines.push('kha_' + this.options.target);
		if (this.options.target !== 'java') {
			defines.push('kha_java');
			defines.push('kha_' + this.options.target + '_java');
		}
		defines.push('kha_g1');
		defines.push('kha_g2');
		defines.push('kha_a1');

		return {
			from: this.options.from,
			to: path.join(this.sysdir(), 'Sources'),
			sources: this.sources,
			libraries: this.libraries,
			defines: defines,
			parameters: this.parameters,
			haxeDirectory: this.options.haxe,
			system: this.sysdir(),
			language: 'java',
			width: this.width,
			height: this.height,
			name: name,
			main: this.options.main,
		};
	}

	async export(name: string, targetOptions: any, haxeOptions: any): Promise<void> {
		fs.ensureDirSync(path.join(this.options.to, this.sysdir()));
		this.exportEclipseProject();
	}

	backend() {
		return 'Java';
	}

	exportEclipseProject() {
		this.writeFile(path.join(this.options.to, this.sysdir(), '.classpath'));
		this.p('<?xml version="1.0" encoding="UTF-8"?>');
		this.p('<classpath>');
		this.p('\t<classpathentry kind="src" path="Sources/src"/>');
		this.p('\t<classpathentry kind="con" path="org.eclipse.jdt.launching.JRE_CONTAINER"/>');
		this.p('\t<classpathentry kind="output" path="bin"/>');
		this.p('</classpath>');
		this.closeFile();

		this.writeFile(path.join(this.options.to, this.sysdir(), '.project'));
		this.p('<?xml version="1.0" encoding="UTF-8"?>');
		this.p('<projectDescription>');
		this.p('\t<name>' + path.parse(this.options.to).name + '</name>');
		this.p('\t<comment></comment>');
		this.p('\t<projects>');
		this.p('\t</projects>');
		this.p('\t<buildSpec>');
		this.p('\t\t<buildCommand>');
		this.p('\t\t\t<name>org.eclipse.jdt.core.javabuilder</name>');
		this.p('\t\t\t<arguments>');
		this.p('\t\t\t</arguments>');
		this.p('\t\t</buildCommand>');
		this.p('\t</buildSpec>');
		this.p('\t<natures>');
		this.p('\t\t<nature>org.eclipse.jdt.core.javanature</nature>');
		this.p('\t</natures>');
		this.p('</projectDescription>');
		this.closeFile();
	}

	/*copyMusic(platform, from, to, encoders) {
		this.copyFile(from, this.directory.resolve(this.sysdir()).resolve(to + '.wav'));
		callback([to + '.wav']);
	}*/

	async copySound(platform: string, from: string, to: string) {
		fs.copySync(from.toString(), path.join(this.options.to, this.sysdir(), to + '.wav'), { overwrite: true });
		return [to + '.wav'];
	}

	async copyImage(platform: string, from: string, to: string, asset: any, cache: any) {
		let format = await exportImage(this.options.kha, from, path.join(this.options.to, this.sysdir(), to), asset, undefined, false, false, cache);
		return [to + '.' + format];
	}

	async copyBlob(platform: string, from: string, to: string) {
		fs.copySync(from.toString(), path.join(this.options.to, this.sysdir(), to), { overwrite: true });
		return [to];
	}

	async copyVideo(platform: string, from: string, to: string) {
		return [to];
	}
}
