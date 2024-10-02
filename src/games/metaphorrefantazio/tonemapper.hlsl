// Custom Tonemapper
// We'll create a function so we can just call this in other shaders, instead of
// having to manage a wall of code in multiple files

#include "./shared.h"

renodx::tonemap::Config getCommonConfig() {
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

  return config;
}

float3 applyUserTonemap(float3 untonemapped,
                        bool forceUntonemappedType = false) {
  float3 outputColor = untonemapped;

  renodx::tonemap::Config config = getCommonConfig();

  /* Foreground isn't tonemapped at all but we still want sliders to work */
  if (forceUntonemappedType) {
    config.type = 1.f;
  }

  if (injectedData.toneMapType == 0.f) {
    outputColor = saturate(outputColor);
  }

  outputColor = renodx::tonemap::config::Apply(outputColor, config);

  return outputColor;
}

float3 applyUserTonemapWithLUT(float3 untonemapped, SamplerState lut_sampler,
                               Texture2D<float4> lut_texture) {
  float3 outputColor;

  // Mimic original LUT sampler code
  outputColor = max(0, abs(renodx::color::bt709::from::BT2020(untonemapped)));

  renodx::tonemap::Config config = getCommonConfig();

  config.hue_correction_type =
      renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_color =
      lerp(outputColor, renodx::tonemap::Reinhard(outputColor),
           injectedData.toneMapHueCorrection);

  renodx::lut::Config lut_config = renodx::lut::config::Create(
      lut_sampler, injectedData.colorGradeLUTStrength, 0.f,
      renodx::lut::config::type::GAMMA_2_2,
      renodx::lut::config::type::GAMMA_2_2, 32);

  if (injectedData.toneMapType == 0.f) {
    outputColor = saturate(outputColor);
  }

  outputColor = renodx::tonemap::config::Apply(outputColor, config, lut_config,
                                               lut_texture);

  return outputColor;
}

// End applyUserTonemap