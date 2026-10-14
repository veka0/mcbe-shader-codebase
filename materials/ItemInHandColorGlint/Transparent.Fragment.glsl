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
* - uniform lowp sampler2D s_GlintTexture;
*
* Uniforms:
* - uniform vec4 BlockLightColor;
* - uniform vec4 ChangeColor;
* - uniform vec4 ColorBased;
* - uniform vec4 DitherParams;
* - uniform vec4 DitherParams2[3];
* - uniform vec4 DitheringEnabledToggle;
* - uniform vec4 FogColor;
* - uniform vec4 FogControl;
* - uniform vec4 GlintColor;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MultiplicativeTintColor;
* - uniform vec4 OverlayColor;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 TileLightColor;
* - uniform vec4 TileLightIntensity;
* - uniform vec4 UVAnimation;
* - uniform vec4 UVScale;
*/

precision mediump float;
precision highp int;
float var_33fae;
uniform highp mat4 u_invView;
uniform highp mat4 u_view;
uniform highp sampler2D s_GlintTexture;
uniform highp vec4 ChangeColor;
uniform highp vec4 ColorBased;
uniform highp vec4 DitherParams2[3];
uniform highp vec4 DitherParams;
uniform highp vec4 DitheringEnabledToggle;
uniform highp vec4 GlintColor;
#ifdef MULTI_COLOR_TINT__ON
uniform highp vec4 MultiplicativeTintColor;
#endif
uniform highp vec4 OverlayColor;
uniform highp vec4 TileLightColor;
in highp vec4 v_clipPosition;
in highp vec4 v_color0;
in highp vec4 v_fog;
in highp vec4 v_glintUV;
in highp vec4 v_light;
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec4 var_056fc = vec4(1.0);
    highp vec3 var_08760 = mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x));
    var_056fc.x = var_08760.x;
    var_056fc.y = var_08760.y;
    var_056fc.z = var_08760.z;
    highp vec4 var_9d23e = var_056fc;
#ifdef MULTI_COLOR_TINT__OFF
    highp vec4 var_754d5 = mix(var_056fc, var_056fc * ChangeColor, vec4(v_color0.w));
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec2 var_e1236 = var_056fc.xy;
    highp vec3 var_754d5 = var_056fc.xxx * ChangeColor.xyz;
#endif
    var_9d23e.x = var_754d5.x;
    var_9d23e.y = var_754d5.y;
    var_9d23e.z = var_754d5.z;
#ifdef MULTI_COLOR_TINT__OFF
    highp vec4 var_47d41 = var_9d23e;
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec4 var_60355 = var_9d23e;
    highp vec3 var_ef570 = mix(var_60355.xyz, var_056fc.yyy * MultiplicativeTintColor.xyz, vec3(ceil(var_e1236.y)));
    var_9d23e.x = var_ef570.x;
    var_9d23e.y = var_ef570.y;
    var_9d23e.z = var_ef570.z;
    highp vec4 var_47d41 = var_9d23e;
#endif
    highp vec3 var_2a9cf = mix(var_9d23e.xyz, OverlayColor.xyz, vec3(OverlayColor.w));
    var_47d41.x = var_2a9cf.x;
    var_47d41.y = var_2a9cf.y;
    var_47d41.z = var_2a9cf.z;
    highp vec4 var_60f01 = var_47d41;
    highp vec3 var_279b1 = var_47d41.xyz * v_light.xyz;
    var_60f01.x = var_279b1.x;
    var_60f01.y = var_279b1.y;
    var_60f01.z = var_279b1.z;
    var_056fc = var_60f01;
    highp vec4 var_e166e = (GlintColor * (texture(s_GlintTexture, fract(v_glintUV.xy)).xyzx + texture(s_GlintTexture, fract(v_glintUV.zw)).xyzx)) * TileLightColor;
    highp vec4 var_acc41 = vec4(var_e166e.xyz * var_e166e.xyz, abs(var_e166e.w)) + vec4(var_60f01.xyz, 0.0);
    var_acc41.w = var_60f01.w;
    highp vec4 var_6d1d7 = var_acc41;
    highp vec2 var_7c9c5 = DitherParams2[0].xy;
    bool var_f42fb;
    if (DitheringEnabledToggle.x != 0.0)
    {
        highp mat4 var_4971e = u_view;
        highp vec2 var_2c6b3 = floor(((((v_clipPosition.xyz / vec3(v_clipPosition.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[0].z)) * DitherParams2[0].z;
        highp vec2 var_f4989 = floor(var_2c6b3 * 0.25);
        highp vec2 var_85686 = floor(var_2c6b3 * 0.5);
        highp vec2 var_09c49 = floor(var_2c6b3);
        var_f42fb = smoothstep(var_7c9c5.x, var_7c9c5.y, dot(-normalize(vec4(var_4971e[0].z, var_4971e[1].z, var_4971e[2].z, var_33fae).xyz), v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz)) <= (((((((fract((var_f4989.x * 0.5) + ((var_f4989.y * var_f4989.y) * 0.75)) * 0.25) + fract((var_85686.x * 0.5) + ((var_85686.y * var_85686.y) * 0.75))) * 0.25) + fract((var_09c49.x * 0.5) + ((var_09c49.y * var_09c49.y) * 0.75))) * 64.0) + 0.5) * 0.015625);
    }
    else
    {
        var_f42fb = false;
    }
    highp vec4 var_8cd6d = vec4(var_acc41.xyz, var_6d1d7.w * (var_f42fb ? 0.0 : 1.0));
    highp vec4 var_72c1b = var_8cd6d;
    highp vec3 var_c6e56 = mix(var_8cd6d.xyz, v_fog.xyz, vec3(v_fog.w));
    var_72c1b.x = var_c6e56.x;
    var_72c1b.y = var_c6e56.y;
    var_72c1b.z = var_c6e56.z;
    bgfx_FragData0 = var_72c1b;
}
