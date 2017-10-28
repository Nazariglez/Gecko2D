import {GraphicsApi} from './GraphicsApi';
import {VisualStudioVersion} from './VisualStudioVersion';
import {VrApi} from './VrApi';

export class Options {
	from: string;
	to: string;
	projectfile: string;
	target: string;
	vr: string;
	main: string;
	// intermediate: string;
	graphics: string;
	visualstudio: string;
	kha: string;
	haxe: string;
	nohaxe: boolean;
	ffmpeg: string;
	krafix: string;
	noshaders: boolean;
	
	noproject: boolean;
	embedflashassets: boolean;
	compile: boolean;
	run: boolean;
	init: boolean;
	name: string;
	server: boolean;
	port: string;
	debug: boolean;
	silent: boolean;
	watch: boolean;
	glsl2: boolean;
	shaderversion: string;
	
	ogg: string;
	aac: string;
	mp3: string;
	h264: string;
	webm: string;
	wmv: string;
	theora: string;
}
