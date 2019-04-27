﻿// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)
Shader "Blur-Demo/GrabPass_main"
{
    Properties
    {
        _Color ("Tint", Color) = (1,1,1,1)

        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255

        _ColorMask ("Color Mask", Float) = 15

        [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
        [Toggle(BLUR)] _Blur ("Blur Enabled?", Float) = 0
    }

    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "RenderType"="Transparent"
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True"
        }

        Stencil
        {
            Ref [_Stencil]
            Comp [_StencilComp]
            Pass [_StencilOp]
            ReadMask [_StencilReadMask]
            WriteMask [_StencilWriteMask]
        }

        Cull Off
        Lighting Off
        ZWrite Off
        ZTest [unity_GUIZTestMode]
        Blend SrcAlpha OneMinusSrcAlpha
        ColorMask [_ColorMask]
        
        // Oops!
        GrabPass { }
        // Oops!
        
        // Horizontal
        Pass
        {
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0

            #include "UnityCG.cginc"
            #include "UnityUI.cginc"

            #pragma multi_compile __ UNITY_UI_CLIP_RECT
            #pragma multi_compile __ UNITY_UI_ALPHACLIP
            
            #pragma shader_feature BLUR
            
            struct appdata_t
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
            };

            struct v2f
            {
                float4 vertex   : SV_POSITION;
                fixed4 color    : COLOR;
                float4 texcoord  : TEXCOORD0;
            };

            fixed4 _Color;
            fixed4 _TextureSampleAdd;
            float4 _ClipRect;
            
            sampler2D _GrabTexture;
            float4 _GrabTexture_ST;
            // x contains 1.0/width
            // y contains 1.0/height
            // z contains width
            // w contains height
            float4 _GrabTexture_TexelSize;

            v2f vert(appdata_t v)
            {
                v2f OUT;
                OUT.vertex = UnityObjectToClipPos(v.vertex);
                OUT.texcoord = ComputeGrabScreenPos(OUT.vertex);
                OUT.color = v.color * _Color;
                return OUT;
            }

            fixed4 frag(v2f IN) : SV_Target
            {
                half4 color = half4(0.0, 0.0, 0.0, 0.0);
                float4 centerUv = IN.texcoord;
                
                #define ADD_PIXEL(coeff, delta) color += tex2Dproj(_GrabTexture, centerUv + float4(delta * _GrabTexture_TexelSize.x, 0.0, 0.0, 0.0)) * coeff
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
                
                #ifdef UNITY_UI_CLIP_RECT
                color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
                #endif

                #ifdef UNITY_UI_ALPHACLIP
                clip (color.a - 0.001);
                #endif

                return color;
            }
        ENDCG
        }
        
        
        // Oops I did it again!
        GrabPass { }
        // Oops I did it again!
        
        // Vertical
        Pass
        {
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0

            #include "UnityCG.cginc"
            #include "UnityUI.cginc"

            #pragma multi_compile __ UNITY_UI_CLIP_RECT
            #pragma multi_compile __ UNITY_UI_ALPHACLIP
            
            #pragma shader_feature BLUR
            
            struct appdata_t
            {
                float4 vertex   : POSITION;
            };

            struct v2f
            {
                float4 vertex   : SV_POSITION;
                float4 texcoord  : TEXCOORD0;
            };

            fixed4 _Color;
            fixed4 _TextureSampleAdd;
            float4 _ClipRect;
            
            sampler2D _GrabTexture;
            float4 _GrabTexture_ST;
            // x contains 1.0/width
            // y contains 1.0/height
            // z contains width
            // w contains height
            float4 _GrabTexture_TexelSize;

            v2f vert(appdata_t v)
            {
                v2f OUT;
                OUT.vertex = UnityObjectToClipPos(v.vertex);
                OUT.texcoord = ComputeGrabScreenPos(OUT.vertex);
                return OUT;
            }

            fixed4 frag(v2f IN) : SV_Target
            {
                half4 color = half4(0.0, 0.0, 0.0, 0.0);
                float4 centerUv = IN.texcoord;
                
                #define ADD_PIXEL(coeff, delta) color += tex2Dproj(_GrabTexture, centerUv + float4(0.0, delta * _GrabTexture_TexelSize.y, 0.0, 0.0)) * coeff
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
                                
                #ifdef UNITY_UI_CLIP_RECT
                color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
                #endif

                #ifdef UNITY_UI_ALPHACLIP
                clip (color.a - 0.001);
                #endif

                return color;
            }
        ENDCG
        }
    }
}
