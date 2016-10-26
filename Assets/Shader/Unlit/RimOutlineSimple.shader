﻿Shader "ZZL/Unlit/Rim Outline Simple" {
	Properties {
		_MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
		_RimColor ("Rim Color", Color) = (1,1,1,1)
	    _RimPower ("Rim Power", Range(0.0,100.0)) = 2.0
	}
	SubShader {
	
		Tags { "RenderType"="Opaque" "IgnoreProjector"="True"}
		LOD 100
		Lighting off
		Pass
		{
			CGPROGRAM

				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"
				
				sampler2D _MainTex;
				float4 _MainTex_ST;
				fixed4 _RimColor;
				half _RimPower;
				
				struct vInput {
                	float4 vertex : POSITION;
                	float4 normal : NORMAL;
					half2 texcoord : TEXCOORD0;
	            };

	            struct v2f {
					half2 texcoord : TEXCOORD0;
	                float4 position : SV_POSITION;
	                float3 emssion:TEXCOORD1;
	            };

	            v2f vert(vInput i) {
	                v2f o;

	                float4x4 modelMatrix        = _Object2World;
	                float4x4 modelMatrixInverse = _World2Object;

	                float3 normalDirection = normalize(mul(i.normal, modelMatrixInverse)).xyz;
	                float3 viewDirection   = normalize(_WorldSpaceCameraPos - mul(modelMatrix, i.vertex).xyz);

					o.texcoord = TRANSFORM_TEX(i.texcoord, _MainTex);
	                o.position = mul(UNITY_MATRIX_MVP, i.vertex);
	                
	                
	                half rim = 1.0 - saturate(dot (normalize(viewDirection), normalDirection));
				    o.emssion = _RimColor.rgb * pow (rim, _RimPower)*_RimColor.a;

	                return o;
	            }
				
				fixed4 frag (v2f IN) : COLOR
				{
				    fixed4 col = tex2D(_MainTex,IN.texcoord);
				    col.rgb += IN.emssion;
				    return col;
				}
			
			ENDCG
		}
	} 
	FallBack "Diffuse"
}
