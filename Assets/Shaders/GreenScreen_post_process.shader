// http://gc-films.com/chromakey.html

Shader "Blur-Demo/GreenScreen_post_process"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" { }
        _ReplacementColor ("Replacement Color", Color) = (0, 1, 0, 1)
        _ReplacementTex ("Replacement Texture", 2D) = "white" { }
        
        _ToleranceLo ("Tolerance Low", Range(0.0, 1.0)) = 1.0
        _ToleranceHi ("Tolerance High", Range(0.0, 1.0)) = 1.0
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
            
            
            float4 rgbToYpbPr(float4 rgb)
            {
                float y = 0.299 * rgb.r + 0.587 * rgb.g + 0.114 * rgb.b;
                float pb = -0.168736 * rgb.r + 0.331264 * rgb.g + 0.5 * rgb.b;
                float pr = 0.5 * rgb.r - 0.416688 * rgb.g - 0.081312 * rgb.b;
                return float4(y, pb, pr, rgb.a);
            }
            

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
            float _ToleranceLo;
            float _ToleranceHi;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uvSrc = TRANSFORM_TEX(v.uv, _MainTex);
                o.uvRepl = TRANSFORM_TEX(v.uv, _ReplacementTex);
				return o;
			}
			
			float4 frag (v2f i) : SV_Target
			{
				float4 colSrc = tex2D(_MainTex, i.uvSrc);
                float4 colRepl = tex2D(_ReplacementTex, i.uvRepl);
                
                float4 yPbPrSrc = rgbToYpbPr(colSrc);
                float4 yPbPrKey = rgbToYpbPr(_ReplacementColor);
                float replacement = sqrt(pow((yPbPrSrc.y - yPbPrKey.y), 2.0) + pow((yPbPrSrc.z - yPbPrKey.z), 2.0));
                replacement = saturate((replacement - _ToleranceLo) / (_ToleranceHi - _ToleranceLo));
                replacement = 1.0 - replacement;
                
                return lerp(colSrc, colRepl, replacement);            
			}
			ENDCG
		}
	}
}
