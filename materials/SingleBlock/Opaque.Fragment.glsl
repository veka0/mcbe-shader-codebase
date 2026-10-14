#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - DEPTH_ONLY_ALPHA_TEST_PASS (not used)
* - OPAQUE_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* AlphaTest:
* - ALPHA_TEST__OFF
* - ALPHA_TEST__ON_DISCARD_VALUE_BASED
* - ALPHA_TEST__ON_VERTEX_TINT_MASK_BASED
*
* Lit:
* - LIT__OFF (not used)
* - LIT__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MatTexture;
*
* Uniforms:
* - uniform vec4 AlphaMaskedTint;
* - uniform vec4 ChangeColor;
* - uniform vec4 CurrentColor;
* - uniform vec4 DiscardValue;
* - uniform vec4 DitherParams;
* - uniform vec4 DitherParams2[3];
* - uniform vec4 DitheringEnabledToggle;
* - uniform vec4 FogColor;
* - uniform vec4 FogControl;
* - uniform vec4 HudOpacity;
* - uniform vec4 OverlayColor;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 TileLightColor;
* - uniform vec4 TileLightIntensity;
* - uniform vec4 UVAnimation;
* - uniform vec4 ZShiftValue;
*/

precision mediump float;
precision highp int;
#ifndef ALPHA_TEST__OFF
float var_33fae;
uniform highp mat4 u_invView;
uniform highp mat4 u_view;
#endif
uniform highp sampler2D s_MatTexture;
uniform highp vec4 AlphaMaskedTint;
uniform highp vec4 CurrentColor;
#ifdef ALPHA_TEST__ON_DISCARD_VALUE_BASED
uniform highp vec4 DiscardValue;
#endif
#ifndef ALPHA_TEST__OFF
uniform highp vec4 DitherParams2[3];
uniform highp vec4 DitherParams;
uniform highp vec4 DitheringEnabledToggle;
#endif
uniform highp vec4 HudOpacity;
uniform highp vec4 OverlayColor;
#ifndef ALPHA_TEST__OFF
in highp vec4 v_clipPosition;
#endif
in highp vec4 v_color;
in highp vec4 v_fog;
#ifdef LIT__ON
in highp vec4 v_light;
#endif
centroid in highp vec2 v_texCoords;
#ifndef ALPHA_TEST__OFF
in highp vec3 v_worldPos;
#endif
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec4 var_d358e = vec4(0.0);
    highp vec4 var_dd77e = texture(s_MatTexture, v_texCoords);
#ifndef ALPHA_TEST__OFF
    highp vec2 var_ab580 = DitherParams2[1].xy;
    bool var_40e52;
    if (DitheringEnabledToggle.x != 0.0)
    {
        highp mat4 var_4971e = u_view;
        highp vec2 var_3626b = floor(((((v_clipPosition.xyz / vec3(v_clipPosition.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[1].z)) * DitherParams2[1].z;
        highp vec2 var_f4989 = floor(var_3626b * 0.25);
        highp vec2 var_85686 = floor(var_3626b * 0.5);
        highp vec2 var_09c49 = floor(var_3626b);
        var_40e52 = smoothstep(var_ab580.x, var_ab580.y, dot(-normalize(vec4(var_4971e[0].z, var_4971e[1].z, var_4971e[2].z, var_33fae).xyz), v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz)) <= (((((((fract((var_f4989.x * 0.5) + ((var_f4989.y * var_f4989.y) * 0.75)) * 0.25) + fract((var_85686.x * 0.5) + ((var_85686.y * var_85686.y) * 0.75))) * 0.25) + fract((var_09c49.x * 0.5) + ((var_09c49.y * var_09c49.y) * 0.75))) * 64.0) + 0.5) * 0.015625);
    }
    else
    {
        var_40e52 = false;
    }
    if (!(AlphaMaskedTint.x != 0.0))
    {
#endif
#ifdef ALPHA_TEST__ON_DISCARD_VALUE_BASED
        if ((var_dd77e.w < DiscardValue.x) || var_40e52)
#endif
#ifdef ALPHA_TEST__ON_VERTEX_TINT_MASK_BASED
        if ((var_dd77e.w <= 0.0) || var_40e52)
#endif
#ifndef ALPHA_TEST__OFF
        {
            discard;
        }
    }
#endif
    highp vec4 var_ffb5d = var_dd77e;
    highp vec3 var_2a9cf = mix(var_ffb5d.xyz, OverlayColor.xyz, vec3(OverlayColor.w));
    var_dd77e.x = var_2a9cf.x;
    var_dd77e.y = var_2a9cf.y;
    var_dd77e.z = var_2a9cf.z;
#ifdef LIT__ON
    var_dd77e *= v_light;
#endif
    if (AlphaMaskedTint.x != 0.0)
    {
        highp vec4 var_27464 = var_dd77e;
        highp float var_49bb2 = var_dd77e.w;
        highp vec3 var_905e7 = CurrentColor.xyz * mix(var_27464.xyz, var_27464.xyz * v_color.xyz, vec3(var_49bb2));
        var_dd77e.x = var_905e7.x;
        var_dd77e.y = var_905e7.y;
        var_dd77e.z = var_905e7.z;
        highp vec4 var_e9c42 = var_dd77e;
        highp vec3 var_b0b3b = var_e9c42.xyz * v_color.w;
        var_dd77e.x = var_b0b3b.x;
        var_dd77e.y = var_b0b3b.y;
        var_dd77e.z = var_b0b3b.z;
        var_dd77e.w = 1.0;
    }
    else
    {
        var_dd77e = (CurrentColor * v_color) * var_dd77e;
    }
    var_dd77e.w *= HudOpacity.x;
    var_d358e = var_dd77e;
    highp vec3 var_c6e56 = mix(var_dd77e.xyz, v_fog.xyz, vec3(v_fog.w));
    var_d358e.x = var_c6e56.x;
    var_d358e.y = var_c6e56.y;
    var_d358e.z = var_c6e56.z;
    bgfx_FragData0 = var_d358e;
}
