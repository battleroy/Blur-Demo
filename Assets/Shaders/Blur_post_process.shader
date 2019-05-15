// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)
Shader "Blur-Demo/Blur_post_process"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" { }
        _Color ("Tint", Color) = (1,1,1,1)
        [Toggle(BLUR)] _Blur ("Blur Enabled?", Float) = 0
    }

    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
        }

        Lighting Off
        ZWrite Off
        Cull Off
        Blend One Zero
        
        // Horizontal
        Pass
        {
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0

            #include "UnityCG.cginc"
            
            #pragma shader_feature BLUR
            
            struct appdata_t
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex   : SV_POSITION;
                fixed4 color    : COLOR;
                float2 texcoord  : TEXCOORD0;
            };

            fixed4 _Color;
            
            sampler2D _MainTex;
            float4 _MainTex_ST;
            // x contains 1.0/width
            // y contains 1.0/height
            // z contains width
            // w contains height
            float4 _MainTex_TexelSize;

            v2f vert(appdata_t v)
            {
                v2f OUT;
                OUT.vertex = UnityObjectToClipPos(v.vertex);
                OUT.texcoord = v.texcoord;
                OUT.color = v.color * _Color;
                return OUT;
            }

            fixed4 frag(v2f IN) : SV_Target
            {
                half4 color = half4(0.0, 0.0, 0.0, 0.0);
                float2 centerUv = IN.texcoord;
                
                #define ADD_PIXEL(coeff, delta) color += tex2D(_MainTex, centerUv + float2(delta * _MainTex_TexelSize.x, 0.0)) * coeff
                #if BLUR
                // http://dev.theomader.com/gaussian-kernel-calculator/
                // Sigma = 3.0, Kernel size = 9
                ADD_PIXEL(0.063327, -4.0);
                ADD_PIXEL(0.093095, -3.0);
                ADD_PIXEL(0.122589, -2.0);
                ADD_PIXEL(0.144599, -1.0);
                ADD_PIXEL(0.152781, 0.0);
                ADD_PIXEL(0.144599, 1.0);
                ADD_PIXEL(0.122589, 2.0);
                ADD_PIXEL(0.093095, 3.0);
                ADD_PIXEL(0.063327, 4.0);
                #else
                ADD_PIXEL(1.0, 0.0);
                #endif
                #undef ADD_PIXEL
                
                // Multiplying at the one pass only
                // to avoid the double coloring
                color *= IN.color;

                return color;
            }
        ENDCG
        }

        
        // Vertical
        Pass
        {
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0

            #include "UnityCG.cginc"
            
            #pragma shader_feature BLUR
            
            struct appdata_t
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex   : SV_POSITION;
                fixed4 color    : COLOR;
                float2 texcoord  : TEXCOORD0;
            };

            fixed4 _Color;
            
            sampler2D _MainTex;
            float4 _MainTex_ST;
            // x contains 1.0/width
            // y contains 1.0/height
            // z contains width
            // w contains height
            float4 _MainTex_TexelSize;

            v2f vert(appdata_t v)
            {
                v2f OUT;
                OUT.vertex = UnityObjectToClipPos(v.vertex);
                OUT.texcoord = v.texcoord;
                OUT.color = v.color * _Color;
                return OUT;
            }

            fixed4 frag(v2f IN) : SV_Target
            {
                half4 color = half4(0.0, 0.0, 0.0, 0.0);
                float2 centerUv = IN.texcoord;
                
                #define ADD_PIXEL(coeff, delta) color += tex2D(_MainTex, centerUv + float2(0.0, delta * _MainTex_TexelSize.y)) * coeff
                #if BLUR
                // http://dev.theomader.com/gaussian-kernel-calculator/
                // Sigma = 3.0, Kernel size = 9
                ADD_PIXEL(0.063327, -4.0);
                ADD_PIXEL(0.093095, -3.0);
                ADD_PIXEL(0.122589, -2.0);
                ADD_PIXEL(0.144599, -1.0);
                ADD_PIXEL(0.152781, 0.0);
                ADD_PIXEL(0.144599, 1.0);
                ADD_PIXEL(0.122589, 2.0);
                ADD_PIXEL(0.093095, 3.0);
                ADD_PIXEL(0.063327, 4.0);
                #else
                ADD_PIXEL(1.0, 0.0);
                #endif
                #undef ADD_PIXEL
                
                // Multiplying at the one pass only
                // to avoid the double coloring
                color *= IN.color;

                return color;
            }
        ENDCG
        }
    }
}
