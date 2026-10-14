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
* ColorSecondTexture:
* - COLOR_SECOND_TEXTURE__OFF
* - COLOR_SECOND_TEXTURE__ON
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
* - uniform lowp sampler2D s_MatTexture2;
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
uniform highp sampler2D s_MatTexture2;
uniform highp sampler2D s_MatTexture;
uniform highp vec4 ActorFPEpsilon;
#if defined(COLOR_SECOND_TEXTURE__ON) || !defined(CHANGE_COLOR__OFF)
uniform highp vec4 ChangeColor;
#endif
uniform highp vec4 ColorBased;
uniform highp vec4 DitherParams2[3];
uniform highp vec4 DitherParams;
uniform highp vec4 DitheringEnabledToggle;
uniform highp vec4 MatColor;
#ifdef CHANGE_COLOR__MULTI
uniform highp vec4 MultiplicativeTintColor;
#endif
uniform highp vec4 OverlayColor;
in highp vec4 v_clipPosition;
in highp vec4 v_color0;
in highp vec4 v_fog;
in highp vec4 v_light;
centroid in highp vec2 v_texcoord0;
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
#if defined(MASKED_MULTITEXTURE__OFF) && !defined(CHANGE_COLOR__OFF)
    highp vec4 var_663d1 = MatColor * texture(s_MatTexture, v_texcoord0);
#endif
#if defined(CHANGE_COLOR__OFF) && defined(MASKED_MULTITEXTURE__OFF)
    highp vec4 var_0e2bc = MatColor * texture(s_MatTexture, v_texcoord0);
#endif
#ifdef MASKED_MULTITEXTURE__ON
    highp vec4 var_7fef3 = texture(s_MatTexture1, v_texcoord0);
    highp vec4 var_0b7d3 = var_7fef3;
#endif
#if defined(CHANGE_COLOR__MULTI) && defined(MASKED_MULTITEXTURE__OFF)
    highp vec4 var_3096f = var_663d1;
#endif
#if defined(CHANGE_COLOR__ON) && defined(MASKED_MULTITEXTURE__OFF)
    highp vec4 var_0e2bc = var_663d1;
#endif
#if defined(MASKED_MULTITEXTURE__ON) && !defined(CHANGE_COLOR__OFF)
    highp vec4 var_663d1 = mix(var_7fef3, MatColor * texture(s_MatTexture, v_texcoord0), vec4(float((((var_0b7d3.x + var_0b7d3.y) + var_0b7d3.z) * (1.0 - var_0b7d3.w)) > 0.0)));
#endif
#if defined(CHANGE_COLOR__OFF) && defined(MASKED_MULTITEXTURE__ON)
    highp vec4 var_0e2bc = mix(var_7fef3, MatColor * texture(s_MatTexture, v_texcoord0), vec4(float((((var_0b7d3.x + var_0b7d3.y) + var_0b7d3.z) * (1.0 - var_0b7d3.w)) > 0.0)));
#endif
#if defined(CHANGE_COLOR__MULTI) && defined(MASKED_MULTITEXTURE__ON)
    highp vec4 var_3096f = var_663d1;
#endif
#if defined(CHANGE_COLOR__ON) && defined(MASKED_MULTITEXTURE__ON)
    highp vec4 var_0e2bc = var_663d1;
#endif
#ifdef CHANGE_COLOR__MULTI
    highp vec2 var_e1236 = var_663d1.xy;
    highp vec3 var_728f2 = var_663d1.xxx * ChangeColor.xyz;
#endif
#ifdef CHANGE_COLOR__ON
    highp vec4 var_8a135 = ChangeColor;
    highp float var_e3254 = var_0e2bc.w;
    highp vec3 var_618b0 = mix(var_663d1.xyz, var_663d1.xyz * ChangeColor.xyz, vec3(var_e3254));
#endif
#ifdef CHANGE_COLOR__MULTI
    var_3096f.x = var_728f2.x;
#endif
#ifdef CHANGE_COLOR__ON
    var_0e2bc.x = var_618b0.x;
#endif
#ifdef CHANGE_COLOR__MULTI
    var_3096f.y = var_728f2.y;
#endif
#ifdef CHANGE_COLOR__ON
    var_0e2bc.y = var_618b0.y;
    var_0e2bc.z = var_618b0.z;
#endif
#ifdef CHANGE_COLOR__MULTI
    var_3096f.z = var_728f2.z;
    highp vec4 var_60355 = var_3096f;
    highp vec3 var_ef570 = mix(var_60355.xyz, var_663d1.yyy * MultiplicativeTintColor.xyz, vec3(ceil(var_e1236.y)));
    var_3096f.x = var_ef570.x;
    var_3096f.y = var_ef570.y;
    var_3096f.z = var_ef570.z;
    highp vec4 var_0e2bc = var_3096f;
#endif
#ifdef CHANGE_COLOR__ON
    var_0e2bc.w *= var_8a135.w;
#endif
    var_0e2bc.w = max(0.0, var_0e2bc.w);
    highp vec4 var_7af8f = var_0e2bc;
    highp vec4 var_8ed44 = texture(s_MatTexture1, v_texcoord0);
    highp vec4 var_c4ba9 = var_8ed44;
    highp vec3 var_fcdef = mix(var_0e2bc.xyz, var_8ed44.xyz, vec3(var_c4ba9.w));
    var_7af8f.x = var_fcdef.x;
    var_7af8f.y = var_fcdef.y;
    var_7af8f.z = var_fcdef.z;
    highp vec4 var_3ec47 = var_7af8f;
    highp vec4 var_a92f4 = texture(s_MatTexture2, v_texcoord0);
    highp vec4 var_08839 = var_a92f4;
#ifdef COLOR_SECOND_TEXTURE__OFF
    highp vec3 var_8c675 = mix(var_7af8f.xyz, var_a92f4.xyz, vec3(var_08839.w));
    var_3ec47.x = var_8c675.x;
    var_3ec47.y = var_8c675.y;
    var_3ec47.z = var_8c675.z;
#endif
#ifdef COLOR_SECOND_TEXTURE__ON
    if (var_08839.w > ActorFPEpsilon.x)
    {
        highp vec3 var_e3a21 = mix(var_a92f4.xyz, var_a92f4.xyz * ChangeColor.xyz, vec3(var_08839.w));
        var_3ec47.x = var_e3a21.x;
        var_3ec47.y = var_e3a21.y;
        var_3ec47.z = var_e3a21.z;
    }
#endif
    var_7af8f = var_3ec47;
    highp vec4 var_bf684 = var_3ec47;
    highp vec3 var_6f9dd = var_3ec47.xyz * mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x));
    var_bf684.x = var_6f9dd.x;
    var_bf684.y = var_6f9dd.y;
    var_bf684.z = var_6f9dd.z;
    highp vec4 var_a42ab = var_bf684;
    highp vec3 var_2a9cf = mix(var_bf684.xyz, OverlayColor.xyz, vec3(OverlayColor.w));
    var_a42ab.x = var_2a9cf.x;
    var_a42ab.y = var_2a9cf.y;
    var_a42ab.z = var_2a9cf.z;
    highp vec4 var_dfd17 = var_a42ab;
    highp vec3 var_279b1 = var_a42ab.xyz * v_light.xyz;
    var_dfd17.x = var_279b1.x;
    var_dfd17.y = var_279b1.y;
    var_dfd17.z = var_279b1.z;
    var_bf684 = var_dfd17;
    highp vec4 var_b136c = var_dfd17;
    highp vec2 var_7c9c5 = DitherParams2[0].xy;
    bool var_9e7dd;
    if (DitheringEnabledToggle.x != 0.0)
    {
        highp mat4 var_4971e = u_view;
        highp vec2 var_2c6b3 = floor(((((v_clipPosition.xyz / vec3(v_clipPosition.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[0].z)) * DitherParams2[0].z;
        highp vec2 var_f4989 = floor(var_2c6b3 * 0.25);
        highp vec2 var_85686 = floor(var_2c6b3 * 0.5);
        highp vec2 var_09c49 = floor(var_2c6b3);
        var_9e7dd = smoothstep(var_7c9c5.x, var_7c9c5.y, dot(-normalize(vec4(var_4971e[0].z, var_4971e[1].z, var_4971e[2].z, var_33fae).xyz), v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz)) <= (((((((fract((var_f4989.x * 0.5) + ((var_f4989.y * var_f4989.y) * 0.75)) * 0.25) + fract((var_85686.x * 0.5) + ((var_85686.y * var_85686.y) * 0.75))) * 0.25) + fract((var_09c49.x * 0.5) + ((var_09c49.y * var_09c49.y) * 0.75))) * 64.0) + 0.5) * 0.015625);
    }
    else
    {
        var_9e7dd = false;
    }
    bool var_7df86;
    if (!var_9e7dd)
    {
        bool var_80f22 = var_b136c.w < 0.5;
        bool var_f1731;
        if (var_80f22)
        {
            var_f1731 = var_c4ba9.w < ActorFPEpsilon.x;
        }
        else
        {
            var_f1731 = var_80f22;
        }
        var_7df86 = var_f1731;
    }
    else
    {
        var_7df86 = var_9e7dd;
    }
    if (var_7df86)
    {
        discard;
    }
    highp vec4 var_4b012 = vec4(var_dfd17.xyz, var_b136c.w);
    highp vec4 var_72c1b = var_4b012;
    highp vec3 var_c6e56 = mix(var_4b012.xyz, v_fog.xyz, vec3(v_fog.w));
    var_72c1b.x = var_c6e56.x;
    var_72c1b.y = var_c6e56.y;
    var_72c1b.z = var_c6e56.z;
    bgfx_FragData0 = var_72c1b;
}
