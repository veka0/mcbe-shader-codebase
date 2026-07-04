#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - DEPTH_ONLY_PASS (not used)
* - OPAQUE_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* AlphaTest:
* - ALPHA_TEST__OFF
* - ALPHA_TEST__ON_DISCARD_VALUE_BASED
* - ALPHA_TEST__ON_VERTEX_TINT_MASK_BASED
*
* Lit:
* - LIT__OFF
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
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_4e612 = v_color;
    highp vec4 var_4898e = texture(s_MatTexture, v_texCoords);
#ifndef ALPHA_TEST__OFF
    highp vec2 var_ab580 = DitherParams2[1].xy;
    bool var_40e52;
    if (DitheringEnabledToggle.x != 0.0)
    {
        highp mat4 var_4971e = u_view;
        highp vec4 var_75953 = v_clipPosition;
        highp vec2 var_376f6 = floor(((((v_clipPosition.xyz / vec3(var_75953.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[1].z)) * DitherParams2[1].z;
        highp vec2 var_f4989 = floor(var_376f6 * 0.25);
        highp vec2 var_85686 = floor(var_376f6 * 0.5);
        highp vec2 var_09c49 = floor(var_376f6);
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
        if ((var_4898e.w < DiscardValue.x) || var_40e52)
#endif
#ifdef ALPHA_TEST__ON_VERTEX_TINT_MASK_BASED
        if ((var_4898e.w <= 0.0) || var_40e52)
#endif
#ifndef ALPHA_TEST__OFF
        {
            discard;
        }
    }
#endif
    highp vec3 var_e9539 = mix(var_4898e.xyz, OverlayColor.xyz, vec3(OverlayColor.w));
#ifdef LIT__OFF
    var_4898e = vec4(var_e9539.x, var_e9539.y, var_e9539.z, var_4898e.w);
#endif
#ifdef LIT__ON
    var_4898e = vec4(var_e9539.x, var_e9539.y, var_e9539.z, var_4898e.w) * v_light;
#endif
    if (AlphaMaskedTint.x != 0.0)
    {
        highp vec3 var_a1ec2 = (CurrentColor.xyz * mix(var_4898e.xyz, var_4898e.xyz * v_color.xyz, vec3(var_4898e.w))).xyz * var_4e612.w;
        var_4898e = vec4(var_a1ec2.x, var_a1ec2.y, var_a1ec2.z, var_4898e.w);
        var_4898e.w = 1.0;
    }
    else
    {
        var_4898e = (CurrentColor * v_color) * var_4898e;
    }
    var_4898e.w *= HudOpacity.x;
    highp vec4 var_88028 = v_fog;
    bgfx_FragColor = vec4(mix(var_4898e.xyz, v_fog.xyz, vec3(var_88028.w)), var_4898e.w);
}
