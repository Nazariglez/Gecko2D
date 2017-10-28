Shader "Custom/{name}" {
	SubShader {
		Pass {
			Cull Off
			ZTest Always
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			#include "{vert}.hlsl"
			#include "{frag}.hlsl"

			ENDCG
		}
	}
}
