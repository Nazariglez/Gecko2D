using System.Collections;
using System.Linq;
using UnityEditor;
using UnityEngine;
 
public class KhaInitializer : MonoBehaviour
{
    [MenuItem("Kha/Initialize")]
    public static void Initialize()
    {
		var kha = GetKha();
		if (kha.GetComponent<UnityBackend> () != null) {
			Debug.Log("Kha is already initialized.");
			return;
		}
		kha.AddComponent<UnityBackend> ();

		AssetDatabase.CreateFolder("Assets/Resources", "Materials");
		var shaders = AssetDatabase.FindAssets ("t:Shader");
		foreach (var shaderid in shaders) {
			var path = AssetDatabase.GUIDToAssetPath(shaderid);

			var name = path.Substring(path.LastIndexOf('/') + 1);
			name = name.Substring(0, name.LastIndexOf('.'));

			var shader = Shader.Find ("Custom/" + name);

			var mat = new Material(shader);
			var matname = shader.name.Substring(shader.name.LastIndexOf('/') + 1).Replace('.', '_').Replace('-', '_');

			AssetDatabase.CreateAsset(Instantiate(mat), "Assets/Resources/Materials/" + matname + ".mat");
		}
    }

	private static GameObject GetKha()
	{
		return Resources.FindObjectsOfTypeAll<GameObject>()
			.Where(go => string.IsNullOrEmpty(AssetDatabase.GetAssetPath(go))
			       && go.hideFlags == HideFlags.None).ToArray()[0];
	}
}
