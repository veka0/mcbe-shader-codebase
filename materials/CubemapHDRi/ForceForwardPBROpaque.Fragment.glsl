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
    highp vec4 var_c58bf = texture(s_MatTexture, var_d251a);
    highp vec4 var_d912f;
    if (PreExposureEnabled.x > 0.0)
    {
        highp vec3 var_02f69 = var_c58bf.xyz * ((0.180000007152557373046875 / texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05);
        var_d912f = vec4(var_02f69.x, var_02f69.y, var_02f69.z, var_c58bf.w);
    }
    else
    {
        var_d912f = var_c58bf;
    }
    bgfx_FragData0 = var_d912f;
}
