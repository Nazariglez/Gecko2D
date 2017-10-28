import * as fs from 'fs-extra';
import * as path from 'path';
import {KhaExporter} from './KhaExporter';
import {convert} from '../Converter';
import {executeHaxe} from '../Haxe';
import {Options} from '../Options';
import {exportImage} from '../ImageTool';
import {Library} from '../Project';
const uuid = require('uuid');

export class UnityExporter extends KhaExporter {
	constructor(options: Options) {
		super(options);
		fs.removeSync(path.join(this.options.to, this.sysdir(), 'Assets', 'Sources'));
	}

	backend(): string {
		return 'Unity';
	}

	haxeOptions(name: string, targetOptions: any, defines: Array<string>) {
		defines.push('no-root');
		defines.push('no-compilation');

		defines.push('sys_' + this.options.target);
		defines.push('sys_g1');
		defines.push('sys_g2');
		defines.push('sys_g3');
		defines.push('sys_g4');
		defines.push('sys_a1');

		defines.push('kha_cs');
		defines.push('kha_' + this.options.target);
		defines.push('kha_' + this.options.target + '_cs');
		defines.push('kha_g1');
		defines.push('kha_g2');
		defines.push('kha_g3');
		defines.push('kha_g4');
		defines.push('kha_a1');

		return {
			from: this.options.from,
			to: path.join(this.sysdir(), 'Assets', 'Sources'),
			sources: this.sources,
			libraries: this.libraries,
			defines: defines,
			parameters: this.parameters,
			haxeDirectory: this.options.haxe,
			system: this.sysdir(),
			language: 'cs',
			width: this.width,
			height: this.height,
			name: name,
			main: this.options.main,
		};
	}

	async export(name: string, targetOptions: any, haxeOptions: any): Promise<void> {
		let copyDirectory = (from: string, to: string) => {
			let files = fs.readdirSync(path.join(__dirname, '..', '..', 'Data', 'unity', from));
			fs.ensureDirSync(path.join(this.options.to, this.sysdir(), to));
			for (let file of files) {
				let text = fs.readFileSync(path.join(__dirname, '..', '..', 'Data', 'unity', from, file), 'utf8');
				fs.writeFileSync(path.join(this.options.to, this.sysdir(), to, file), text);
			}
		};
		copyDirectory('Assets', 'Assets');
		copyDirectory('Editor', 'Assets/Editor');
		copyDirectory('ProjectSettings', 'ProjectSettings');
	}

	/*copyMusic(platform, from, to, encoders, callback) {
		callback([to]);
	}*/

	async copySound(platform: string, from: string, to: string) {
		let ogg = await convert(from, path.join(this.options.to, this.sysdir(), 'Assets', 'Resources', 'Sounds', to + '.ogg'), this.options.ogg);
		return [to + '.ogg'];
	}

	async copyImage(platform: string, from: string, to: string, asset: any, cache: any) {
		let format = await exportImage(this.options.kha, from, path.join(this.options.to, this.sysdir(), 'Assets', 'Resources', 'Images', to), asset, undefined, false, true, cache);
		return [to + '.' + format];
	}

	async copyBlob(platform: string, from: string, to: string) {
		fs.copySync(from.toString(), path.join(this.options.to, this.sysdir(), 'Assets', 'Resources', 'Blobs', to + '.bytes'), { overwrite: true });
		return [to];
	}

	async copyVideo(platform: string, from: string, to: string) {
		return [to];
	}
}
