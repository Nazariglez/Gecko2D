#include "pch.h"
#include <Kore/Graphics4/Graphics.h>
#include <Kore/Input/Keyboard.h>
#include <Kore/Input/Mouse.h>
#include <Kore/Log.h>
#include <Kore/System.h>

#include "Display.h"

#include <assert.h>
#include <cstring>

#include <stdio.h>
#include <stdlib.h>

#include <Kore/ogl.h>

#include <bcm_host.h>

#include <fcntl.h>
#include <inttypes.h>
#include <linux/input.h>

#include <X11/Xlib.h>

// apt-get install libx11-dev

namespace {
	// static int snglBuf[] = {GLX_RGBA, GLX_DEPTH_SIZE, 16, GLX_STENCIL_SIZE, 8, None};
	// static int dblBuf[]  = {GLX_RGBA, GLX_DEPTH_SIZE, 16, GLX_STENCIL_SIZE, 8, GLX_DOUBLEBUFFER, None};

	uint32_t screen_width;
	uint32_t screen_height;
	Kore::WindowMode windowMode;
	uint32_t width;
	uint32_t height;
	bool bcmHostStarted = false;

	EGLDisplay display;
	EGLSurface surface;
	EGLContext context;

	DISPMANX_ELEMENT_HANDLE_T dispman_element;

	GLboolean doubleBuffer = GL_TRUE;

	void fatalError(const char* message) {
		printf("main: %s\n", message);
		exit(1);
	}

	int getbit(uint32_t* bits, uint32_t bit) {
		return (bits[bit / 32] >> (bit % 32)) & 1;
	}

	void enable_bit(uint32_t* bits, uint32_t bit) {
		bits[bit / 32] |= 1u << (bit % 32);
	}

	void disable_bit(uint32_t* bits, uint32_t bit) {
		bits[bit / 32] &= ~(1u << (bit % 32));
	}

	void set_bit(uint32_t* bits, uint32_t bit, int value) {
		if (value)
			enable_bit(bits, bit);
		else
			disable_bit(bits, bit);
	}

	struct InputDevice {
		int fd;
		uint16_t keys;
		uint32_t key_state[(KEY_MAX - 1) / 32 + 1];
	};

	const int inputDevicesCount = 16;
	InputDevice inputDevices[inputDevicesCount];

	Display* dpy;

	void openXWindow(int x, int y, int width, int height) {
		dpy = XOpenDisplay(NULL);
		XSetWindowAttributes winAttr;
		winAttr.event_mask = StructureNotifyMask;
		Window w = XCreateWindow(dpy, DefaultRootWindow(dpy), 0, 0, width, height, 0, CopyFromParent, CopyFromParent, CopyFromParent, CWEventMask, &winAttr);
		XMapWindow(dpy, w);
		XFlush(dpy);

		// TODO: Figure this out
		/*Atom atom = XInternAtom(dpy, "_NET_FRAME_EXTENTS", True);
		Atom atom2;
		int f;
		unsigned long n, b;
		XEvent e;
		unsigned char *data = 0;
		while (XGetWindowProperty(dpy, w, atom,
		           0, 4, False, AnyPropertyType,
		           &atom2, &f,
		           &n, &b, &data) != Success || n != 4 || b != 0) {
		    XNextEvent(dpy, &e);
		}

		long* extents = (long*) data;
		//printf ("Got frame extents: left %ld right %ld top %ld bottom %ld\n",
		//    extents[0], extents[1], extents[2], extents[3]);
		*/

		XMoveWindow(dpy, w, x - 1, y - 30); // extents[2]);
		XFlush(dpy);
	}

	void setScreenSize() {
        if (!bcmHostStarted) {
            bcm_host_init();
            bcmHostStarted = true;
        }

        if (screen_width == 0 || screen_height == 0) {
            int32_t success = 0;
            success = graphics_get_display_size(0 /* LCD */, &screen_width, &screen_height);
            assert(success >= 0);
        }
    }
}

namespace Kore {
	namespace Display {
		void enumDisplayMonitors(DeviceInfo screens[], int& displayCounter) {
			displayCounter = 1;
		}
	}
}

void Kore::System::setup() {}

bool Kore::System::isFullscreen() {
	// TODO (DK)
	return false;
}

// TODO (DK) the whole glx stuff should go into Graphics/OpenGL?
//  -then there would be a better separation between window + context setup
int createWindow(const char* title, int x, int y, int width, int height, Kore::WindowMode windowMode, int targetDisplay, int depthBufferBits,
                 int stencilBufferBits) {
	if (!bcmHostStarted) {
        bcm_host_init();
        bcmHostStarted = true;
    }

	::windowMode = windowMode;
	::width = width;
	::height = height;
	// uint32_t screen_width = 640;
	// uint32_t screen_height = 480;

	EGLBoolean result;
	EGLint num_config;

	static EGL_DISPMANX_WINDOW_T nativewindow;

	DISPMANX_DISPLAY_HANDLE_T dispman_display;
	DISPMANX_UPDATE_HANDLE_T dispman_update;
	VC_RECT_T dst_rect;
	VC_RECT_T src_rect;

	static const EGLint attribute_list[] = {EGL_RED_SIZE,   8,       EGL_GREEN_SIZE, 8, EGL_BLUE_SIZE, 8, EGL_ALPHA_SIZE, 8, EGL_SURFACE_TYPE,
	                                        EGL_WINDOW_BIT, EGL_NONE};

	static const EGLint context_attributes[] = {EGL_CONTEXT_CLIENT_VERSION, 2, EGL_NONE};
	EGLConfig config;

	display = eglGetDisplay(EGL_DEFAULT_DISPLAY);
	assert(display != EGL_NO_DISPLAY);
	glCheckErrors();

	result = eglInitialize(display, NULL, NULL);
	assert(EGL_FALSE != result);
	glCheckErrors();

	result = eglChooseConfig(display, attribute_list, &config, 1, &num_config);
	assert(EGL_FALSE != result);
	glCheckErrors();

	result = eglBindAPI(EGL_OPENGL_ES_API);
	assert(EGL_FALSE != result);
	glCheckErrors();

	context = eglCreateContext(display, config, EGL_NO_CONTEXT, context_attributes);
	assert(context != EGL_NO_CONTEXT);
	glCheckErrors();

	setScreenSize();

	if (windowMode == Kore::WindowModeFullscreen) {
		dst_rect.x = 0;
		dst_rect.y = 0;
		dst_rect.width = screen_width;
		dst_rect.height = screen_height;
		src_rect.x = 0;
		src_rect.y = 0;
		src_rect.width = screen_width << 16;
		src_rect.height = screen_height << 16;
	}
	else {
		dst_rect.x = x;
		dst_rect.y = y;
		#ifdef KORE_PI_SCALING
		dst_rect.width = screen_width;
		dst_rect.height = screen_height;
		#else
		dst_rect.width = width;
		dst_rect.height = height;
		#endif
		src_rect.x = 0;
		src_rect.y = 0;
		src_rect.width = width << 16;
		src_rect.height = height << 16;
	}

	dispman_display = vc_dispmanx_display_open(0 /* LCD */);
	dispman_update = vc_dispmanx_update_start(0);

	VC_DISPMANX_ALPHA_T alpha = {};
	alpha.flags = (DISPMANX_FLAGS_ALPHA_T)(DISPMANX_FLAGS_ALPHA_FROM_SOURCE | DISPMANX_FLAGS_ALPHA_FIXED_ALL_PIXELS);
	alpha.opacity = 255;
	alpha.mask = 0;

	dispman_element = vc_dispmanx_element_add(dispman_update, dispman_display, 0 /*layer*/, &dst_rect, 0 /*src*/, &src_rect, DISPMANX_PROTECTION_NONE, &alpha,
	                                          0 /*clamp*/, (DISPMANX_TRANSFORM_T)0 /*transform*/);

	nativewindow.element = dispman_element;
	if (windowMode == Kore::WindowModeFullscreen) {
		nativewindow.width = screen_width;
		nativewindow.height = screen_height;
	}
	else {
		nativewindow.width = width;
		nativewindow.height = height;
		#ifndef KORE_PI_SCALING
		openXWindow(x, y, width, height);
		#endif
	}
	vc_dispmanx_update_submit_sync(dispman_update);

	glCheckErrors();

	surface = eglCreateWindowSurface(display, config, &nativewindow, NULL);
	assert(surface != EGL_NO_SURFACE);
	glCheckErrors();

	result = eglMakeCurrent(display, surface, surface, context);
	assert(EGL_FALSE != result);
	glCheckErrors();

	// input

	char name[64];
	for (int i = 0; i < inputDevicesCount; ++i) {
		sprintf(name, "/dev/input/event%d", i);

		// PIGU_device_info_t info;
		// if(PIGU_detect_device(name, &info) < 0)

		uint32_t events[(KEY_MAX - 1) / 32 + 1];

		inputDevices[i].fd = open(name, O_RDONLY | O_NONBLOCK);

		if (inputDevices[i].fd < 0) continue;

		char deviceName[128];
		ioctl(inputDevices[i].fd, EVIOCGNAME(sizeof(deviceName)), deviceName);

		printf("Found a device. %s\n", deviceName);

		uint32_t types[EV_MAX];
		memset(types, 0, sizeof(types));
		ioctl(inputDevices[i].fd, EVIOCGBIT(0, EV_MAX), types);
		int keycount = 0;

		if (getbit(types, EV_KEY)) {
			// count events
			memset(events, 0, sizeof(events));
			ioctl(inputDevices[i].fd, EVIOCGBIT(EV_KEY, KEY_MAX), events);
			int j = 0;
			for (; j < BTN_MISC; ++j)
				if (getbit(events, j)) keycount++;

			/*j = BTN_MOUSE; // skip misc buttons

			for(;j<BTN_JOYSTICK;++j)
		   if(PIGU_get_bit(events, j))
		   {
			  mouse_button_count++;
			  if(j-BTN_MOUSE>=16)
			     continue;
			  buttons.map[buttons.count] = j-BTN_MOUSE;
			  buttons.count++;
		   }

			for(;j<BTN_GAMEPAD;++j)
		   if(PIGU_get_bit(events, j))
		   {
			  joystick_button_count++;
			  if(j-BTN_JOYSTICK>=16)
			     continue;
			  buttons.map[buttons.count] = j-BTN_JOYSTICK;
			  buttons.count++;
		   }

			for(;j<BTN_DIGI;++j)
		   if(PIGU_get_bit(events, j))
		   {
			  gamepad_button_count++;
			  if(j-BTN_GAMEPAD>=16)
			     continue;
			  buttons.map[buttons.count] = j-BTN_GAMEPAD;
			  buttons.count++;
		   }*/
		}
	}

	return 0;
}

namespace Kore {
	namespace System {
		int windowCount() {
			return 1;
		}

		int windowWidth(int id) {
			if (windowMode == Kore::WindowModeFullscreen) {
				return screen_width;
			}
			else {
				return width;
			}
		}

		int windowHeight(int id) {
			if (windowMode == Kore::WindowModeFullscreen) {
				return screen_height;
			}
			else {
				return height;
			}
		}

		int desktopWidth() {
            setScreenSize();
			return screen_width;
		}

		int desktopHeight() {
            setScreenSize();
			return screen_height;
		}

		int initWindow(WindowOptions options) {
			char buffer[1024] = {0};
			strcat(buffer, name());
			if (options.title != nullptr) {
				strcat(buffer, options.title);
			}

			int id = createWindow(buffer, options.x, options.y, options.width, options.height, options.mode, options.targetDisplay,
			                      options.rendererOptions.depthBufferBits, options.rendererOptions.stencilBufferBits);
			Graphics4::init(id, options.rendererOptions.depthBufferBits, options.rendererOptions.stencilBufferBits);
			return id;
		}

		void* windowHandle(int id) {
			return nullptr;
		}
	}
}

namespace Kore {
	namespace System {
		int currentDeviceId = -1;

		int currentDevice() {
			return currentDeviceId;
		}

		void setCurrentDevice(int id) {
			currentDeviceId = id;
		}
	}
}

bool Kore::System::handleMessages() {
	for (int i = 0; i < inputDevicesCount; ++i) {

		int eventcount = 0;

		if (inputDevices[i].fd < 0) continue;

		input_event event;
		ssize_t readsize = read(inputDevices[i].fd, &event, sizeof(event));
		while (readsize >= 0) {

			set_bit(inputDevices[i].key_state, event.code, event.value);

#define KEY(linuxkey, korekey, keychar)                         \
    case linuxkey:                                              \
        if (event.value == 1)                                   \
            Kore::Keyboard::the()->_keydown(korekey, keychar);  \
        else if (event.value == 0)                              \
            Kore::Keyboard::the()->_keyup(korekey, keychar);    \
		break;
			switch(event.code) {
			    KEY(KEY_RIGHT, Key_Right, ' ')
			    KEY(KEY_LEFT, Key_Left, ' ')
                KEY(KEY_UP, Key_Up, ' ')
                KEY(KEY_DOWN, Key_Down, ' ')
                KEY(KEY_SPACE, Key_Space, ' ')
                KEY(KEY_BACKSPACE, Key_Backspace, ' ')
                KEY(KEY_TAB, Key_Tab, ' ')
                KEY(KEY_ENTER, Key_Enter, ' ')
                KEY(KEY_LEFTSHIFT, Key_Shift, ' ')
                KEY(KEY_RIGHTSHIFT, Key_Shift, ' ')
                KEY(KEY_LEFTCTRL, Key_Control, ' ')
                KEY(KEY_RIGHTCTRL, Key_Control, ' ')
                KEY(KEY_LEFTALT, Key_Alt, ' ')
                KEY(KEY_RIGHTALT, Key_Alt, ' ')
                KEY(KEY_DELETE, Key_Delete, ' ')
                KEY(KEY_A, Key_A, 'a')
                KEY(KEY_B, Key_B, 'b')
                KEY(KEY_C, Key_C, 'c')
                KEY(KEY_D, Key_D, 'd')
                KEY(KEY_E, Key_E, 'e')
                KEY(KEY_F, Key_F, 'f')
                KEY(KEY_G, Key_G, 'g')
                KEY(KEY_H, Key_H, 'h')
                KEY(KEY_I, Key_I, 'i')
                KEY(KEY_J, Key_J, 'j')
                KEY(KEY_K, Key_K, 'k')
                KEY(KEY_L, Key_L, 'l')
                KEY(KEY_M, Key_M, 'm')
                KEY(KEY_N, Key_N, 'n')
                KEY(KEY_O, Key_O, 'o')
                KEY(KEY_P, Key_P, 'p')
                KEY(KEY_Q, Key_Q, 'q')
                KEY(KEY_R, Key_R, 'r')
                KEY(KEY_S, Key_S, 's')
                KEY(KEY_T, Key_T, 't')
                KEY(KEY_U, Key_U, 'u')
                KEY(KEY_V, Key_V, 'v')
                KEY(KEY_W, Key_W, 'w')
                KEY(KEY_X, Key_X, 'x')
                KEY(KEY_Y, Key_Y, 'y')
                KEY(KEY_Z, Key_Z, 'z')
                KEY(KEY_1, Key_1, '1')
                KEY(KEY_2, Key_2, '2')
                KEY(KEY_3, Key_3, '3')
                KEY(KEY_4, Key_4, '4')
                KEY(KEY_5, Key_5, '5')
                KEY(KEY_6, Key_6, '6')
                KEY(KEY_7, Key_7, '7')
                KEY(KEY_8, Key_8, '8')
                KEY(KEY_9, Key_9, '9')
                KEY(KEY_0, Key_0, '0')
			}
#undef KEY

			// printf("Code %d Value %d\n", event.code, event.value);
			readsize = read(inputDevices[i].fd, &event, sizeof(event));
		}
	}

    #ifndef KORE_PI_SCALING
	if (windowMode != Kore::WindowModeFullscreen) {
		while (XPending(dpy) > 0) {
			XEvent event;
			XNextEvent(dpy, &event);
			printf("Got an X event.\n");
			switch (event.type) {
			case ConfigureNotify:
				DISPMANX_UPDATE_HANDLE_T update = vc_dispmanx_update_start(0);

				VC_RECT_T dst_rect;
				VC_RECT_T src_rect;
				dst_rect.x = event.xconfigure.x;
				dst_rect.y = event.xconfigure.y;
				dst_rect.width = width;
				dst_rect.height = height;
				src_rect.x = 0;
				src_rect.y = 0;
				src_rect.width = width << 16;
				src_rect.height = height << 16;

				vc_dispmanx_element_change_attributes(update, dispman_element, 0, 0, 255, &dst_rect, &src_rect, 0, (DISPMANX_TRANSFORM_T)0);
				vc_dispmanx_update_submit_sync(update);
			}
		}
	}
	#endif

	return true;
}

const char* Kore::System::systemId() {
	return "Pi";
}

void Kore::System::makeCurrent(int contextId) {
	if (currentDeviceId == contextId) {
		return;
	}

#if !defined(NDEBUG)
// log(Info, "Kore/System | context switch from %i to %i", currentDeviceId, contextId);
#endif

	currentDeviceId = contextId;
}

void Kore::Graphics4::clearCurrent() {}

void Kore::System::clearCurrent() {
#if !defined(NDEBUG)
// log(Info, "Kore/System | context clear");
#endif

	currentDeviceId = -1;
	Graphics4::clearCurrent();
}

void Kore::System::swapBuffers(int contextId) {
	eglSwapBuffers(display, surface);
}

void Kore::System::destroyWindow(int id) {
	// TODO (DK) implement me
}

void Kore::System::changeResolution(int width, int height, bool fullscreen) {}

void Kore::System::setTitle(const char* title) {}

void Kore::System::setKeepScreenOn(bool on) {}

void Kore::System::showWindow() {}

void Kore::System::showKeyboard() {}

void Kore::System::hideKeyboard() {}

void Kore::System::loadURL(const char* url) {}

namespace {
	char save[2000];
	bool saveInitialized = false;
}

const char* Kore::System::savePath() {
	if (!saveInitialized) {
		strcpy(save, "Ķ~/.");
		strcat(save, name());
		strcat(save, "/");
		saveInitialized = true;
	}
	return save;
}

namespace {
	const char* videoFormats[] = {"ogv", nullptr};
}

const char** Kore::System::videoFormats() {
	return ::videoFormats;
}

#include <sys/time.h>
#include <time.h>

double Kore::System::frequency() {
	return 1000000.0;
}

Kore::System::ticks Kore::System::timestamp() {
	timeval now;
	gettimeofday(&now, NULL);
	return static_cast<ticks>(now.tv_sec) * 1000000 + static_cast<ticks>(now.tv_usec);
}

extern int kore(int argc, char** argv);

int main(int argc, char** argv) {
	kore(argc, argv);
}

