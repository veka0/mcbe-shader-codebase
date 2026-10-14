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
* - uniform vec4 GlintColor;
* - uniform vec4 HudOpacity;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MatColor;
* - uniform vec4 MultiplicativeTintColor;
* - uniform vec4 OverlayColor;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 TileLightColor;
* - uniform vec4 TileLightIntensity;
* - uniform vec4 TintedAlphaTestEnabled;
* - uniform vec4 UVAnimation;
* - uniform vec4 UVScale;
* - uniform vec4 UseAlphaRewrite;
*/

precision mediump float;
precision highp int;
float var_33fae;
uniform highp mat4 u_invView;
uniform highp mat4 u_view;
uniform highp sampler2D s_MatTexture1;
uniform highp sampler2D s_MatTexture;
#ifndef CHANGE_COLOR__OFF
uniform highp vec4 ActorFPEpsilon;
uniform highp vec4 ChangeColor;
#endif
uniform highp vec4 ColorBased;
uniform highp vec4 DitherParams2[3];
uniform highp vec4 DitherParams;
uniform highp vec4 DitheringEnabledToggle;
uniform highp vec4 GlintColor;
uniform highp vec4 MatColor;
#ifdef CHANGE_COLOR__MULTI
uniform highp vec4 MultiplicativeTintColor;
#endif
uniform highp vec4 OverlayColor;
uniform highp vec4 TileLightColor;
uniform highp vec4 UseAlphaRewrite;
in highp vec4 v_clipPosition;
in highp vec4 v_color0;
in highp vec4 v_fog;
in highp vec4 v_layerUv;
in highp vec4 v_light;
centroid in highp vec2 v_texcoord0;
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
#ifdef MASKED_MULTITEXTURE__OFF
    highp vec4 var_0f7f2 = MatColor * texture(s_MatTexture, v_texcoord0);
#endif
#ifdef MASKED_MULTITEXTURE__ON
    highp vec4 var_ade26 = texture(s_MatTexture1, v_texcoord0);
    highp vec4 var_76534 = var_ade26;
    highp vec4 var_0f7f2 = mix(var_ade26, MatColor * texture(s_MatTexture, v_texcoord0), vec4(float((((var_76534.x + var_76534.y) + var_76534.z) * (1.0 - var_76534.w)) > 0.0)));
#endif
    highp vec2 var_7c9c5 = DitherParams2[0].xy;
    bool var_fd5a0;
    if (DitheringEnabledToggle.x != 0.0)
    {
        highp mat4 var_4971e = u_view;
        highp vec2 var_2c6b3 = floor(((((v_clipPosition.xyz / vec3(v_clipPosition.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[0].z)) * DitherParams2[0].z;
        highp vec2 var_f4989 = floor(var_2c6b3 * 0.25);
        highp vec2 var_85686 = floor(var_2c6b3 * 0.5);
        highp vec2 var_09c49 = floor(var_2c6b3);
        var_fd5a0 = smoothstep(var_7c9c5.x, var_7c9c5.y, dot(-normalize(vec4(var_4971e[0].z, var_4971e[1].z, var_4971e[2].z, var_33fae).xyz), v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz)) <= (((((((fract((var_f4989.x * 0.5) + ((var_f4989.y * var_f4989.y) * 0.75)) * 0.25) + fract((var_85686.x * 0.5) + ((var_85686.y * var_85686.y) * 0.75))) * 0.25) + fract((var_09c49.x * 0.5) + ((var_09c49.y * var_09c49.y) * 0.75))) * 64.0) + 0.5) * 0.015625);
    }
    else
    {
        var_fd5a0 = false;
    }
#ifndef CHANGE_COLOR__OFF
    if (var_fd5a0 || (var_0f7f2.w < ActorFPEpsilon.x))
#endif
#ifdef CHANGE_COLOR__OFF
    if (var_fd5a0 || (var_0f7f2.w < 0.5))
#endif
    {
        discard;
    }
#ifndef CHANGE_COLOR__MULTI
    highp vec4 var_c65ea = var_0f7f2;
#endif
#ifdef CHANGE_COLOR__MULTI
    highp vec4 var_a6909 = var_0f7f2;
    highp vec2 var_e1236 = var_0f7f2.xy;
    highp vec3 var_728f2 = var_0f7f2.xxx * ChangeColor.xyz;
#endif
#ifdef CHANGE_COLOR__ON
    highp vec4 var_8a135 = ChangeColor;
    highp float var_e3254 = var_c65ea.w;
    highp vec3 var_618b0 = mix(var_0f7f2.xyz, var_0f7f2.xyz * ChangeColor.xyz, vec3(var_e3254));
#endif
#ifdef CHANGE_COLOR__MULTI
    var_a6909.x = var_728f2.x;
#endif
#ifdef CHANGE_COLOR__ON
    var_c65ea.x = var_618b0.x;
#endif
#ifdef CHANGE_COLOR__MULTI
    var_a6909.y = var_728f2.y;
#endif
#ifdef CHANGE_COLOR__ON
    var_c65ea.y = var_618b0.y;
    var_c65ea.z = var_618b0.z;
#endif
#ifdef CHANGE_COLOR__MULTI
    var_a6909.z = var_728f2.z;
    highp vec4 var_60355 = var_a6909;
    highp vec3 var_ef570 = mix(var_60355.xyz, var_0f7f2.yyy * MultiplicativeTintColor.xyz, vec3(ceil(var_e1236.y)));
    var_a6909.x = var_ef570.x;
    var_a6909.y = var_ef570.y;
    var_a6909.z = var_ef570.z;
    highp vec4 var_c65ea = var_a6909;
#endif
#ifdef CHANGE_COLOR__ON
    var_c65ea.w *= var_8a135.w;
#endif
    var_c65ea.w = max(UseAlphaRewrite.x, var_c65ea.w);
    var_0f7f2 = var_c65ea;
    highp vec4 var_bf684 = var_c65ea;
    highp vec3 var_6f9dd = var_c65ea.xyz * mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x));
    var_bf684.x = var_6f9dd.x;
    var_bf684.y = var_6f9dd.y;
    var_bf684.z = var_6f9dd.z;
    highp vec4 var_a42ab = var_bf684;
    highp vec3 var_2a9cf = mix(var_bf684.xyz, OverlayColor.xyz, vec3(OverlayColor.w));
    var_a42ab.x = var_2a9cf.x;
    var_a42ab.y = var_2a9cf.y;
    var_a42ab.z = var_2a9cf.z;
    highp vec4 var_60f01 = var_a42ab;
    highp vec3 var_279b1 = var_a42ab.xyz * v_light.xyz;
    var_60f01.x = var_279b1.x;
    var_60f01.y = var_279b1.y;
    var_60f01.z = var_279b1.z;
    var_bf684 = var_60f01;
    highp vec4 var_a2360 = (GlintColor * (texture(s_MatTexture1, fract(v_layerUv.xy)).xyzx + texture(s_MatTexture1, fract(v_layerUv.zw)).xyzx)) * TileLightColor;
    highp vec4 var_c8e6b = vec4(var_a2360.xyz * var_a2360.xyz, abs(var_a2360.w)) + vec4(var_60f01.xyz, 0.0);
    var_c8e6b.w = var_60f01.w;
    highp vec4 var_1d587 = var_c8e6b;
    highp vec4 var_4b012 = vec4(var_c8e6b.xyz, var_1d587.w);
    highp vec4 var_72c1b = var_4b012;
    highp vec3 var_c6e56 = mix(var_4b012.xyz, v_fog.xyz, vec3(v_fog.w));
    var_72c1b.x = var_c6e56.x;
    var_72c1b.y = var_c6e56.y;
    var_72c1b.z = var_c6e56.z;
    bgfx_FragData0 = var_72c1b;
}
