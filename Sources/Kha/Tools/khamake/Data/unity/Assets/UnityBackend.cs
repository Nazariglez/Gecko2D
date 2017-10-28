using UnityEngine;
using System.Collections;
using System.Reflection;

public struct Point {
	public int x, y;
	
	public Point(int px, int py) {
		x = px;
		y = py;
	}
}

public class UnityBackend : MonoBehaviour {
	static readonly string[] gamepad1Axes = { "Joystick1Axis1", "Joystick1Axis2", "Joystick1Axis3", "Joystick1Axis4", "Joystick1Axis5", "Joystick1Axis6" };
	static readonly string[] gamepad2Axes = { "Joystick2Axis1", "Joystick2Axis2", "Joystick2Axis3", "Joystick2Axis4", "Joystick2Axis5", "Joystick2Axis6" };
	static readonly string[] gamepad3Axes = { "Joystick3Axis1", "Joystick3Axis2", "Joystick3Axis3", "Joystick3Axis4", "Joystick3Axis5", "Joystick3Axis6" };
	static readonly string[] gamepad4Axes = { "Joystick4Axis1", "Joystick4Axis2", "Joystick4Axis3", "Joystick4Axis4", "Joystick4Axis5", "Joystick4Axis6" };
	static readonly string[] gamepad1Buttons = { "Joystick1Button1", "Joystick1Button2", "Joystick1Button3", "Joystick1Button4", "Joystick1Button5", "Joystick1Button6", "Joystick1Button7", "Joystick1Button8", "Joystick1Button9", "Joystick1Button10", "Joystick1Button11", "Joystick1Button12", "Joystick1Button13", "Joystick1Button14", "Joystick1Button15", "Joystick1Button16" };
	static readonly string[] gamepad2Buttons = { "Joystick2Button1", "Joystick2Button2", "Joystick2Button3", "Joystick2Button4", "Joystick2Button5", "Joystick2Button6", "Joystick2Button7", "Joystick2Button8", "Joystick2Button9", "Joystick2Button10", "Joystick2Button11", "Joystick2Button12", "Joystick2Button13", "Joystick2Button14", "Joystick2Button15", "Joystick2Button16" };
	static readonly string[] gamepad3Buttons = { "Joystick3Button1", "Joystick3Button2", "Joystick3Button3", "Joystick3Button4", "Joystick3Button5", "Joystick3Button6", "Joystick3Button7", "Joystick3Button8", "Joystick3Button9", "Joystick3Button10", "Joystick3Button11", "Joystick3Button12", "Joystick3Button13", "Joystick3Button14", "Joystick3Button15", "Joystick3Button16" };
	static readonly string[] gamepad4Buttons = { "Joystick4Button1", "Joystick4Button2", "Joystick4Button3", "Joystick4Button4", "Joystick4Button5", "Joystick4Button6", "Joystick4Button7", "Joystick4Button8", "Joystick4Button9", "Joystick4Button10", "Joystick4Button11", "Joystick4Button12", "Joystick4Button13", "Joystick4Button14", "Joystick4Button15", "Joystick4Button16" };
	
	void Start() {
		haxe.root.EntryPoint__Main.Main();
	}

	void Update() {
		if (Input.GetKeyDown (KeyCode.LeftArrow)) {
			kha.SystemImpl.leftDown();
		}
		if (Input.GetKeyDown (KeyCode.RightArrow)) {
			kha.SystemImpl.rightDown();
		}
		if (Input.GetKeyDown (KeyCode.UpArrow)) {
			kha.SystemImpl.upDown();
		}
		if (Input.GetKeyDown (KeyCode.DownArrow)) {
			kha.SystemImpl.downDown();
		}
		if (Input.GetKeyUp (KeyCode.LeftArrow)) {
			kha.SystemImpl.leftUp();
		}
		if (Input.GetKeyUp (KeyCode.RightArrow)) {
			kha.SystemImpl.rightUp();
		}
		if (Input.GetKeyUp (KeyCode.UpArrow)) {
			kha.SystemImpl.upUp();
		}
		if (Input.GetKeyUp (KeyCode.DownArrow)) {
			kha.SystemImpl.downUp();
		}
		for (int i = 0; i < 3; ++i) {
			if (Input.GetMouseButtonDown (i)) {
				kha.SystemImpl.mouseDown (i, (int)Input.mousePosition.x, Screen.height - (int)Input.mousePosition.y);
			}
			if (Input.GetMouseButtonUp (i)) {
				kha.SystemImpl.mouseUp (i, (int)Input.mousePosition.x, Screen.height - (int)Input.mousePosition.y);
			}
		}
		for (int i = 0; i < gamepad1Axes.Length; ++i) {
			kha.SystemImpl.gamepad1Axis(i, Input.GetAxisRaw(gamepad1Axes[i]));
		}
		for (int i = 0; i < gamepad2Axes.Length; ++i) {
			kha.SystemImpl.gamepad2Axis(i, Input.GetAxisRaw(gamepad2Axes[i]));
		}
		for (int i = 0; i < gamepad3Axes.Length; ++i) {
			kha.SystemImpl.gamepad3Axis(i, Input.GetAxisRaw(gamepad3Axes[i]));
		}
		for (int i = 0; i < gamepad4Axes.Length; ++i) {
			kha.SystemImpl.gamepad4Axis(i, Input.GetAxisRaw(gamepad4Axes[i]));
		}
		for (int i = 0; i < gamepad1Buttons.Length; ++i) {
			kha.SystemImpl.gamepad1Button(i, Input.GetButton(gamepad1Buttons[i]) ? 1.0f : 0.0f);
		}
		for (int i = 0; i < gamepad2Buttons.Length; ++i) {
			kha.SystemImpl.gamepad2Button(i, Input.GetButton(gamepad2Buttons[i]) ? 1.0f : 0.0f);
		}
		for (int i = 0; i < gamepad3Buttons.Length; ++i) {
			kha.SystemImpl.gamepad3Button(i, Input.GetButton(gamepad3Buttons[i]) ? 1.0f : 0.0f);
		}
		for (int i = 0; i < gamepad4Buttons.Length; ++i) {
			kha.SystemImpl.gamepad4Button(i, Input.GetButton(gamepad4Buttons[i]) ? 1.0f : 0.0f);
		}
		
	}

	void OnPostRender() {
		kha.SystemImpl.update();
	}

	public static bool uvStartsAtTop() {
#if UNITY_UV_STARTS_AT_TOP
		return true;
#else
		return false;
#endif
	}

	public static Texture2D loadImage(string filename) {
		return Resources.Load("Images/" + cutEnding(filename)) as Texture2D;
	}

	public static byte[] loadBlob(string filename) {
		TextAsset asset = Resources.Load("Blobs/" + filename) as TextAsset;
		return asset.bytes;
	}
	
	public static AudioClip loadSound(string filename) {
		return Resources.Load("Sounds/" + cutEnding(filename)) as AudioClip;
	}

	private static string cutEnding(string filename) {
		return filename.Substring(0, filename.LastIndexOf('.'));
	}

	/*public static Point getImageSize(Texture2D asset) {
		if (asset != null) {
			string assetPath = AssetDatabase.GetAssetPath(asset);
			TextureImporter importer = AssetImporter.GetAtPath(assetPath) as TextureImporter;
			if (importer != null) {
				object[] args = new object[2] { 0, 0 };
				MethodInfo mi = typeof(TextureImporter).GetMethod("GetWidthAndHeight", BindingFlags.NonPublic | BindingFlags.Instance);
				mi.Invoke(importer, args);
				return new Point((int)args[0], (int)args[1]);
			}
		}
		return new Point(0, 0);
	}*/
}
