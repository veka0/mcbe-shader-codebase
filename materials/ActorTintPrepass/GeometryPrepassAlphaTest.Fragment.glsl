#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_PASS (not used)
* - DEPTH_ONLY_OPAQUE_PASS (not used)
* - GEOMETRY_PREPASS_PASS (not used)
* - GEOMETRY_PREPASS_ALPHA_TEST_PASS (not used)
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
* - uniform lowp sampler2D s_MERSTexture;
* - uniform lowp sampler2D s_MatTexture;
* - uniform lowp sampler2D s_MatTexture1;
* - uniform lowp sampler2D s_NormalTexture;
*
* Uniforms:
* - uniform vec4 ActorFPEpsilon;
* - uniform mat4 Bones[8];
* - uniform vec4 ChangeColor;
* - uniform vec4 ColorBased;
* - uniform vec4 DitherParams;
* - uniform vec4 DitherParams2[3];
* - uniform vec4 DitheringEnabledToggle;
* - uniform vec4 EmissiveUniform;
* - uniform vec4 FogColor;
* - uniform vec4 FogControl;
* - uniform vec4 HudOpacity;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MatColor;
* - uniform vec4 MaterialID;
* - uniform vec4 MetalnessUniform;
* - uniform vec4 MultiplicativeTintColor;
* - uniform vec4 OverlayColor;
* - uniform vec4 PBRTextureFlags;
* - uniform mat4 PrevBones[8];
* - uniform mat4 PrevWorld;
* - uniform vec4 RoughnessUniform;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 SubsurfaceUniform;
* - uniform vec4 TileLightColor;
* - uniform vec4 TileLightIntensity;
* - uniform vec4 TintedAlphaTestEnabled;
* - uniform vec4 UVAnimation;
* - uniform vec4 UseAlphaRewrite;
* - uniform vec4 ViewPositionAndTime;
*/

precision mediump float;
precision highp int;
uniform highp mat4 u_invView;
uniform highp mat4 u_prevViewProj;
uniform highp mat4 u_view;
uniform highp mat4 u_viewProj;
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
uniform highp vec4 TileLightIntensity;
uniform highp vec4 u_prevWorldPosOffset;
in highp vec4 v_clipPosition;
in highp vec4 v_color0;
in highp vec3 v_normal;
in highp vec3 v_prevWorldPos;
centroid in highp vec2 v_texcoord0;
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragData[gl_MaxDrawBuffers];
void func_9b13f(inout highp float arg_6097c) {
    if (false)
    {
        arg_6097c = 0.501960813999176025390625;
        return;
    }
    else
    {
        arg_6097c = 0.4980392158031463623046875;
        return;
    }
}
void main() {
    highp mat4 View = u_view;
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
    highp vec3 var_9d0de = mix(var_db6c1.xyz, var_4f2f0.xyz, vec3(var_666d2.w));
    highp vec4 var_178f6 = vec4(var_9d0de.x, var_9d0de.y, var_9d0de.z, var_db6c1.w);
    highp vec2 var_77469 = DitherParams2[0].xy;
    bool var_e71ae;
    if (DitheringEnabledToggle.x != 0.0)
    {
        highp vec4 var_d36cf = v_clipPosition;
        highp vec2 var_886c2 = floor(((((v_clipPosition.xyz / vec3(var_d36cf.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[0].z)) * DitherParams2[0].z;
        highp vec2 var_c27b1 = floor(var_886c2 * 0.25);
        highp vec2 var_a5f3b = floor(var_886c2 * 0.5);
        highp vec2 var_ccfe4 = floor(var_886c2);
        var_e71ae = smoothstep(var_77469.x, var_77469.y, dot(-normalize(vec3(View[0].z, View[1].z, View[2].z)), v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz)) <= (((((((fract((var_c27b1.x * 0.5) + ((var_c27b1.y * var_c27b1.y) * 0.75)) * 0.25) + fract((var_a5f3b.x * 0.5) + ((var_a5f3b.y * var_a5f3b.y) * 0.75))) * 0.25) + fract((var_ccfe4.x * 0.5) + ((var_ccfe4.y * var_ccfe4.y) * 0.75))) * 64.0) + 0.5) * 0.015625);
    }
    else
    {
        var_e71ae = false;
    }
    bool var_ed89e;
    if (!var_e71ae)
    {
        var_ed89e = (var_178f6.w + var_a5a49) < ActorFPEpsilon.x;
    }
    else
    {
        var_ed89e = var_e71ae;
    }
    if (var_ed89e)
    {
        discard;
    }
    highp vec3 var_f710c = mix((var_9d0de.xyz * mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x))).xyz, OverlayColor.xyz, vec3(OverlayColor.w));
    highp vec4 var_89833 = vec4(var_f710c.x, var_f710c.y, var_f710c.z, var_db6c1.w);
    highp vec4 var_39c01 = vec4(var_f710c, var_89833.w);
    highp vec4 var_6de71 = vec4(var_39c01.x, var_39c01.y, var_39c01.z, var_39c01.w);
    highp float var_1d2b2;
    func_9b13f(var_1d2b2);
    var_6de71.w = var_1d2b2;
    highp vec3 var_8c816 = normalize(v_normal);
    highp vec3 var_cd914 = var_8c816;
    highp vec2 var_645ff = var_8c816.xy * (1.0 / ((abs(var_cd914.x) + abs(var_cd914.y)) + abs(var_cd914.z)));
    highp vec2 var_5a694;
    if (var_cd914.z < 0.0)
    {
        var_5a694 = (vec2(1.0) - abs(var_645ff.yx)) * ((step(vec2(0.0), var_645ff) * 2.0) - vec2(1.0));
    }
    else
    {
        var_5a694 = var_645ff;
    }
    highp vec4 var_5dd1c = u_viewProj * vec4(v_worldPos, 1.0);
    highp vec4 var_46c40 = var_5dd1c;
    highp float var_bc97b = var_46c40.w;
    highp vec4 var_7ed87 = ((var_5dd1c / vec4(var_bc97b)) * 0.5) + vec4(0.5);
    var_46c40 = var_7ed87;
    highp vec4 var_21b68 = u_prevViewProj * vec4(v_prevWorldPos - u_prevWorldPosOffset.xyz, 1.0);
    highp vec4 var_96bda = var_21b68;
    highp float var_9ef48 = var_96bda.w;
    highp vec4 var_82203 = ((var_21b68 / vec4(var_9ef48)) * 0.5) + vec4(0.5);
    var_96bda = var_82203;
    highp vec2 var_ec5a5 = var_7ed87.xy - var_82203.xy;
    bgfx_FragData[0] = var_6de71;
    bgfx_FragData[1] = vec4(var_5a694.x, var_5a694.y, var_ec5a5.x, var_ec5a5.y);
    bgfx_FragData[2] = vec4(0.0, TileLightIntensity.x, TileLightIntensity.y, 0.5);
}
