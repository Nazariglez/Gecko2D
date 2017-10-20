import * as path from 'path';

let korepath = path.join(__dirname, '..', '..', '..', 'Kore', 'Tools', 'koremake');

export function init(options: any) {
	korepath = path.join(options.kha, 'Kore', 'Tools', 'koremake');
}

export function get() {
	return korepath;
}
