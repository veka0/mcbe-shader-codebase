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
* - CHANGE_COLOR__MULTI (not used)
* - CHANGE_COLOR__OFF
* - CHANGE_COLOR__ON (not used)
*
* Emissive:
* - EMISSIVE__EMISSIVE
* - EMISSIVE__EMISSIVE_ONLY
* - EMISSIVE__OFF
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
#ifdef MASKED_MULTITEXTURE__ON
uniform highp sampler2D s_MatTexture1;
#endif
uniform highp sampler2D s_MatTexture;
#if !defined(CHANGE_COLOR__OFF) || !defined(EMISSIVE__OFF)
uniform highp vec4 ActorFPEpsilon;
#endif
uniform highp vec4 MatColor;
uniform highp vec4 OverlayColor;
uniform highp vec4 TintedAlphaTestEnabled;
centroid in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData[gl_MaxDrawBuffers];
void main() {
#ifdef MASKED_MULTITEXTURE__OFF
    highp vec4 var_a1e09 = MatColor * texture(s_MatTexture, v_texcoord0);
#endif
#ifdef MASKED_MULTITEXTURE__ON
    highp vec4 var_ade26 = texture(s_MatTexture1, v_texcoord0);
#endif
#if defined(EMISSIVE__EMISSIVE) && defined(MASKED_MULTITEXTURE__OFF)
    highp vec4 var_74106 = var_a1e09;
#endif
#ifdef MASKED_MULTITEXTURE__ON
    highp vec4 var_76534 = var_ade26;
    highp vec4 var_a1e09 = mix(var_ade26, MatColor * texture(s_MatTexture, v_texcoord0), vec4(float((((var_76534.x + var_76534.y) + var_76534.z) * (1.0 - var_76534.w)) > 0.0)));
#endif
#if defined(EMISSIVE__EMISSIVE) && defined(MASKED_MULTITEXTURE__ON)
    highp vec4 var_74106 = var_a1e09;
#endif
#ifdef EMISSIVE__EMISSIVE
    if (false || (dot(vec4(var_a1e09.xyz, mix(var_74106.w, var_74106.w * OverlayColor.w, TintedAlphaTestEnabled.x)), vec4(1.0)) < ActorFPEpsilon.x))
#endif
#ifdef EMISSIVE__EMISSIVE_ONLY
    highp float var_a8620 = mix(var_a1e09.w, var_a1e09.w * OverlayColor.w, TintedAlphaTestEnabled.x);
    bool var_e7bf9 = var_a8620 < ActorFPEpsilon.x;
    bool var_19a24;
    if (!var_e7bf9)
#endif
#if defined(EMISSIVE__OFF) && !defined(CHANGE_COLOR__OFF)
    if (false || (mix(var_a1e09.w, var_a1e09.w * OverlayColor.w, TintedAlphaTestEnabled.x) < ActorFPEpsilon.x))
#endif
#if defined(CHANGE_COLOR__OFF) && defined(EMISSIVE__OFF)
    if (false || (mix(var_a1e09.w, var_a1e09.w * OverlayColor.w, TintedAlphaTestEnabled.x) < 0.5))
#endif
    {
#ifdef EMISSIVE__EMISSIVE_ONLY
        var_19a24 = var_a8620 > (1.0 - ActorFPEpsilon.x);
    }
    else
    {
        var_19a24 = var_e7bf9;
    }
    if (false || var_19a24)
    {
#endif
        discard;
    }
    bgfx_FragData[0] = vec4(1.0);
    bgfx_FragData[1] = vec4(0.0);
    bgfx_FragData[2] = vec4(0.0);
}
