import * as fs from 'fs-extra';
import * as path from 'path';
import {KhaExporter} from './KhaExporter';
import {convert} from '../Converter';
import {executeHaxe} from '../Haxe';
import {Options} from '../Options';
import {exportImage} from '../ImageTool';
import {Library} from '../Project';

export class KromExporter extends KhaExporter {
	width: number;
	height: number;

	constructor(options: Options) {
		super(options);
	}

	backend(): string {
		return 'Krom';
	}

	haxeOptions(name: string, targetOptions: any, defines: Array<string>) {
		defines.push('js-classic');

		defines.push('sys_' + this.options.target);
		defines.push('sys_g1');
		defines.push('sys_g2');
		defines.push('sys_g3');
		defines.push('sys_g4');
		defines.push('sys_a1');
		defines.push('sys_a2');

		defines.push('kha_js');
		defines.push('kha_' + this.options.target);
		defines.push('kha_' + this.options.target + '_js');
		defines.push('kha_' + this.options.graphics);
		defines.push('kha_g1');
		defines.push('kha_g2');
		defines.push('kha_g3');
		defines.push('kha_g4');
		defines.push('kha_a1');
		defines.push('kha_a2');

		this.parameters.push('-debug');
		
		return {
			from: this.options.from.toString(),
			to: path.join(this.sysdir(), 'krom.js.temp'),
			realto: path.join(this.sysdir(), 'krom.js'),
			sources: this.sources,
			libraries: this.libraries,
			defines: defines,
			parameters: this.parameters,
			haxeDirectory: this.options.haxe,
			system: this.sysdir(),
			language: 'js',
			width: this.width,
			height: this.height,
			name: name,
			main: this.options.main,
		};
	}

	async export(name: string, targetOptions: any, haxeOptions: any): Promise<void> {
		fs.ensureDirSync(path.join(this.options.to, this.sysdir()));
	}

	async copySound(platform: string, from: string, to: string) {
		fs.copySync(from.toString(), path.join(this.options.to, this.sysdir(), to + '.wav'), { overwrite: true });
		return [to + '.wav'];
	}

	async copyImage(platform: string, from: string, to: string, options: any, cache: any) {
		let format = await exportImage(this.options.kha, from, path.join(this.options.to, this.sysdir(), to), options, undefined, false, false, cache);
		return [to + '.' + format];
	}

	async copyBlob(platform: string, from: string, to: string) {
		fs.copySync(from.toString(), path.join(this.options.to, this.sysdir(), to), { overwrite: true });
		return [to];
	}

	async copyVideo(platform: string, from: string, to: string) {
		fs.ensureDirSync(path.join(this.options.to, this.sysdir(), path.dirname(to)));
		let webm = await convert(from, path.join(this.options.to, this.sysdir(), to + '.webm'), this.options.webm);
		let files: string[] = [];
		if (webm) files.push(to + '.webm');
		return files;
	}
}
