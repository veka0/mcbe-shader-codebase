#version 310 es

/*
* Available Macros:
*
* Passes:
* - FORCE_FORWARD_PBR_OPAQUE_PASS (not used)
* - OPAQUE_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp samplerCube s_MatTexture;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
*
* Uniforms:
* - uniform vec4 ColorGrading_OptimizeGammaCorrection;
* - uniform mat4 CubemapRotation;
* - uniform vec4 PreExposureEnabled;
* - uniform vec4 SubPixelOffset;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform highp samplerCube s_MatTexture;
uniform highp vec4 PreExposureEnabled;
in highp vec3 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec3 var_d251a = normalize(v_texcoord0);
    var_d251a.x *= (-1.0);
    highp vec4 var_d33c8 = texture(s_MatTexture, var_d251a);
    if (PreExposureEnabled.x > 0.0)
    {
        highp vec4 var_7c5bd = var_d33c8;
        highp vec3 var_ba7ff = var_7c5bd.xyz * ((0.180000007152557373046875 / texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05);
        var_d33c8.x = var_ba7ff.x;
        var_d33c8.y = var_ba7ff.y;
        var_d33c8.z = var_ba7ff.z;
    }
    bgfx_FragData0 = var_d33c8;
}
