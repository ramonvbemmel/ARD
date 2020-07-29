Shader "Cg per-vertex diffuse lighting" {
   Properties {
      _Color ("Diffuse Material Color", Color) = (1,1,1,1) 
   }
   SubShader {
      Pass {	
         Tags { "LightMode" = "ForwardBase" } 
 
         CGPROGRAM
 
         #pragma vertex vert  
         #pragma fragment frag 
 
         #include "UnityCG.cginc"

 
         uniform float4 _Color;
         uniform float _X_AS;
         uniform float _Y_AS;

         struct vertexInput {
            float4 vertex : POSITION;
            float3 normal : NORMAL;
         };
         struct vertexOutput {
            float4 pos : SV_POSITION;
            float4 col : COLOR;
         };
 
         vertexOutput vert(vertexInput input) 
         {
            vertexOutput output;

            float4x4 modelMatrix = unity_ObjectToWorld;
            float4x4 modelMatrixInverse = unity_WorldToObject;

            //Object normal vector
            float3 normalDirection = UnityObjectToWorldNormal(input.normal);

            //get position of the sun
            float3 sun_pos = float3(float(_X_AS), float(_Y_AS), 0);
            sun_pos = mul(sun_pos, 20);
            
            //Direction of the sun
            float3 vertexToSun = sun_pos - mul(modelMatrix, input.vertex).xyz;

            //Distance to the sun 
            float distance = length(vertexToSun);

            float attenuation = 100 / distance; 
            float3 NormSunDirection = normalize(vertexToSun);
            float3 diffuseReflection =   attenuation * _Color.rgb * max(0.0, dot(normalDirection, NormSunDirection));

            //Output the reflection
            output.col = float4(diffuseReflection, 1.0);

            // Makes the "world sphare" bigger if distance gets smaller/ 
            output.pos = UnityObjectToClipPos(mul(input.vertex, (320-distance)/100));
            return output;
         }
 
         float4 frag(vertexOutput input) : COLOR
         {
            return input.col;
         }
 
         ENDCG
      }
   }
   Fallback "Diffuse"
}