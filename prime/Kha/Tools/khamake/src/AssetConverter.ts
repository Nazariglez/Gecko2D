import * as fs from 'fs';
import * as path from 'path';
import {KhaExporter} from './Exporters/KhaExporter';
import * as log from './log';
import * as chokidar from 'chokidar';
import * as crypto from 'crypto';

export class AssetConverter {
	exporter: KhaExporter;
	platform: string;
	assetMatchers: Array<{ match: string, options: any }>;
	watcher: fs.FSWatcher;
	
	constructor(exporter: KhaExporter, platform: string, assetMatchers: Array<{ match: string, options: any }>) {
		this.exporter = exporter;
		this.platform = platform;
		this.assetMatchers = assetMatchers;
	}

	close(): void {
		if (this.watcher) this.watcher.close();
	}

	static replacePattern(pattern: string, value: string, fileinfo: path.ParsedPath, options: any, from: string) {		
		let basePath: string = options.nameBaseDir ? path.join(from, options.nameBaseDir) : from;
		let dirValue: string = path.relative(basePath, fileinfo.dir);
		if (basePath.length > 0 && basePath[basePath.length - 1] === path.sep
			&& dirValue.length > 0 && dirValue[dirValue.length - 1] !== path.sep) { 
			dirValue += path.sep;
		}
		if (options.namePathSeparator) {
			dirValue = dirValue.split(path.sep).join(options.namePathSeparator);
		}
		return pattern.replace(/{name}/g, value).replace(/{ext}/g, fileinfo.ext).replace(/{dir}/g, dirValue);
	}
	
	static createExportInfo(fileinfo: path.ParsedPath, keepextension: boolean, options: any, from: string): {name: string, destination: string} {
		let nameValue = fileinfo.name;
		
		let destination = fileinfo.name;

		if (options.md5sum) {
			let data = fs.readFileSync(path.join(fileinfo.dir, fileinfo.base));
			let md5sum = crypto.createHash('md5').update(data).digest('hex'); // TODO yield generateMd5Sum(file);
			destination += '_' + md5sum;
		}
		if (keepextension && (!options.destination || options.destination.indexOf('{ext}') < 0)) {
			destination += fileinfo.ext;
		}

		if (options.destination) {
			destination = AssetConverter.replacePattern(options.destination, destination, fileinfo, options, from);
		}		
	
		if (keepextension && (!options.name || options.name.indexOf('{ext}') < 0)) {
			nameValue += fileinfo.ext;
		}

		if (options.name) {
			nameValue = AssetConverter.replacePattern(options.name, nameValue, fileinfo, options, from);
		}

		return {name: nameValue, destination: destination};
	}
	
	watch(watch: boolean, match: string, options: any): Promise<{ name: string, from: string, type: string, files: string[], original_width: number, original_height: number, readable: boolean }[]> {
		return new Promise<{ from: string, type: string, files: string[] }[]>((resolve, reject) => {
			let ready = false;
			let files: string[] = [];
			this.watcher = chokidar.watch(match, { ignored: /[\/\\]\./, persistent: watch });
			this.watcher.on('add', (file: string) => {
				if (ready) {
					let fileinfo = path.parse(file);
					switch (fileinfo.ext) {
						case '.png':
							log.info('Reexporting ' + fileinfo.name);
							this.exporter.copyImage(this.platform, file, fileinfo.name, {});
							break;
					}
				}
				else {
					files.push(file);
				}
			});
			
			this.watcher.on('change', (file: string) => {
				if (ready) {
					let fileinfo = path.parse(file);
					switch (fileinfo.ext) {
						case '.png':
							log.info('Reexporting ' + fileinfo.name);
							this.exporter.copyImage(this.platform, file, fileinfo.name, {});
							break;
					}
				}
			});
			
			this.watcher.on('ready', async () => {
				ready = true;
				let parsedFiles: { name: string, from: string, type: string, files: string[], original_width: number, original_height: number, readable: boolean }[] = [];
				let index = 0;
				for (let file of files) {
					let fileinfo = path.parse(file);
					log.info('Exporting asset ' + (index + 1) + ' of ' + files.length + ' (' + fileinfo.base + ').');
					switch (fileinfo.ext.toLowerCase()) {
						case '.png':
						case '.jpg':
						case '.jpeg':
						case '.hdr': {
							let exportInfo = AssetConverter.createExportInfo(fileinfo, false, options, this.exporter.options.from);
							let images = await this.exporter.copyImage(this.platform, file, exportInfo.destination, options);
							parsedFiles.push({ name: exportInfo.name, from: file, type: 'image', files: images, original_width: options.original_width, original_height: options.original_height, readable: options.readable });
							break;
						}
						case '.wav': {
							let exportInfo = AssetConverter.createExportInfo(fileinfo, false, options, this.exporter.options.from);
							let sounds = await this.exporter.copySound(this.platform, file, exportInfo.destination, options);
							parsedFiles.push({ name: exportInfo.name, from: file, type: 'sound', files: sounds, original_width: undefined, original_height: undefined, readable: undefined });
							break;
						}
						case '.ttf': {
							let exportInfo = AssetConverter.createExportInfo(fileinfo, false, options, this.exporter.options.from);
							let fonts = await this.exporter.copyFont(this.platform, file, exportInfo.destination, options);
							parsedFiles.push({ name: exportInfo.name, from: file, type: 'font', files: fonts, original_width: undefined, original_height: undefined, readable: undefined });
							break;
						}
						case '.mp4':
						case '.webm':
						case '.mov':
						case '.wmv':
						case '.avi': {
							let exportInfo = AssetConverter.createExportInfo(fileinfo, false, options, this.exporter.options.from);
							let videos = await this.exporter.copyVideo(this.platform, file, exportInfo.destination, options);
							parsedFiles.push({ name: exportInfo.name, from: file, type: 'video', files: videos, original_width: undefined, original_height: undefined, readable: undefined });
							break;
						}
						default: {
							let exportInfo = AssetConverter.createExportInfo(fileinfo, true, options, this.exporter.options.from);
							let blobs = await this.exporter.copyBlob(this.platform, file, exportInfo.destination, options);
							parsedFiles.push({ name: exportInfo.name, from: file, type: 'blob', files: blobs, original_width: undefined, original_height: undefined, readable: undefined });
							break;
						}
					}
					++index;
				}
				resolve(parsedFiles);
			});
		});
	}
	
	async run(watch: boolean): Promise<{ name: string, from: string, type: string, files: string[], original_width: number, original_height: number, readable: boolean }[]> {
		let files: { name: string, from: string, type: string, files: string[], original_width: number, original_height: number, readable: boolean }[] = [];
		for (let matcher of this.assetMatchers) {
			files = files.concat(await this.watch(watch, matcher.match, matcher.options));
		}
		return files;
	}
}
