#version 310 es

/*
* Available Macros:
*
* Passes:
* - TONE_MAPPING_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_RasterColor;
* - uniform lowp sampler2D s_gBloomBuffer;
* - uniform lowp sampler2D s_gRasterizedInput;
* - uniform lowp sampler2D s_gToneCurve;
*
* Uniforms:
* - uniform vec4 RenderMode;
* - uniform vec4 ScreenSize;
* - uniform vec4 gBloomMultiplier;
* - uniform vec4 gColorGradingEnabled;
* - uniform vec4 gPerformSRGBConversion;
* - uniform vec4 gToneMappingColorBalance;
* - uniform vec4 gToneMappingContrast;
* - uniform vec4 gToneMappingDebugMode;
* - uniform vec4 gToneMappingFilmicSaturationCorrection;
* - uniform vec4 gToneMappingGamma;
* - uniform vec4 gToneMappingIntensity;
* - uniform vec4 gToneMappingSaturation;
* - uniform vec4 gToneMappingShadowContrast;
* - uniform vec4 gToneMappingShadowContrastEnd;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_RasterColor;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    bgfx_FragColor = texture(s_RasterColor, v_texcoord0);
}
