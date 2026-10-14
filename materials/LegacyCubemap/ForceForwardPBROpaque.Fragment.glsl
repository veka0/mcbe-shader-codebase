#version 310 es

/*
* Available Macros:
*
* Passes:
* - FORCE_FORWARD_PBR_OPAQUE_PASS (not used)
* - TRANSPARENT_PASS (not used)
* - TRANSPARENT_DEGAMMA_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MatTexture;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
*
* Uniforms:
* - uniform vec4 ColorGrading_OptimizeGammaCorrection;
* - uniform mat4 CubemapRotation;
* - uniform vec4 PreExposureEnabled;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_MatTexture;
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform highp vec4 PreExposureEnabled;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec4 var_c8b0a = texture(s_MatTexture, v_texcoord0);
    if (PreExposureEnabled.x > 0.0)
    {
        highp vec4 var_7c5bd = var_c8b0a;
        highp vec3 var_ba7ff = var_7c5bd.xyz * ((0.180000007152557373046875 / texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05);
        var_c8b0a.x = var_ba7ff.x;
        var_c8b0a.y = var_ba7ff.y;
        var_c8b0a.z = var_ba7ff.z;
    }
    bgfx_FragData0 = var_c8b0a;
}
