import {Project} from '../Project';
import * as fs from 'fs-extra';
import * as path from 'path';

export abstract class Exporter {
	out: number;

	constructor() {

	}

	writeFile(file: string) {
		this.out = fs.openSync(file, 'w');
	}

	closeFile() {
		fs.closeSync(this.out);
	}

	p(line: string = '', indent: number = 0) {
		let tabs = '';
		for (let i = 0; i < indent; ++i) tabs += '\t';
		let data = new Buffer(tabs + line + '\n');
		fs.writeSync(this.out, data, 0, data.length, null);
	}

	nicePath(from: string, to: string, filepath: string): string {
		let absolute = filepath;
		if (!path.isAbsolute(absolute)) {
			absolute = path.resolve(from, filepath);
		}
		return path.relative(to, absolute);
	}

	abstract exportSolution(project: Project, from: string, to: string, platform: string, vrApi: any, options: any): void;
}
