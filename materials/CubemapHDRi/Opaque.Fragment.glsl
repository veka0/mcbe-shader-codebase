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
uniform highp vec4 ColorGrading_OptimizeGammaCorrection;
uniform highp vec4 PreExposureEnabled;
in highp vec3 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void func_66b9c(inout highp vec3 arg_5a7d1, inout highp vec4 arg_37ddf) {
    if (ColorGrading_OptimizeGammaCorrection.x != 0.0)
    {
        arg_5a7d1 = pow(max(arg_37ddf.xyz, vec3(0.0)), vec3(2.2000000476837158203125));
        return;
    }
    else
    {
        highp vec3 loc_be4c0 = arg_37ddf.xyz;
        highp vec3 loc_d634f = arg_37ddf.xyz * vec3(0.077399380505084991455078125);
        highp vec3 loc_1f157 = pow((arg_37ddf.xyz + vec3(0.054999999701976776123046875)) * vec3(0.947867333889007568359375), vec3(2.400000095367431640625));
        highp float loc_e81ff;
        if (loc_be4c0.x <= 0.040449999272823333740234375)
        {
            loc_e81ff = loc_d634f.x;
        }
        else
        {
            loc_e81ff = loc_1f157.x;
        }
        loc_be4c0.x = loc_e81ff;
        highp float loc_007b0;
        if (loc_be4c0.y <= 0.040449999272823333740234375)
        {
            loc_007b0 = loc_d634f.y;
        }
        else
        {
            loc_007b0 = loc_1f157.y;
        }
        loc_be4c0.y = loc_007b0;
        highp float loc_fa4a6;
        if (loc_be4c0.z <= 0.040449999272823333740234375)
        {
            loc_fa4a6 = loc_d634f.z;
        }
        else
        {
            loc_fa4a6 = loc_1f157.z;
        }
        loc_be4c0.z = loc_fa4a6;
        arg_5a7d1 = loc_be4c0;
        return;
    }
}
void main() {
    highp vec3 var_d251a = normalize(v_texcoord0);
    var_d251a.x *= (-1.0);
    highp vec4 var_830bf = texture(s_MatTexture, var_d251a);
    if (PreExposureEnabled.x > 0.0)
    {
        highp vec4 var_7c5bd = var_830bf;
        highp vec3 var_ba7ff = var_7c5bd.xyz * ((0.180000007152557373046875 / texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05);
        var_830bf.x = var_ba7ff.x;
        var_830bf.y = var_ba7ff.y;
        var_830bf.z = var_ba7ff.z;
    }
    else
    {
        highp vec4 var_3182c = var_830bf;
        highp vec3 var_38db3;
        func_66b9c(var_38db3, var_830bf);
        var_830bf = vec4(var_38db3, var_3182c.w);
    }
    bgfx_FragData0 = var_830bf;
}
