// Custom Tonemapper
// We'll create a function so we can just call this in other shaders, instead of
// having to manage a wall of code in multiple files

#include "./shared.h"

float3 applyUserTonemap(float3 untonemapped) {
  float3 outputColor = untonemapped;

  renodx::tonemap::Config config = renodx::tonemap::config::Create();

  config.type = injectedData.toneMapType;
  config.peak_nits = injectedData.toneMapPeakNits;
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = injectedData.toneMapGammaCorrection;
  config.exposure = injectedData.colorGradeExposure;
  config.highlights = injectedData.colorGradeHighlights;
  config.shadows = injectedData.colorGradeShadows;
  config.contrast = injectedData.colorGradeContrast;
  config.saturation = injectedData.colorGradeSaturation;
  config.reno_drt_dechroma = injectedData.colorGradeBlowout;
  config.hue_correction_type =
      renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_color =
      lerp(outputColor, renodx::tonemap::Reinhard(outputColor),
           injectedData.toneMapHueCorrection);

  outputColor = renodx::tonemap::config::Apply(outputColor, config);

  outputColor *= injectedData.toneMapGameNits / injectedData.toneMapUINits;

  return outputColor;
}

// Incoming color is already adjusted by renoDX
float3 applyLUT(float3 tonemapped, SamplerState lut_sampler,
                Texture2D<float4> lut_texture) {
  float3 outputColor;

  // Mimic original LUT sampler code
  outputColor = max(0, abs(renodx::color::bt709::from::BT2020(tonemapped)));

  renodx::lut::Config lut_config = renodx::lut::config::Create(
      lut_sampler, injectedData.colorGradeLUTStrength, 0.f,
      renodx::lut::config::type::GAMMA_2_2,
      renodx::lut::config::type::GAMMA_2_2, 32);

  outputColor = renodx::lut::Sample(lut_texture, lut_config, outputColor);

  return outputColor;
}

// End applyUserTonemap