#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - DEPTH_ONLY_PASS (not used)
* - DEPTH_ONLY_OPAQUE_PASS (not used)
* - OPAQUE_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* Change_Color:
* - CHANGE_COLOR__MULTI
* - CHANGE_COLOR__OFF
* - CHANGE_COLOR__ON
*
* Emissive:
* - EMISSIVE__OFF (not used)
*
* Fancy:
* - FANCY__OFF (not used)
* - FANCY__ON (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* MaskedMultitexture:
* - MASKED_MULTITEXTURE__OFF
* - MASKED_MULTITEXTURE__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MatTexture;
* - uniform lowp sampler2D s_MatTexture1;
*
* Uniforms:
* - uniform vec4 ActorFPEpsilon;
* - uniform vec4 BlockLightColor;
* - uniform mat4 Bones[8];
* - uniform vec4 ChangeColor;
* - uniform vec4 ColorBased;
* - uniform vec4 DitherParams;
* - uniform vec4 DitherParams2[3];
* - uniform vec4 DitheringEnabledToggle;
* - uniform vec4 FogColor;
* - uniform vec4 FogControl;
* - uniform vec4 HudOpacity;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MatColor;
* - uniform vec4 MaterialID;
* - uniform vec4 MultiplicativeTintColor;
* - uniform vec4 OverlayColor;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 TileLightColor;
* - uniform vec4 TileLightIntensity;
* - uniform vec4 TintedAlphaTestEnabled;
* - uniform vec4 UVAnimation;
* - uniform vec4 UseAlphaRewrite;
*/

precision mediump float;
precision highp int;
float var_33fae;
uniform highp mat4 u_invView;
uniform highp mat4 u_view;
uniform highp sampler2D s_MatTexture1;
uniform highp sampler2D s_MatTexture;
uniform highp vec4 ActorFPEpsilon;
#ifndef CHANGE_COLOR__OFF
uniform highp vec4 ChangeColor;
#endif
uniform highp vec4 ColorBased;
uniform highp vec4 DitherParams2[3];
uniform highp vec4 DitherParams;
uniform highp vec4 DitheringEnabledToggle;
uniform highp vec4 MatColor;
uniform highp vec4 MultiplicativeTintColor;
uniform highp vec4 OverlayColor;
in highp vec4 v_clipPosition;
in highp vec4 v_color0;
in highp vec4 v_fog;
in highp vec4 v_light;
centroid in highp vec2 v_texcoord0;
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
#if defined(MASKED_MULTITEXTURE__OFF) && !defined(CHANGE_COLOR__OFF)
    highp vec4 var_98b25 = MatColor * texture(s_MatTexture, v_texcoord0);
#endif
#if defined(CHANGE_COLOR__OFF) && defined(MASKED_MULTITEXTURE__OFF)
    highp vec4 var_db6c1 = MatColor * texture(s_MatTexture, v_texcoord0);
#endif
#ifdef MASKED_MULTITEXTURE__ON
    highp vec4 var_7fef3 = texture(s_MatTexture1, v_texcoord0);
    highp vec4 var_0b7d3 = var_7fef3;
#endif
#if defined(CHANGE_COLOR__ON) && defined(MASKED_MULTITEXTURE__OFF)
    highp vec4 var_db6c1 = var_98b25;
#endif
#if defined(MASKED_MULTITEXTURE__ON) && !defined(CHANGE_COLOR__OFF)
    highp vec4 var_98b25 = mix(var_7fef3, MatColor * texture(s_MatTexture, v_texcoord0), vec4(float((((var_0b7d3.x + var_0b7d3.y) + var_0b7d3.z) * (1.0 - var_0b7d3.w)) > 0.0)));
#endif
#if defined(CHANGE_COLOR__OFF) && defined(MASKED_MULTITEXTURE__ON)
    highp vec4 var_db6c1 = mix(var_7fef3, MatColor * texture(s_MatTexture, v_texcoord0), vec4(float((((var_0b7d3.x + var_0b7d3.y) + var_0b7d3.z) * (1.0 - var_0b7d3.w)) > 0.0)));
#endif
#ifdef CHANGE_COLOR__MULTI
    highp vec2 var_459de = var_98b25.xy;
    highp vec3 var_1099e = mix((var_98b25.xxx * ChangeColor.xyz).xyz, var_98b25.yyy * MultiplicativeTintColor.xyz, vec3(ceil(var_459de.y)));
    highp vec4 var_db6c1 = vec4(var_1099e.x, var_1099e.y, var_1099e.z, var_98b25.w);
#endif
#if defined(CHANGE_COLOR__ON) && defined(MASKED_MULTITEXTURE__ON)
    highp vec4 var_db6c1 = var_98b25;
#endif
#ifdef CHANGE_COLOR__ON
    highp vec4 var_8a135 = ChangeColor;
    highp vec3 var_fba6e = mix(var_98b25.xyz, var_98b25.xyz * ChangeColor.xyz, vec3(var_db6c1.w));
    var_db6c1 = vec4(var_fba6e.x, var_fba6e.y, var_fba6e.z, var_98b25.w);
    var_db6c1.w *= var_8a135.w;
#endif
    var_db6c1.w = max(0.0, var_db6c1.w);
    highp vec4 var_b3af7 = texture(s_MatTexture1, v_texcoord0);
    highp vec4 var_666d2 = var_b3af7;
    highp float var_a5a49 = var_666d2.w;
    highp vec3 var_4f2f0 = var_b3af7.xyz * MultiplicativeTintColor.xyz;
    var_666d2 = vec4(var_4f2f0.x, var_4f2f0.y, var_4f2f0.z, var_b3af7.w);
    highp vec3 var_23ff5 = mix(var_db6c1.xyz, var_4f2f0.xyz, vec3(var_666d2.w));
    highp vec4 var_178f6 = vec4(var_23ff5.x, var_23ff5.y, var_23ff5.z, var_db6c1.w);
    highp vec2 var_7c9c5 = DitherParams2[0].xy;
    bool var_9e7dd;
    if (DitheringEnabledToggle.x != 0.0)
    {
        highp mat4 var_4971e = u_view;
        highp vec4 var_d36cf = v_clipPosition;
        highp vec2 var_886c2 = floor(((((v_clipPosition.xyz / vec3(var_d36cf.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[0].z)) * DitherParams2[0].z;
        highp vec2 var_f4989 = floor(var_886c2 * 0.25);
        highp vec2 var_85686 = floor(var_886c2 * 0.5);
        highp vec2 var_09c49 = floor(var_886c2);
        var_9e7dd = smoothstep(var_7c9c5.x, var_7c9c5.y, dot(-normalize(vec4(var_4971e[0].z, var_4971e[1].z, var_4971e[2].z, var_33fae).xyz), v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz)) <= (((((((fract((var_f4989.x * 0.5) + ((var_f4989.y * var_f4989.y) * 0.75)) * 0.25) + fract((var_85686.x * 0.5) + ((var_85686.y * var_85686.y) * 0.75))) * 0.25) + fract((var_09c49.x * 0.5) + ((var_09c49.y * var_09c49.y) * 0.75))) * 64.0) + 0.5) * 0.015625);
    }
    else
    {
        var_9e7dd = false;
    }
    bool var_ed89e;
    if (!var_9e7dd)
    {
        var_ed89e = (var_178f6.w + var_a5a49) < ActorFPEpsilon.x;
    }
    else
    {
        var_ed89e = var_9e7dd;
    }
    if (var_ed89e)
    {
        discard;
    }
    highp vec3 var_657e2 = mix((var_23ff5.xyz * mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x))).xyz, OverlayColor.xyz, vec3(OverlayColor.w)).xyz * v_light.xyz;
    highp vec4 var_74ef0 = vec4(var_657e2.x, var_657e2.y, var_657e2.z, var_db6c1.w);
    highp vec4 var_dc02c = v_fog;
    bgfx_FragColor = vec4(mix(vec4(var_657e2, var_74ef0.w).xyz, v_fog.xyz, vec3(var_dc02c.w)), var_74ef0.w);
}
