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

export function set(log: {info: (text: string, newline: boolean) => void, error: (text: string, newline: boolean) => void}) {
	myInfo = log.info;
	myError = log.error;
}

export function silent() {
	myInfo = function () {};
	myError = function () {};
}

export function info(text: string, newline: boolean = true) {
	myInfo(text, newline);
}

export function error(text: string, newline: boolean = true) {
	myError(text, newline);
}
