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
float var_238cd;
uniform highp mat4 u_invView;
uniform highp mat4 u_view;
uniform highp sampler2D s_MatTexture1;
#ifdef TINTING__ENABLED
uniform highp sampler2D s_MatTexture2;
#endif
uniform highp sampler2D s_MatTexture;
uniform highp vec4 ActorFPEpsilon;
uniform highp vec4 DitherParams2[3];
uniform highp vec4 DitherParams;
uniform highp vec4 DitheringEnabledToggle;
uniform highp vec4 GlintColor;
uniform highp vec4 HudOpacity;
#ifdef TINTING__ENABLED
uniform highp vec4 PatternColors[7];
uniform highp vec4 PatternCount;
uniform highp vec4 PatternUVOffsetsAndScales[7];
#endif
uniform highp vec4 TileLightColor;
in highp vec4 v_clipPosition;
in highp vec4 v_fog;
in highp vec4 v_layerUv;
#ifdef UI_ENTITY__DISABLED
in highp vec4 v_light;
#endif
centroid in highp vec2 v_texcoord0;
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec4 var_610e6 = texture(s_MatTexture, v_texcoord0);
    bool var_711f5 = var_610e6.w < ActorFPEpsilon.x;
    bool var_7df86;
    if (!var_711f5)
    {
        highp vec2 var_4be3d = DitherParams2[0].xy;
        bool var_63892;
        if (DitheringEnabledToggle.x != 0.0)
        {
            highp mat4 var_24edd = u_view;
            highp vec4 var_3267d = v_clipPosition;
            highp vec2 var_f4f10 = floor(((((v_clipPosition.xyz / vec3(var_3267d.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[0].z)) * DitherParams2[0].z;
            highp vec2 var_c55b8 = floor(var_f4f10 * 0.25);
            highp vec2 var_63b62 = floor(var_f4f10 * 0.5);
            highp vec2 var_5fe78 = floor(var_f4f10);
            var_63892 = smoothstep(var_4be3d.x, var_4be3d.y, dot(-normalize(vec4(var_24edd[0].z, var_24edd[1].z, var_24edd[2].z, var_238cd).xyz), v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz)) <= (((((((fract((var_c55b8.x * 0.5) + ((var_c55b8.y * var_c55b8.y) * 0.75)) * 0.25) + fract((var_63b62.x * 0.5) + ((var_63b62.y * var_63b62.y) * 0.75))) * 0.25) + fract((var_5fe78.x * 0.5) + ((var_5fe78.y * var_5fe78.y) * 0.75))) * 64.0) + 0.5) * 0.015625);
        }
        else
        {
            var_63892 = false;
        }
        var_7df86 = var_63892;
    }
    else
    {
        var_7df86 = var_711f5;
    }
    if (var_7df86)
    {
        discard;
    }
#if defined(TINTING__ENABLED) || defined(UI_ENTITY__DISABLED)
    highp vec4 var_48ffd = var_610e6;
#endif
#ifdef TINTING__ENABLED
    for (int var_f2336 = 0; var_f2336 < int(PatternCount.x); var_f2336++)
    {
        highp vec4 var_96930 = texture(s_MatTexture2, (PatternUVOffsetsAndScales[var_f2336].zw * v_texcoord0) + PatternUVOffsetsAndScales[var_f2336].xy) * PatternColors[var_f2336];
        highp vec4 var_df244 = var_96930;
        var_48ffd = mix(var_48ffd, var_96930, vec4(var_df244.w));
    }
    var_48ffd.w = 1.0;
#endif
#ifdef UI_ENTITY__DISABLED
    highp vec3 var_90012 = var_48ffd.xyz * v_light.xyz;
    var_610e6 = vec4(var_90012.x, var_90012.y, var_90012.z, var_48ffd.w);
#endif
#if defined(TINTING__ENABLED) && defined(UI_ENTITY__ENABLED)
    var_610e6 = var_48ffd;
#endif
    highp float var_d8f56 = var_610e6.w;
    highp vec4 var_6d4aa = (GlintColor * (texture(s_MatTexture1, fract(v_layerUv.xy)).xyzx + texture(s_MatTexture1, fract(v_layerUv.zw)).xyzx)) * TileLightColor;
#ifdef UI_ENTITY__DISABLED
    highp vec4 var_98c44 = vec4(var_6d4aa.xyz * var_6d4aa.xyz, abs(var_6d4aa.w)) + vec4(var_90012, 0.0);
#endif
#if defined(TINTING__ENABLED) && defined(UI_ENTITY__ENABLED)
    highp vec4 var_98c44 = vec4(var_6d4aa.xyz * var_6d4aa.xyz, abs(var_6d4aa.w)) + vec4(var_48ffd.xyz, 0.0);
#endif
#if defined(TINTING__DISABLED) && defined(UI_ENTITY__ENABLED)
    highp vec4 var_98c44 = vec4(var_6d4aa.xyz * var_6d4aa.xyz, abs(var_6d4aa.w)) + vec4(var_610e6.xyz, 0.0);
#endif
#if defined(TINTING__ENABLED) || defined(UI_ENTITY__DISABLED)
    var_98c44.w = var_48ffd.w;
#endif
#if defined(TINTING__DISABLED) && defined(UI_ENTITY__ENABLED)
    var_98c44.w = var_610e6.w;
#endif
    var_610e6 = var_98c44;
    var_610e6.w = var_d8f56;
    highp vec4 var_7c1e7 = var_610e6;
    var_7c1e7.w *= HudOpacity.x;
    var_610e6 = var_7c1e7;
    highp vec4 var_f6e07 = v_fog;
    bgfx_FragData0 = vec4(mix(vec4(var_7c1e7.xyz, var_610e6.w).xyz, v_fog.xyz, vec3(var_f6e07.w)), var_610e6.w);
}
