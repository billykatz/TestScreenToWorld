Shader "Unlit/SH_HighlightArea_Squircle"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _HighlightAreaCenter ("Highlight Area Center",  float) = (0, 0, 0, 0)
        _HighlightAreaWidth ("Highlight Area Width",  float) = 1.0
        _HighlightAreaHeight ("Highlight Area Height",  float) = 1.0
        _HighlightAreaRadius ("Highlight Area Radius",  float) = 1.0
        _HighlightAreaStrokeEffect ("Highlight Area Stroke Effect", float) = 1.0
    }
    SubShader
    {
        Tags 
        {
            "RenderType"="Transparent"
             "Queue" = "Transparent" 
        }

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            
            #define TAU 6.283185307179586

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 worldPos: TEXCOORD1;
                float4 squarePos: TEXCOORD2;
            };

            float4 _Color;
            float2 _HighlightAreaCenter;
            float _HighlightAreaWidth;
            float _HighlightAreaHeight;
            float _HighlightAreaRadius;
            float _HighlightAreaStrokeEffect;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.worldPos = mul(UNITY_MATRIX_M, v.vertex);

                // calculate the positions of the square we want to highlight
                float leftX = _HighlightAreaCenter.x - (_HighlightAreaWidth/(float)2);
                float rightX = _HighlightAreaCenter.x + _HighlightAreaWidth/2;
                float topY = _HighlightAreaCenter.y + _HighlightAreaHeight/2;
                float bottomY = _HighlightAreaCenter.y - _HighlightAreaHeight/2;
                o.squarePos = float4(leftX, topY, rightX, bottomY);
                
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {

                // get the world space distance between the vertex and the area we want to highlight

                
                float closestX = i.worldPos.x;
                float closestY = i.worldPos.y;


                if (i.worldPos.x < i.squarePos.x)
                {
                    closestX = i.squarePos.x;  
                } else if (i.worldPos.x > i.squarePos.z)
                {
                    closestX = i.squarePos.z;
                }

                if (i.worldPos.y > i.squarePos.y)
                {
                    closestY = i.squarePos.y;
                } else if (i.worldPos.y < i.squarePos.w)
                {
                    closestY = i.squarePos.w;
                }
                
                float distanceFromLine = distance(i.worldPos, float2(closestX, closestY));
                
                // return float4(distanceFromLine.x , 0, 0, 1);
                if (distanceFromLine < _HighlightAreaRadius)
                {
                    // early return if the point is within the radius of the highlight center
                    return float4(_Color.xyz, 0.0); 
                }

                if (distanceFromLine < _HighlightAreaStrokeEffect)
                {
                    // create an effect to highlight the area even more
                    return cos(2 * TAU * (distanceFromLine - _Time.y * 0.25)) * 0.5 + 0.5;
                }

                
                return _Color;
            }
            ENDCG
        }
    }
}
