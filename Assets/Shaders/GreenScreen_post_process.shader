Shader "Blur-Demo/GreenScreen_post_process"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" { }
        _ReplacementColor ("Replacement Color", Color) = (0, 1, 0, 1)
        _ReplacementTex ("Replacement Texture", 2D) = "white" { }
        _ReplacementPower ("Replacement Power", Float) = 10.0
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" }
        
        Blend One Zero
        ZWrite Off
        Cull Off

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uvSrc : TEXCOORD0;
                float2 uvRepl : TEXCOORD1;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
            float4 _ReplacementColor;
            sampler2D _ReplacementTex;
            float4 _ReplacementTex_ST;
            float _ReplacementPower;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uvSrc = TRANSFORM_TEX(v.uv, _MainTex);
                o.uvRepl = TRANSFORM_TEX(v.uv, _ReplacementTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 colSrc = tex2D(_MainTex, i.uvSrc);
                fixed4 colRepl = tex2D(_ReplacementTex, i.uvRepl);
                float replacement = dot(_ReplacementColor, colSrc) / length(_ReplacementColor) / length(colSrc);
                return lerp(colSrc, colRepl, pow(replacement, _ReplacementPower));
			}
			ENDCG
		}
	}
}
