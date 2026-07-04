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

in vec4 a_position;
in vec2 a_texcoord0;
out vec2 v_texcoord0;
void main() {
    vec2 var_8e808 = a_texcoord0;
    v_texcoord0 = vec2(var_8e808.x, var_8e808.y);
    gl_Position = vec4((a_position.xy * 2.0) - vec2(1.0), 0.0, 1.0);
}
