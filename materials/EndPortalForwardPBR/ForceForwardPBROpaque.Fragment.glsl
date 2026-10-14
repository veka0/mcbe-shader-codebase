#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_OPAQUE_PASS (not used)
* - FORCE_FORWARD_PBR_OPAQUE_PASS (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_ColorTexture;
* - uniform lowp sampler2D s_ParallaxTexture;
*
* Uniforms:
* - uniform vec4 ColorGrading_OptimizeGammaCorrection;
* - uniform vec4 EndPortalEmissiveMultiplierAndDesaturation;
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 ViewPositionAndTime;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_ColorTexture;
uniform highp sampler2D s_ParallaxTexture;
uniform highp vec4 ColorGrading_OptimizeGammaCorrection;
uniform highp vec4 EndPortalEmissiveMultiplierAndDesaturation;
centroid in highp vec2 v_colorUV;
in highp float v_encodedPlane;
in highp vec4 v_fog;
centroid in highp vec2 v_parallaxUV;
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
    highp vec4 var_904e8 = vec4(0.0);
    highp vec4 var_bf7cf = texture(s_ColorTexture, v_colorUV);
    highp vec4 var_966bf = var_bf7cf;
    highp vec3 var_1dca6 = var_bf7cf.xyz * (texture(s_ParallaxTexture, v_parallaxUV).xyz * (1.0 - v_encodedPlane));
    var_966bf.x = var_1dca6.x;
    var_966bf.y = var_1dca6.y;
    var_966bf.z = var_1dca6.z;
    if ((v_encodedPlane * 32.0) > 31.0)
    {
        var_966bf = vec4(v_fog.xyz * v_fog.w, 1.0);
    }
    else
    {
        var_966bf = vec4(var_966bf.xyz * (1.0 - v_fog.w), 0.0);
    }
    var_904e8 = var_966bf;
    highp vec4 var_ab9d7 = var_966bf;
    highp vec3 var_a32a9;
    func_66b9c(var_a32a9, var_966bf);
    highp vec4 var_e4b06 = vec4(var_a32a9, var_ab9d7.w);
    var_904e8 = var_e4b06;
    highp vec3 var_4b784 = var_e4b06.xyz;
    highp vec3 var_250ad = var_e4b06.xyz + (mix(var_4b784, vec3(dot(var_4b784, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))), vec3(EndPortalEmissiveMultiplierAndDesaturation.y)) * EndPortalEmissiveMultiplierAndDesaturation.x);
    var_904e8.x = var_250ad.x;
    var_904e8.y = var_250ad.y;
    var_904e8.z = var_250ad.z;
    bgfx_FragData0 = var_904e8;
}
