"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const fs = require("fs");
const path = require("path");
const log = require("./log");
const chokidar = require("chokidar");
const crypto = require("crypto");
class AssetConverter {
    constructor(exporter, platform, assetMatchers) {
        this.exporter = exporter;
        this.platform = platform;
        this.assetMatchers = assetMatchers;
    }
    close() {
        if (this.watcher)
            this.watcher.close();
    }
    static replacePattern(pattern, value, fileinfo, options, from) {
        let basePath = options.nameBaseDir ? path.join(from, options.nameBaseDir) : from;
        let dirValue = path.relative(basePath, fileinfo.dir);
        if (basePath.length > 0 && basePath[basePath.length - 1] === path.sep
            && dirValue.length > 0 && dirValue[dirValue.length - 1] !== path.sep) {
            dirValue += path.sep;
        }
        if (options.namePathSeparator) {
            dirValue = dirValue.split(path.sep).join(options.namePathSeparator);
        }
        return pattern.replace(/{name}/g, value).replace(/{ext}/g, fileinfo.ext).replace(/{dir}/g, dirValue);
    }
    static createExportInfo(fileinfo, keepextension, options, from) {
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
        return { name: nameValue, destination: destination };
    }
    watch(watch, match, options) {
        return new Promise((resolve, reject) => {
            let ready = false;
            let files = [];
            this.watcher = chokidar.watch(match, { ignored: /[\/\\]\./, persistent: watch });
            this.watcher.on('add', (file) => {
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
            this.watcher.on('change', (file) => {
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
            this.watcher.on('ready', () => __awaiter(this, void 0, void 0, function* () {
                ready = true;
                let parsedFiles = [];
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
                            let images = yield this.exporter.copyImage(this.platform, file, exportInfo.destination, options);
                            parsedFiles.push({ name: exportInfo.name, from: file, type: 'image', files: images, original_width: options.original_width, original_height: options.original_height, readable: options.readable });
                            break;
                        }
                        case '.wav': {
                            let exportInfo = AssetConverter.createExportInfo(fileinfo, false, options, this.exporter.options.from);
                            let sounds = yield this.exporter.copySound(this.platform, file, exportInfo.destination, options);
                            parsedFiles.push({ name: exportInfo.name, from: file, type: 'sound', files: sounds, original_width: undefined, original_height: undefined, readable: undefined });
                            break;
                        }
                        case '.ttf': {
                            let exportInfo = AssetConverter.createExportInfo(fileinfo, false, options, this.exporter.options.from);
                            let fonts = yield this.exporter.copyFont(this.platform, file, exportInfo.destination, options);
                            parsedFiles.push({ name: exportInfo.name, from: file, type: 'font', files: fonts, original_width: undefined, original_height: undefined, readable: undefined });
                            break;
                        }
                        case '.mp4':
                        case '.webm':
                        case '.mov':
                        case '.wmv':
                        case '.avi': {
                            let exportInfo = AssetConverter.createExportInfo(fileinfo, false, options, this.exporter.options.from);
                            let videos = yield this.exporter.copyVideo(this.platform, file, exportInfo.destination, options);
                            parsedFiles.push({ name: exportInfo.name, from: file, type: 'video', files: videos, original_width: undefined, original_height: undefined, readable: undefined });
                            break;
                        }
                        default: {
                            let exportInfo = AssetConverter.createExportInfo(fileinfo, true, options, this.exporter.options.from);
                            let blobs = yield this.exporter.copyBlob(this.platform, file, exportInfo.destination, options);
                            parsedFiles.push({ name: exportInfo.name, from: file, type: 'blob', files: blobs, original_width: undefined, original_height: undefined, readable: undefined });
                            break;
                        }
                    }
                    ++index;
                }
                resolve(parsedFiles);
            }));
        });
    }
    run(watch) {
        return __awaiter(this, void 0, void 0, function* () {
            let files = [];
            for (let matcher of this.assetMatchers) {
                files = files.concat(yield this.watch(watch, matcher.match, matcher.options));
            }
            return files;
        });
    }
}
exports.AssetConverter = AssetConverter;
//# sourceMappingURL=AssetConverter.js.map