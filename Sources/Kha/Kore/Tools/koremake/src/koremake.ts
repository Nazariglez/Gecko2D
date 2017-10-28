import * as os from 'os';
import {Options} from './Options';
import {Platform} from './Platform';
import {GraphicsApi} from './GraphicsApi';
import {VisualStudioVersion} from './VisualStudioVersion';
import {VrApi} from './VrApi';

let defaultTarget: string;
if (os.platform() === 'linux') {
	defaultTarget = Platform.Linux;
}
else if (os.platform() === 'win32') {
	defaultTarget = Platform.Windows;
}
else {
	defaultTarget = Platform.OSX;
}

let options = [
	{
		full: 'from',
		value: true,
		description: 'Location of your project',
		default: '.'
	},
	{
		full: 'to',
		value: true,
		description: 'Build location',
		default: 'build'
	},
	{
		full: 'target',
		short: 't',
		value: true,
		description: 'Target platform',
		default: defaultTarget
	},
	{
		full: 'vr',
		value: true,
		description: 'Target VR device',
		default: VrApi.None
	},
	{
		full: 'pch',
		description: 'Use precompiled headers for C++ targets',
		value: false
	},
	{
		full: 'intermediate',
		description: 'Intermediate location for object files.',
		value: true,
		default: '',
		hidden: true
	},
	{
		full: 'graphics',
		short: 'g',
		description: 'Graphics api to use',
		value: true,
		default: GraphicsApi.Direct3D11
	},
	{
		full: 'visualstudio',
		short: 'v',
		description: 'Version of Visual Studio to use',
		value: true,
		default: VisualStudioVersion.VS2017
	},
	{
		full: 'compile',
		description: 'Compile executable',
		value: false
	},
	{
		full: 'run',
		description: 'Run executable',
		value: false
	},
	{
		full: 'update',
		description: 'Update Kore and it\'s submodules',
		value: false
	},
	{
		full: 'debug',
		description: 'Compile in debug mode',
		value: false
	},
	{
		full: 'noshaders',
		description: 'Do not compile shaders',
		value: false
	},
	{
		full: 'kore',
		short: 'k',
		description: 'Location of Kore directory',
		value: true,
		default: ''
	},
	{
		full: 'init',
		description: 'Init a Kore project inside the current directory',
		value: false
	},
	{
		full: 'name',
		description: 'Project name to use when initializing a project',
		value: true,
		default: 'Project'
	},
	{
		full: 'projectfile',
		value: true,
		description: 'Name of your project file, defaults to "korefile.js"',
		default: 'korefile.js'
	}
];

let parsedOptions: any = {

};

function printHelp() {
	console.log('khamake options:\n');
	for (let o in options) {
		let option: any = options[o];
		if (option.hidden) continue;
		if (option.short) console.log('-' + option.short + ' ' + '--' + option.full);
		else console.log('--' + option.full);
		console.log(option.description);
		console.log();
	}
}

for (let o in options) {
	let option: any = options[o];
	if (option.value) {
		parsedOptions[option.full] = option.default;
	}
	else {
		parsedOptions[option.full] = false;
	}
}

let args = process.argv;
for (let i = 2; i < args.length; ++i) {
	let arg = args[i];

	if (arg[0] === '-') {
		if (arg[1] === '-') {
			if (arg.substr(2) === 'help') {
				printHelp();
				process.exit(0);
			}
			let found = false;
			for (let o in options) {
				let option: any = options[o];
				if (arg.substr(2) === option.full) {
					found = true;
					if (option.value) {
						++i;
						parsedOptions[option.full] = args[i];
					}
					else {
						parsedOptions[option.full] = true;
					}
				}
			}
			if (!found) throw 'Option ' + arg + ' not found.';
		}
		else {
			if (arg[1] === 'h') {
				printHelp();
				process.exit(0);
			}
			if (arg.length !== 2) throw 'Wrong syntax for option ' + arg + ' (maybe try -' + arg + ' instead).';
			let found = false;
			for (let o in options) {
				let option: any = options[o];
				if (option.short && arg[1] === option.short) {
					found = true;
					if (option.value) {
						++i;
						parsedOptions[option.full] = args[i];
					}
					else {
						parsedOptions[option.full] = true;
					}
				}
			}
			if (!found) throw 'Option ' + arg + ' not found.';
		}
	}
	else {
		parsedOptions.target = arg;
	}
}

if (parsedOptions.run) {
	parsedOptions.compile = true;
}

if (parsedOptions.init) {
	console.log('Initializing Kore project.\n');
	require('./init').run(parsedOptions.name, parsedOptions.from, parsedOptions.projectfile);
}
else if (parsedOptions.update) {
	console.log('Updating everything...');
	require('child_process').spawnSync('git', ['submodule', 'foreach', '--recursive', 'git', 'pull', 'origin', 'master'], { stdio: 'inherit', stderr: 'inherit' });	
}
else {
	let logInfo = function (text: string, newline: boolean) {
		if (newline) {
			console.log(text);
		}
		else {
			process.stdout.write(text);
		}
	};

	let logError = function (text: string, newline: boolean) {
		if (newline) {
			console.error(text);
		}
		else {
			process.stderr.write(text);
		}
	};

	require('./main.js').run(
		parsedOptions,
	{
		info: logInfo,
		error: logError
	}, function () { });
}
