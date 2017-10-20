import * as child_process from 'child_process';
import * as fs from 'fs';
import * as path from 'path';
import * as chokidar from 'chokidar';
import * as log from './log';
import {sys} from './exec';

export class HaxeCompiler {
	from: string;
	haxeDirectory: string;
	hxml: string;
	sourceMatchers: Array<string>;
	watcher: fs.FSWatcher;
	ready: boolean = true;
	todo: boolean = false;
	port: string = '7000';
	temp: string;
	to: string;
	compilationServer: child_process.ChildProcess;
		
	constructor(from: string, temp: string, to: string, haxeDirectory: string, hxml: string, sourceDirectories: Array<string>) {
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

	close(): void {
		if (this.watcher) this.watcher.close();
		if (this.compilationServer) this.compilationServer.kill();
	}
	
	async run(watch: boolean) {
		if (watch) {
			await this.compile();
			this.watcher = chokidar.watch(this.sourceMatchers, { ignored: /[\/\\]\./, persistent: true, ignoreInitial: true });
			this.watcher.on('add', (file: string) => {
				this.scheduleCompile();
			});
			this.watcher.on('change', (file: string) => {
				this.scheduleCompile();
			});
			this.watcher.on('unlink', (file: string) => {
				this.scheduleCompile();
			});
			this.startCompilationServer();
		}
		else await this.compile();
	}
	
	scheduleCompile() {
		if (this.ready) {
			this.triggerCompilationServer();
		}
		else {
			this.todo = true;
		}
	}

	runHaxe(parameters: string[], onClose: Function): child_process.ChildProcess {
		let exe = 'haxe';
		let env = process.env;
		if (fs.existsSync(this.haxeDirectory) && fs.statSync(this.haxeDirectory).isDirectory()) {
			let localexe = path.resolve(this.haxeDirectory, 'haxe' + sys());
			if (!fs.existsSync(localexe)) localexe = path.resolve(this.haxeDirectory, 'haxe');
			if (fs.existsSync(localexe)) exe = localexe;
			const stddir = path.resolve(this.haxeDirectory, 'std');
			if (fs.existsSync(stddir) && fs.statSync(stddir).isDirectory()) {
				env.HAXE_STD_PATH = stddir;
			}
		}
		
		let haxe = child_process.spawn(exe, parameters, {env: env, cwd: path.normalize(this.from)});
		
		haxe.stdout.on('data', (data: any) => {
			log.info(data.toString());
		});

		haxe.stderr.on('data', (data: any) => {
			log.error(data.toString());
		});
		
		haxe.on('close', onClose);

		return haxe;
	}
	
	startCompilationServer() {
		this.compilationServer = this.runHaxe(['--wait', this.port], (code: number) => {
			log.info('Haxe compilation server stopped.');
		});
	}
	
	triggerCompilationServer() {
		this.ready = false;
		this.todo = false;
		return new Promise((resolve, reject) => {
			this.runHaxe(['--connect', this.port, this.hxml], (code: number) => {
				if (this.to) {
					fs.renameSync(path.join(this.from, this.temp), path.join(this.from, this.to));
				}
				this.ready = true;
				log.info('Haxe compile end.');
				if (code === 0) resolve();
				else reject('Haxe compiler error.');
				if (this.todo) {
					this.scheduleCompile();
				}
			});
		});
	}
	
	compile(): Promise<void> {
		return new Promise<void>((resolve, reject) => {
			this.runHaxe([this.hxml], (code: number) => {
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
	
	private static spinRename(from: string, to: string): void {
		for (; ; ) {
			if (fs.existsSync(from)) {
				fs.renameSync(from, to);
				return;
			}
		}
	}
}
