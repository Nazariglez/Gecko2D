import * as fs from 'fs';
import * as path from 'path';
import * as log from './log';
import {Platform} from './Platform';
import {Project} from './Project';

export class ProjectData {
	project: Project;
	preAssetConversion: () => void;
	preShaderCompilation: () => void;
	preHaxeCompilation: () => void;
	postHaxeCompilation: () => void;
	postCppCompilation: () => void;
}

export async function loadProject(from: string, projectfile: string, platform: string): Promise<ProjectData> {
	return new Promise<ProjectData>((resolve, reject) => {
		fs.readFile(path.join(from, projectfile), 'utf8', (err, data) => {
			let resolved = false;
			let callbacks = {
				preAssetConversion: () => {},
				preShaderCompilation: () => {},
				preHaxeCompilation: () => {},
				postHaxeCompilation: () => {},
				postCppCompilation: () => {}
			};
			let resolver = (project: Project) => {
				resolved = true;
				resolve({
					preAssetConversion: callbacks.preAssetConversion,
					preShaderCompilation: callbacks.preShaderCompilation,
					preHaxeCompilation: callbacks.preHaxeCompilation,
					postHaxeCompilation: callbacks.postHaxeCompilation,
					postCppCompilation: callbacks.postCppCompilation,
					project: project
				});
			};

			process.on('exit', (code: number) => {
				if (!resolved) {
					console.error('Error: khafile.js did not call resolve, no project created.');
				}
			});
	
			Project.scriptdir = from;
			try {
				new Function('Project', 'Platform', 'platform', 'require', 'resolve', 'reject', 'callbacks', data)
					(Project, Platform, platform, require, resolver, reject, callbacks);
			}
			catch (error) {
				reject(error);
			}
		});
	});
}
