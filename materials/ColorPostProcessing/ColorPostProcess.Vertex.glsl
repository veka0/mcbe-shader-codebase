#version 310 es

/*
* Available Macros:
*
* Passes:
* - COLOR_POST_PROCESS_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_AverageLuminance;
* - uniform lowp sampler2D s_ColorTexture;
* - uniform lowp sampler2D s_CustomExposureCompensation;
* - uniform lowp sampler2D s_PreExposureLuminance;
* - uniform lowp sampler2D s_RasterColor;
* - uniform lowp sampler2D s_RasterizedColor;
*
* Uniforms:
* - uniform vec4 ColorGrading_Contrast_Highlights;
* - uniform vec4 ColorGrading_Contrast_Midtones;
* - uniform vec4 ColorGrading_Contrast_Shadows;
* - uniform vec4 ColorGrading_Gain_Highlights;
* - uniform vec4 ColorGrading_Gain_Midtones;
* - uniform vec4 ColorGrading_Gain_Shadows;
* - uniform vec4 ColorGrading_Gamma_Highlights;
* - uniform vec4 ColorGrading_Gamma_Midtones;
* - uniform vec4 ColorGrading_Gamma_Shadows;
* - uniform vec4 ColorGrading_Misc;
* - uniform vec4 ColorGrading_Misc2;
* - uniform vec4 ColorGrading_Offset_Highlights;
* - uniform vec4 ColorGrading_Offset_Midtones;
* - uniform vec4 ColorGrading_Offset_Shadows;
* - uniform vec4 ColorGrading_Saturation_Highlights;
* - uniform vec4 ColorGrading_Saturation_Midtones;
* - uniform vec4 ColorGrading_Saturation_Shadows;
* - uniform vec4 ColorGrading_Temperature_Params;
* - uniform vec4 ExposureCompensation;
* - uniform vec4 GenericTonemapperContrastAndScaleAndOffsetAndCrosstalk;
* - uniform vec4 GenericTonemapperCrosstalkParams;
* - uniform vec4 LuminanceMinMaxAndWhitePointAndMinWhitePoint;
* - uniform vec4 RasterizedColorEnabled;
* - uniform vec4 ScreenSize;
* - uniform vec4 TonemapParams0;
* - uniform vec4 ViewportScale;
*/

uniform vec4 ViewportScale;
in vec4 a_position;
in vec2 a_texcoord0;
out vec4 v_texcoord0;
void main() {
    vec4 var_c1461 = vec4(0.0);
    vec2 var_f32e0 = a_texcoord0 * ViewportScale.xy;
    var_c1461.x = var_f32e0.x;
    var_c1461.y = var_f32e0.y;
    var_c1461.z = a_texcoord0.x;
    var_c1461.w = a_texcoord0.y;
    v_texcoord0 = var_c1461;
    gl_Position = vec4((a_position.xy * 2.0) - vec2(1.0), 0.0, 1.0);
}
