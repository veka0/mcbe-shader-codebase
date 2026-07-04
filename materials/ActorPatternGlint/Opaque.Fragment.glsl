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
* - CHANGE_COLOR__MULTI (not used)
* - CHANGE_COLOR__OFF (not used)
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
* - MASKED_MULTITEXTURE__OFF (not used)
* - MASKED_MULTITEXTURE__ON (not used)
*
* Tinting:
* - TINTING__DISABLED
* - TINTING__ENABLED
*
* UIEntity:
* - UI_ENTITY__DISABLED
* - UI_ENTITY__ENABLED
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
* - uniform vec4 MaterialID;
* - uniform vec4 MultiplicativeTintColor;
* - uniform vec4 OverlayColor;
* - uniform vec4 PatternColors[7];
* - uniform vec4 PatternCount;
* - uniform vec4 PatternUVOffsetsAndScales[7];
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
uniform highp sampler2D s_MatTexture1;
#ifdef TINTING__ENABLED
uniform highp sampler2D s_MatTexture2;
#endif
uniform highp sampler2D s_MatTexture;
uniform highp vec4 GlintColor;
uniform highp vec4 HudOpacity;
#ifdef TINTING__ENABLED
uniform highp vec4 PatternColors[7];
uniform highp vec4 PatternCount;
uniform highp vec4 PatternUVOffsetsAndScales[7];
#endif
uniform highp vec4 TileLightColor;
in highp vec4 v_fog;
in highp vec4 v_layerUv;
#ifdef UI_ENTITY__DISABLED
in highp vec4 v_light;
#endif
centroid in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_18e94 = texture(s_MatTexture, v_texcoord0);
#if defined(TINTING__DISABLED) && defined(UI_ENTITY__DISABLED)
    highp vec3 var_136fb = var_18e94.xyz * v_light.xyz;
    highp vec4 var_c05da = vec4(var_136fb.x, var_136fb.y, var_136fb.z, var_18e94.w);
#endif
#if defined(TINTING__ENABLED) || defined(UI_ENTITY__ENABLED)
    highp vec4 var_c05da = var_18e94;
#endif
#ifdef TINTING__ENABLED
    highp vec4 var_48ffd = var_18e94;
    for (int var_f2336 = 0; var_f2336 < int(PatternCount.x); var_f2336++)
    {
        highp vec4 var_96930 = texture(s_MatTexture2, (PatternUVOffsetsAndScales[var_f2336].zw * v_texcoord0) + PatternUVOffsetsAndScales[var_f2336].xy) * PatternColors[var_f2336];
        highp vec4 var_df244 = var_96930;
        var_48ffd = mix(var_48ffd, var_96930, vec4(var_df244.w));
    }
    var_48ffd.w = 1.0;
#endif
#if defined(TINTING__ENABLED) && defined(UI_ENTITY__DISABLED)
    highp vec3 var_136fb = var_48ffd.xyz * v_light.xyz;
    var_c05da = vec4(var_136fb.x, var_136fb.y, var_136fb.z, var_48ffd.w);
#endif
#if defined(TINTING__ENABLED) && defined(UI_ENTITY__ENABLED)
    var_c05da = var_48ffd;
#endif
    highp float var_d8f56 = var_c05da.w;
    highp vec4 var_6d4aa = (GlintColor * (texture(s_MatTexture1, fract(v_layerUv.xy)).xyzx + texture(s_MatTexture1, fract(v_layerUv.zw)).xyzx)) * TileLightColor;
#ifdef UI_ENTITY__DISABLED
    highp vec4 var_98c44 = vec4(var_6d4aa.xyz * var_6d4aa.xyz, abs(var_6d4aa.w)) + vec4(var_136fb, 0.0);
#endif
#if defined(TINTING__DISABLED) && defined(UI_ENTITY__ENABLED)
    highp vec4 var_98c44 = vec4(var_6d4aa.xyz * var_6d4aa.xyz, abs(var_6d4aa.w)) + vec4(var_18e94.xyz, 0.0);
#endif
#if defined(TINTING__ENABLED) && defined(UI_ENTITY__ENABLED)
    highp vec4 var_98c44 = vec4(var_6d4aa.xyz * var_6d4aa.xyz, abs(var_6d4aa.w)) + vec4(var_48ffd.xyz, 0.0);
#endif
#ifdef TINTING__DISABLED
    var_98c44.w = var_18e94.w;
#endif
#ifdef TINTING__ENABLED
    var_98c44.w = var_48ffd.w;
#endif
    var_c05da = var_98c44;
    var_c05da.w = var_d8f56;
    highp vec4 var_ea6de = var_c05da;
    var_ea6de.w *= HudOpacity.x;
    var_c05da = var_ea6de;
    highp vec4 var_8544b = v_fog;
    bgfx_FragColor = vec4(mix(vec4(var_ea6de.xyz, var_c05da.w).xyz, v_fog.xyz, vec3(var_8544b.w)), var_c05da.w);
}
