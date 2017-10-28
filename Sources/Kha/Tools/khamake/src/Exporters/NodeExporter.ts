import * as path from 'path';
import {Html5Exporter} from './Html5Exporter';
import {Options} from '../Options';

export class NodeExporter extends Html5Exporter {
	constructor(options: Options) {
		super(options);
	}

	backend(): string {
		return 'Node';
	}
}
