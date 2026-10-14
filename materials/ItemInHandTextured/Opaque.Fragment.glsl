#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - DEPTH_ONLY_ALPHA_TEST_PASS (not used)
* - DEPTH_ONLY_OPAQUE_PASS (not used)
* - OPAQUE_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* Fancy:
* - FANCY__OFF (not used)
* - FANCY__ON (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* MultiColorTint:
* - MULTI_COLOR_TINT__OFF
* - MULTI_COLOR_TINT__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MatTexture;
*
* Uniforms:
* - uniform vec4 AlphaMaskedTint;
* - uniform vec4 BlockLightColor;
* - uniform vec4 ChangeColor;
* - uniform vec4 ColorBased;
* - uniform vec4 DitherParams;
* - uniform vec4 DitherParams2[3];
* - uniform vec4 DitheringEnabledToggle;
* - uniform vec4 FogColor;
* - uniform vec4 FogControl;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MatColor;
* - uniform vec4 MultiplicativeTintColor;
* - uniform vec4 OverlayColor;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 TileLightColor;
* - uniform vec4 TileLightIntensity;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_MatTexture;
uniform highp vec4 AlphaMaskedTint;
uniform highp vec4 ChangeColor;
uniform highp vec4 ColorBased;
uniform highp vec4 MatColor;
#ifdef MULTI_COLOR_TINT__ON
uniform highp vec4 MultiplicativeTintColor;
#endif
uniform highp vec4 OverlayColor;
in highp vec4 v_color0;
in highp vec4 v_fog;
in highp vec4 v_light;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec4 var_216b8 = texture(s_MatTexture, v_texcoord0);
    if (AlphaMaskedTint.x != 0.0)
    {
        highp vec4 var_ec353 = var_216b8;
        highp float var_7a181 = var_216b8.w;
        highp vec3 var_d8fa6 = mix(var_ec353.xyz, var_ec353.xyz * v_color0.xyz, vec3(var_7a181));
        var_216b8.x = var_d8fa6.x;
        var_216b8.y = var_d8fa6.y;
        var_216b8.z = var_d8fa6.z;
        highp vec4 var_8e56a = var_216b8;
        highp vec3 var_a3d7a = var_8e56a.xyz * v_color0.w;
        var_216b8.x = var_a3d7a.x;
        var_216b8.y = var_a3d7a.y;
        var_216b8.z = var_a3d7a.z;
        var_216b8.w = 1.0;
    }
    else
    {
        highp vec4 var_bc465 = var_216b8;
        highp vec3 var_30e20 = var_bc465.xyz * v_color0.xyz;
        var_216b8.x = var_30e20.x;
        var_216b8.y = var_30e20.y;
        var_216b8.z = var_30e20.z;
    }
    highp vec4 var_74395 = var_216b8;
    highp vec4 var_7479c = var_74395 * MatColor;
    var_216b8 = var_7479c;
    highp vec4 var_1d897 = var_7479c;
    highp vec3 var_6f9dd = var_7479c.xyz * mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x));
    var_1d897.x = var_6f9dd.x;
    var_1d897.y = var_6f9dd.y;
    var_1d897.z = var_6f9dd.z;
    highp vec4 var_9d23e = var_1d897;
#ifdef MULTI_COLOR_TINT__OFF
    highp vec4 var_754d5 = mix(var_1d897, var_1d897 * ChangeColor, vec4(v_color0.w));
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec2 var_e1236 = var_1d897.xy;
    highp vec3 var_754d5 = var_1d897.xxx * ChangeColor.xyz;
#endif
    var_9d23e.x = var_754d5.x;
    var_9d23e.y = var_754d5.y;
    var_9d23e.z = var_754d5.z;
#ifdef MULTI_COLOR_TINT__OFF
    highp vec4 var_47d41 = var_9d23e;
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec4 var_60355 = var_9d23e;
    highp vec3 var_ef570 = mix(var_60355.xyz, var_1d897.yyy * MultiplicativeTintColor.xyz, vec3(ceil(var_e1236.y)));
    var_9d23e.x = var_ef570.x;
    var_9d23e.y = var_ef570.y;
    var_9d23e.z = var_ef570.z;
    highp vec4 var_47d41 = var_9d23e;
#endif
    highp vec3 var_2a9cf = mix(var_9d23e.xyz, OverlayColor.xyz, vec3(OverlayColor.w));
    var_47d41.x = var_2a9cf.x;
    var_47d41.y = var_2a9cf.y;
    var_47d41.z = var_2a9cf.z;
    highp vec4 var_dfd17 = var_47d41;
    highp vec3 var_279b1 = var_47d41.xyz * v_light.xyz;
    var_dfd17.x = var_279b1.x;
    var_dfd17.y = var_279b1.y;
    var_dfd17.z = var_279b1.z;
    var_1d897 = var_dfd17;
    highp vec4 var_1d587 = var_dfd17;
    highp vec4 var_4b012 = vec4(var_dfd17.xyz, var_1d587.w);
    highp vec4 var_72c1b = var_4b012;
    highp vec3 var_c6e56 = mix(var_4b012.xyz, v_fog.xyz, vec3(v_fog.w));
    var_72c1b.x = var_c6e56.x;
    var_72c1b.y = var_c6e56.y;
    var_72c1b.z = var_c6e56.z;
    bgfx_FragData0 = var_72c1b;
}
