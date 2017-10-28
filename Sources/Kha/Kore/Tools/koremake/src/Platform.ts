export interface PlatformType {
	Windows: string;
	WindowsApp: string;
	iOS: string;
	OSX: string;
	Android: string;
	Linux: string;
	HTML5: string;
	Tizen: string;
	Pi: string;
	tvOS: string;
	PS4: string;
	XboxOne: string;
	Switch: string;
};

export let Platform: PlatformType = {
	Windows: 'windows',
	WindowsApp: 'windowsapp',
	iOS: 'ios',
	OSX: 'osx',
	Android: 'android',
	Linux: 'linux',
	HTML5: 'html5',
	Tizen: 'tizen',
	Pi: 'pi',
	tvOS: 'tvos',
	PS4: 'ps4',
	XboxOne: 'xboxone',
	Switch: 'switch'
};
