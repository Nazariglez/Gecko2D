import * as child_process from 'child_process';
import * as fs from 'fs';
import * as log from './log';

export function convert(inFilename: string, outFilename: string, encoder: string, args: Array<string> = null): Promise<boolean> {
	return new Promise((resolve, reject) => {
		if (fs.existsSync(outFilename.toString()) && fs.statSync(outFilename.toString()).mtime.getTime() > fs.statSync(inFilename.toString()).mtime.getTime()) {
			resolve(true);
			return;
		}
		
		if (!encoder) {
			resolve(false);
			return;
		}
		
		let dirend = Math.max(encoder.lastIndexOf('/'), encoder.lastIndexOf('\\'));
		let firstspace = encoder.indexOf(' ', dirend);
		let exe = encoder.substr(0, firstspace);
		let parts = encoder.substr(firstspace + 1).split(' ');
		let options: string[] = [];
		for (let i = 0; i < parts.length; ++i) {
			let foundarg = false;
			if (args !== null) {
				for (let arg in args) {
					if (parts[i] === '{' + arg + '}') {
						options.push(args[arg]);
						foundarg = true;
						break;
					}
				}
			}
			if (foundarg) continue;

			if (parts[i] === '{in}') options.push(inFilename.toString());
			else if (parts[i] === '{out}') options.push(outFilename.toString());
			else options.push(parts[i]);
		}

		let process = child_process.spawn(exe, options);
		process.on('close', (code: number) => {
			resolve(code === 0);
		});
	});
};
