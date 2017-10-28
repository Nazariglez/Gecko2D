import * as child_process from 'child_process';
import * as fs from 'fs-extra';
import * as path from 'path';
import {KhaExporter} from './KhaExporter';
import {convert} from '../Converter';
import {executeHaxe} from '../Haxe';
import {Options} from '../Options';
import {exportImage} from '../ImageTool';
import * as log from '../log';
import {Library} from '../Project';

export class EmptyExporter extends KhaExporter {
	constructor(options: Options) {
		super(options);
	}

	backend(): string {
		return 'Empty';
	}

	haxeOptions(name: string, targetOptions: any, defines: Array<string>) {
		defines.push('sys_g1');
		defines.push('sys_g2');
		defines.push('sys_g3');
		defines.push('sys_g4');
		defines.push('sys_a1');
		defines.push('sys_a2');

		defines.push('kha_g1');
		defines.push('kha_g2');
		defines.push('kha_g3');
		defines.push('kha_g4');
		defines.push('kha_a1');
		defines.push('kha_a2');

		return {
			from: this.options.from,
			to: path.join(this.sysdir(), 'docs.xml'),
			sources: this.sources,
			libraries: this.libraries,
			defines: defines,
			parameters: this.parameters,
			haxeDirectory: this.options.haxe,
			system: this.sysdir(),
			language: 'xml',
			width: this.width,
			height: this.height,
			name: name,
			main: this.options.main,
		};
	}

	async export(name: string, _targetOptions: any, haxeOptions: any): Promise<void> {
		fs.ensureDirSync(path.join(this.options.to, this.sysdir()));

		let result = await executeHaxe(this.options.to, this.options.haxe, ['project-' + this.sysdir() + '.hxml']);
		if (result === 0) {
			let doxresult = child_process.spawnSync('haxelib', ['run', 'dox', '-in', 'kha.*', '-i', path.join('build', this.sysdir(), 'docs.xml')], { env: process.env, cwd: path.normalize(this.options.from) });
			if (doxresult.stdout.toString() !== '') {
				log.info(doxresult.stdout.toString());
			}

			if (doxresult.stderr.toString() !== '') {
				log.error(doxresult.stderr.toString());
			}
		}
	}

	async copySound(platform: string, from: string, to: string) {
		return [''];
	}

	async copyImage(platform: string, from: string, to: string, asset: any) {
		return [''];
	}

	async copyBlob(platform: string, from: string, to: string) {
		return [''];
	}

	async copyVideo(platform: string, from: string, to: string) {
		return [''];
	}
}
