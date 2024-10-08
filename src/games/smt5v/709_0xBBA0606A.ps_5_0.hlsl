// ---- Created with 3Dmigoto v1.3.16 on Sun Jul  7 17:53:22 2024
#include "./shared.h"
//#include "../../shaders/colorcorrect.hlsl"

Texture3D<float4> t3 : register(t3); //LUT made by LUTBUILDER

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0); //untonemapped ?

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
    float4 cb1[136];
}

cbuffer cb0 : register(b0)
{
    float4 cb0[68];
}




// 3Dmigoto declarations
#define cmp -

//main changed from void -> float4

//vanilla code VV
void main(
  linear noperspective float2 v0 : TEXCOORD0,
  linear noperspective float2 w0 : TEXCOORD3,
  linear noperspective float4 v1 : TEXCOORD1,
  linear noperspective float4 v2 : TEXCOORD2,
  float2 v3 : TEXCOORD4,
  float4 v4 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
    float4 r0, r1, r2;
    uint4 bitmask, uiDest;
    float4 fDest;



    r0.x = v2.w * 543.309998 + v2.z;
    r0.x = sin(r0.x);
    r0.x = 493013 * r0.x;
    r0.x = frac(r0.x);
    
    r0.yzw = t0.Sample(s0_s, v0.xy).xyz; //Renderer? [vanilla]
    //const float3 texture0Input = t0.Sample(s0_s, v0.xy).xyz;
    //r0.yzw = texture0Input.rgb;
    
    r0.yzw = cb1[135].zzz * r0.yzw;
    r1.xy = cb0[58].zw * v0.xy + cb0[59].xy;
    r1.xy = max(cb0[50].zw, r1.xy);
    r1.xy = min(cb0[51].xy, r1.xy);
    r1.xyz = t1.Sample(s1_s, r1.xy).xyz;
    r1.xyz = cb1[135].zzz * r1.xyz;
    r2.xy = w0.xy * cb0[67].zw + cb0[67].xy;
    r2.xy = r2.xy * float2(0.5, -0.5) + float2(0.5, 0.5);
    r2.xyz = t2.Sample(s2_s, r2.xy).xyz; //ACES?
    r2.xyz = r2.xyz * cb0[66].xyz + cb0[61].xyz;
    r1.xyz = r2.xyz * r1.xyz;
    r0.yzw = r0.yzw * cb0[60].xyz + r1.xyz;
    
    //Adding untonemapped here gives you the image pre-aces/lutbuilder -- copied the location from Shortfuse's Hifi Rush mod
    //float3 untonemapped = r0.yzw; //untonemapped image?
    
    r0.yzw = v1.xxx * r0.yzw; //auto exposure?
    r1.xy = cb0[62].xx * v1.yz;
    r1.x = dot(r1.xy, r1.xy);
    r1.x = 1 + r1.x;
    r1.x = rcp(r1.x);
    r1.x = r1.x * r1.x;
    

    
    
    
    //messing with mid grey
    //if (injectedData.toneMapType != 0.f)
    //{
    //    r0.yzw = float3(0.18, 0.18, 0.18);
    //}
    
    
   
    r0.yzw = r0.yzw * r1.xxx + float3(0.00266771927, 0.00266771927, 0.00266771927);
  
    
    r0.yzw = log2(r0.yzw);
    
    
    
   //LUT stuff Start
   //r0.yzw = saturate(r0.yzw * float3(0.0714285746,0.0714285746,0.0714285746) + float3(0.610726953,0.610726953,0.610726953));
    r0.yzw = r0.yzw * float3(0.0714285746, 0.0714285746, 0.0714285746) + float3(0.610726953, 0.610726953, 0.610726953); //no saturate -- IMPORTANT LUT
  
    
    
    

    r0.yzw = r0.yzw * float3(0.96875, 0.96875, 0.96875) + float3(0.015625, 0.015625, 0.015625); //lut? [vanilla code]
    
    
    r0.yzw = t3.Sample(s3_s, r0.yzw).xyz; //lut generated by lut builder? -- comment = game looks normal except color correction
    

    
    //LUT stuff End
    
    r1.xyz = float3(1.04999995, 1.04999995, 1.04999995) * r0.yzw;
    
    
   //o0.w = saturate(dot(r1.xyz, float3(0.298999995,0.587000012,0.114))); //rec601 [vanilla code]
    o0.w = dot(r1.xyz, float3(0.2126f, 0.7152f, 0.0722f)); //rec709 no saturate
    //o0.w = saturate(dot(r1.xyz, float3(0.2126f, 0.7152f, 0.0722f))); //rec709 + saturate
    r0.x = r0.x * 0.00390625 + -0.001953125;
    r0.xyz = r0.yzw * float3(1.04999995, 1.04999995, 1.04999995) + r0.xxx;
    
    
    if (cb0[65].x != 0)
    {
        r1.xyz = log2(r0.xyz);
        r1.xyz = float3(0.0126833133, 0.0126833133, 0.0126833133) * r1.xyz;
        r1.xyz = exp2(r1.xyz);
        r2.xyz = float3(-0.8359375, -0.8359375, -0.8359375) + r1.xyz;
        r2.xyz = max(float3(0, 0, 0), r2.xyz);
        r1.xyz = -r1.xyz * float3(18.6875, 18.6875, 18.6875) + float3(18.8515625, 18.8515625, 18.8515625);
        r1.xyz = r2.xyz / r1.xyz;
        r1.xyz = log2(r1.xyz);
        r1.xyz = float3(6.27739477, 6.27739477, 6.27739477) * r1.xyz;
        r1.xyz = exp2(r1.xyz);
        r1.xyz = float3(10000, 10000, 10000) * r1.xyz;
        r1.xyz = r1.xyz / cb0[64].www;
        r1.xyz = max(float3(6.10351999e-05, 6.10351999e-05, 6.10351999e-05), r1.xyz);
        r2.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r1.xyz;
        r1.xyz = max(float3(0.00313066994, 0.00313066994, 0.00313066994), r1.xyz);
        
   //r1.xyz = log2(r1.xyz); //2.4 gamma
   //r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;//2.4 gamma
   // r1.xyz = exp2(r1.xyz); //2.4 gamma
        r1.xyz = sign(r1.xyz) * pow(r1.xyz, 1 / 2.4); //2.4 gamma re-written
        
        //get luminance data for middle grey
        //if (injectedData.toneMapType != 0.f)
        //{
        //r1.xyz = dot(float3(0.298999995, 0.587000012, 0.114), r0.yzw);
        //}
        
        r1.xyz = r1.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
        
        o0.xyz = min(r2.xyz, r1.xyz); //vanilla output?

        

        
    }
    else
    {
        o0.xyz = r0.xyz; //vanilla output 2??
    }
    
    //vanilla code end

     
    
    
    return;
}
    
    
    
 