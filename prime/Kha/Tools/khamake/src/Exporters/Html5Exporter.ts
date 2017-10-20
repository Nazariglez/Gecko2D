import * as fs from 'fs-extra';
import * as path from 'path';
import {KhaExporter} from './KhaExporter';
import {convert} from '../Converter';
import {executeHaxe} from '../Haxe';
import {Options} from '../Options';
import {exportImage} from '../ImageTool';
import {Library} from '../Project';

export class Html5Exporter extends KhaExporter {
	parameters: Array<string>;
	width: number;
	height: number;

	constructor(options: Options) {
		super(options);
		this.addSourceDirectory(path.join(options.kha, 'Backends', 'HTML5'));
	}

	isDebugHtml5() {
		return this.sysdir() === 'debug-html5';
	}

	isNode() {
		return this.sysdir() === 'node';
	}

	haxeOptions(name: string, targetOptions: any, defines: Array<string>) {
		defines.push('sys_g1');
		defines.push('sys_g2');
		defines.push('sys_g3');
		defines.push('sys_g4');
		defines.push('sys_a1');
		defines.push('sys_a2');

		defines.push('kha_js');
		defines.push('kha_g1');
		defines.push('kha_g2');
		defines.push('kha_g3');
		defines.push('kha_g4');
		defines.push('kha_a1');
		defines.push('kha_a2');

		if (targetOptions.html5.noKeyboard) {
			defines.push('kha_no_keyboard');
		}

		let canvasId = targetOptions.html5.canvasId == null ? 'khanvas' : targetOptions.html5.canvasId;
		
		defines.push('canvas_id=' + canvasId);

		let scriptName = 'kha';
		if (targetOptions.html5.scriptName != null && !(this.isNode() || this.isDebugHtml5())) {
			scriptName = targetOptions.html5.scriptName;
		}

		defines.push('script_name=' + scriptName);

		let webgl = targetOptions.html5.webgl == null ? true : targetOptions.html5.webgl;

		if (webgl) {
			defines.push('kha_webgl');
		}

		if (this.isNode()) {
			defines.push('nodejs');

			defines.push('sys_node');
			defines.push('sys_server');

			defines.push('kha_node');
			defines.push('kha_server');
		}
		else {
			defines.push('sys_' + this.options.target);

			defines.push('kha_' + this.options.target);
			defines.push('kha_' + this.options.target + '_js');
		}

		if (this.isDebugHtml5()) {
			this.parameters.push('-debug');
			
			defines.push('sys_debug_html5');

			defines.push('kha_debug_html5');
		}

		return {
			from: this.options.from.toString(),
			to: path.join(this.sysdir(), scriptName + '.js'),
			sources: this.sources,
			libraries: this.libraries,
			defines: defines,
			parameters: this.parameters,
			haxeDirectory: this.options.haxe,
			system: this.sysdir(),
			language: 'js',
			width: this.width,
			height: this.height,
			name: name
		};
	}

	async export(name: string, _targetOptions: any, haxeOptions: any): Promise<void> {
		let targetOptions = {
			canvasId: 'khanvas',
			scriptName: 'kha'
		};

		if (_targetOptions != null && _targetOptions.html5 != null) {
			let userOptions = _targetOptions.html5;
			if (userOptions.canvasId != null) targetOptions.canvasId = userOptions.canvasId;
			if (userOptions.scriptName != null) targetOptions.scriptName = userOptions.scriptName;
		}

		fs.ensureDirSync(path.join(this.options.to, this.sysdir()));

		if (this.isDebugHtml5()) {
			let index = path.join(this.options.to, this.sysdir(), 'index.html');
			if (!fs.existsSync(index)) {
				let protoindex = fs.readFileSync(path.join(__dirname, '..', '..', 'Data', 'debug-html5', 'index.html'), {encoding: 'utf8'});
				protoindex = protoindex.replace(/{Name}/g, name);
				protoindex = protoindex.replace(/{Width}/g, '' + this.width);
				protoindex = protoindex.replace(/{Height}/g, '' + this.height);
				protoindex = protoindex.replace(/{CanvasId}/g, '' + targetOptions.canvasId);
				protoindex = protoindex.replace(/{ScriptName}/g, '' + targetOptions.scriptName);
				fs.writeFileSync(index.toString(), protoindex);
			}

			let pack = path.join(this.options.to, this.sysdir(), 'package.json');
			let protopackage = fs.readFileSync(path.join(__dirname, '..', '..', 'Data', 'debug-html5', 'package.json'), {encoding: 'utf8'});
			protopackage = protopackage.replace(/{Name}/g, name);
			fs.writeFileSync(pack.toString(), protopackage);

			let electron = path.join(this.options.to, this.sysdir(), 'electron.js');
			let protoelectron = fs.readFileSync(path.join(__dirname, '..', '..', 'Data', 'debug-html5', 'electron.js'), {encoding: 'utf8'});
			protoelectron = protoelectron.replace(/{Width}/g, '' + this.width);
			protoelectron = protoelectron.replace(/{Height}/g, '' + this.height);
			fs.writeFileSync(electron.toString(), protoelectron);
		}
		else if (this.isNode()) {
			let pack = path.join(this.options.to, this.sysdir(), 'package.json');
			let protopackage = fs.readFileSync(path.join(__dirname, '..', '..', 'Data', 'node', 'package.json'), 'utf8');
			protopackage = protopackage.replace(/{Name}/g, name);
			fs.writeFileSync(pack, protopackage);

			let protoserver = fs.readFileSync(path.join(__dirname, '..', '..', 'Data', 'node', 'server.js'), 'utf8');
			fs.writeFileSync(path.join(this.options.to, this.sysdir(), 'server.js'), protoserver);
		}
		else {
			let index = path.join(this.options.to, this.sysdir(), 'index.html');
			if (!fs.existsSync(index)) {
				let protoindex = fs.readFileSync(path.join(__dirname, '..', '..', 'Data', 'html5', 'index.html'), {encoding: 'utf8'});
				protoindex = protoindex.replace(/{Name}/g, name);
				protoindex = protoindex.replace(/{Width}/g, '' + this.width);
				protoindex = protoindex.replace(/{Height}/g, '' + this.height);
				protoindex = protoindex.replace(/{CanvasId}/g, '' + targetOptions.canvasId);
				protoindex = protoindex.replace(/{ScriptName}/g, '' + targetOptions.scriptName);
				fs.writeFileSync(index.toString(), protoindex);
			}
		}
	}

	/*copyMusic(platform, from, to, encoders, callback) {
		Files.createDirectories(this.directory.resolve(this.sysdir()).resolve(to).parent());
		Converter.convert(from, this.directory.resolve(this.sysdir()).resolve(to + '.ogg'), encoders.oggEncoder, (ogg) => {
			Converter.convert(from, this.directory.resolve(this.sysdir()).resolve(to + '.mp4'), encoders.aacEncoder, (mp4) => {
				var files = [];
				if (ogg) files.push(to + '.ogg');
				if (mp4) files.push(to + '.mp4');
				callback(files);
			});
		});
	}*/

	async copySound(platform: string, from: string, to: string) {
		fs.ensureDirSync(path.join(this.options.to, this.sysdir(), path.dirname(to)));
		let ogg = await convert(from, path.join(this.options.to, this.sysdir(), to + '.ogg'), this.options.ogg);
		let mp4 = false;
		if (!this.isDebugHtml5()) {
			mp4 = await convert(from, path.join(this.options.to, this.sysdir(), to + '.mp4'), this.options.aac);
		}
		let files: string[] = [];
		if (ogg) files.push(to + '.ogg');
		if (mp4) files.push(to + '.mp4');
		return files;
	}

	async copyImage(platform: string, from: string, to: string, options: any) {
		let format = await exportImage(this.options.kha, from, path.join(this.options.to, this.sysdir(), to), options, undefined, false);
		return [to + '.' + format];
	}

	async copyBlob(platform: string, from: string, to: string) {
		fs.copySync(from.toString(), path.join(this.options.to, this.sysdir(), to), { clobber: true });
		return [to];
	}

	async copyVideo(platform: string, from: string, to: string) {
		fs.ensureDirSync(path.join(this.options.to, this.sysdir(), path.dirname(to)));
		let mp4 = false;
		if (!this.isDebugHtml5()) {
			mp4 = await convert(from, path.join(this.options.to, this.sysdir(), to + '.mp4'), this.options.h264);
		}
		let webm = await convert(from, path.join(this.options.to, this.sysdir(), to + '.webm'), this.options.webm);
		let files: string[] = [];
		if (mp4) files.push(to + '.mp4');
		if (webm) files.push(to + '.webm');
		return files;
	}
}
