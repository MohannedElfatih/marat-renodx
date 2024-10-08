// ---- Created with 3Dmigoto v1.3.16 on Fri Aug 16 22:01:37 2024
// UI, Radio waves

#include "./shared.h"

SamplerState transmap_samp_state_s : register(s0);
Texture2D<float4> transmap_samp : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : COLOR0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = transmap_samp.Sample(transmap_samp_state_s, v2.xy, int2(0, 0)).xyzw;
  r0.xyzw = v2.zzzz * r0.xyzw;
  r1.xyzw = transmap_samp.Sample(transmap_samp_state_s, v1.xy, int2(0, 0)).xyzw;
  r2.x = 1 + -v2.z;
  r0.xyzw = r1.xzwy * r2.xxxx + r0.xzwy;
  r1.xy = float2(-0.517647088,-0.517647088) + r0.yx;
  r1.z = -r1.y + r0.z;
  r2.w = r1.z + -r1.x;
  r2.yz = r1.yx + r0.zz;
  r2.x = r2.y + -r1.x;
  r1.xyz = float3(-0.5,-0.5,-0.5) + r2.xzw;
  r0.xyz = v1.www * r1.xyz + float3(0.5,0.5,0.5);
  r0.xyzw = v0.xyzw * r0.xyzw;
  r0.xyz = saturate(r0.xyz);
  r0.xyz = r0.xyz * r0.www;
  o0.w = r0.w;
  o0.xyz = v1.zzz * r0.xyz;
    
    o0.rgb = renodx::math::SafePow(o0.rgb, 2.2f); // 2.2 gamma correction
    o0.rgb *= injectedData.toneMapUINits / injectedData.toneMapGameNits; //Ratio of UI:Game brightness
    o0.rgb = renodx::math::SafePow(o0.rgb, 1 / 2.2); //Inverse 2.2 gamma
    
  return;
}