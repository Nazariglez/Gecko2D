let myInfo = function (text: string, newline: boolean) {
	if (newline) {
		console.log(text);
	}
	else {
		process.stdout.write(text);
	}
};

let myError = function (text: string, newline: boolean) {
	if (newline) {
		console.error(text);
	}
	else {
		process.stderr.write(text);
	}
};

export function set(log: any) {
	myInfo = log.info;
	myError = log.error;
}

export function info(text: string, newline: boolean = true) {
	myInfo(text, newline);
}

export function error(text: string, newline: boolean = true) {
	myError(text, newline);
}
