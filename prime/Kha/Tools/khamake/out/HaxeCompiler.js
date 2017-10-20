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
const child_process = require("child_process");
const fs = require("fs");
const path = require("path");
const chokidar = require("chokidar");
const log = require("./log");
const exec_1 = require("./exec");
class HaxeCompiler {
    constructor(from, temp, to, haxeDirectory, hxml, sourceDirectories) {
        this.ready = true;
        this.todo = false;
        this.port = '7000';
        this.from = from;
        this.temp = temp;
        this.to = to;
        this.haxeDirectory = haxeDirectory;
        this.hxml = hxml;
        this.sourceMatchers = [];
        for (let dir of sourceDirectories) {
            this.sourceMatchers.push(path.join(dir, '**'));
        }
    }
    close() {
        if (this.watcher)
            this.watcher.close();
        if (this.compilationServer)
            this.compilationServer.kill();
    }
    run(watch) {
        return __awaiter(this, void 0, void 0, function* () {
            if (watch) {
                yield this.compile();
                this.watcher = chokidar.watch(this.sourceMatchers, { ignored: /[\/\\]\./, persistent: true, ignoreInitial: true });
                this.watcher.on('add', (file) => {
                    this.scheduleCompile();
                });
                this.watcher.on('change', (file) => {
                    this.scheduleCompile();
                });
                this.watcher.on('unlink', (file) => {
                    this.scheduleCompile();
                });
                this.startCompilationServer();
            }
            else
                yield this.compile();
        });
    }
    scheduleCompile() {
        if (this.ready) {
            this.triggerCompilationServer();
        }
        else {
            this.todo = true;
        }
    }
    runHaxe(parameters, onClose) {
        let exe = 'haxe';
        let env = process.env;
        if (fs.existsSync(this.haxeDirectory) && fs.statSync(this.haxeDirectory).isDirectory()) {
            let localexe = path.resolve(this.haxeDirectory, 'haxe' + exec_1.sys());
            if (!fs.existsSync(localexe))
                localexe = path.resolve(this.haxeDirectory, 'haxe');
            if (fs.existsSync(localexe))
                exe = localexe;
            const stddir = path.resolve(this.haxeDirectory, 'std');
            if (fs.existsSync(stddir) && fs.statSync(stddir).isDirectory()) {
                env.HAXE_STD_PATH = stddir;
            }
        }
        let haxe = child_process.spawn(exe, parameters, { env: env, cwd: path.normalize(this.from) });
        haxe.stdout.on('data', (data) => {
            log.info(data.toString());
        });
        haxe.stderr.on('data', (data) => {
            log.error(data.toString());
        });
        haxe.on('close', onClose);
        return haxe;
    }
    startCompilationServer() {
        this.compilationServer = this.runHaxe(['--wait', this.port], (code) => {
            log.info('Haxe compilation server stopped.');
        });
    }
    triggerCompilationServer() {
        this.ready = false;
        this.todo = false;
        return new Promise((resolve, reject) => {
            this.runHaxe(['--connect', this.port, this.hxml], (code) => {
                if (this.to) {
                    fs.renameSync(path.join(this.from, this.temp), path.join(this.from, this.to));
                }
                this.ready = true;
                log.info('Haxe compile end.');
                if (code === 0)
                    resolve();
                else
                    reject('Haxe compiler error.');
                if (this.todo) {
                    this.scheduleCompile();
                }
            });
        });
    }
    compile() {
        return new Promise((resolve, reject) => {
            this.runHaxe([this.hxml], (code) => {
                if (code === 0) {
                    if (this.to) {
                        fs.renameSync(path.join(this.from, this.temp), path.join(this.from, this.to));
                    }
                    resolve();
                }
                else {
                    process.exitCode = 1;
                    reject('Haxe compiler error.');
                }
            });
        });
    }
    static spinRename(from, to) {
        for (;;) {
            if (fs.existsSync(from)) {
                fs.renameSync(from, to);
                return;
            }
        }
    }
}
exports.HaxeCompiler = HaxeCompiler;
//# sourceMappingURL=HaxeCompiler.js.map