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
    highp vec4 var_99195 = texture(s_MatTexture, v_texcoord0);
    bool var_711f5 = var_99195.w < ActorFPEpsilon.x;
    bool var_7df86;
    if (!var_711f5)
    {
        highp vec2 var_4be3d = DitherParams2[0].xy;
        bool var_63892;
        if (DitheringEnabledToggle.x != 0.0)
        {
            highp mat4 var_24edd = u_view;
            highp vec2 var_52d56 = floor(((((v_clipPosition.xyz / vec3(v_clipPosition.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[0].z)) * DitherParams2[0].z;
            highp vec2 var_c55b8 = floor(var_52d56 * 0.25);
            highp vec2 var_63b62 = floor(var_52d56 * 0.5);
            highp vec2 var_5fe78 = floor(var_52d56);
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
// Approximation, matches 48 cases out of 64
#if defined(TINTING__ENABLED) || defined(UI_ENTITY__DISABLED)
    highp vec4 var_8060e = var_99195;
#endif
#if defined(TINTING__ENABLED) && defined(UI_ENTITY__DISABLED)
    highp vec4 var_7b42e = var_99195;
#endif
#ifdef TINTING__ENABLED
    for (int var_f2336 = 0; var_f2336 < int(PatternCount.x); var_f2336++)
    {
        highp vec4 var_15a75 = texture(s_MatTexture2, (PatternUVOffsetsAndScales[var_f2336].zw * v_texcoord0) + PatternUVOffsetsAndScales[var_f2336].xy) * PatternColors[var_f2336];
        highp vec4 var_38068 = var_15a75;
#endif
#if defined(TINTING__ENABLED) && defined(UI_ENTITY__DISABLED)
        var_7b42e = mix(var_7b42e, var_15a75, vec4(var_38068.w));
#endif
#if defined(TINTING__ENABLED) && defined(UI_ENTITY__ENABLED)
        var_8060e = mix(var_8060e, var_15a75, vec4(var_38068.w));
#endif
#ifdef TINTING__ENABLED
    }
#endif
#if defined(TINTING__ENABLED) && defined(UI_ENTITY__ENABLED)
    var_8060e.w = 1.0;
#endif
#if defined(TINTING__ENABLED) && defined(UI_ENTITY__DISABLED)
    var_7b42e.w = 1.0;
    highp vec4 var_8060e = var_7b42e;
    highp vec3 var_dbc2f = var_7b42e.xyz * v_light.xyz;
#endif
#if defined(TINTING__DISABLED) && defined(UI_ENTITY__DISABLED)
    highp vec3 var_dbc2f = var_99195.xyz * v_light.xyz;
#endif
#ifdef UI_ENTITY__DISABLED
    var_8060e.x = var_dbc2f.x;
    var_8060e.y = var_dbc2f.y;
    var_8060e.z = var_dbc2f.z;
#endif
#if defined(TINTING__ENABLED) || defined(UI_ENTITY__DISABLED)
    var_99195 = var_8060e;
#endif
    highp float var_d8f56 = var_99195.w;
    highp vec4 var_80976 = (GlintColor * (texture(s_MatTexture1, fract(v_layerUv.xy)).xyzx + texture(s_MatTexture1, fract(v_layerUv.zw)).xyzx)) * TileLightColor;
#if defined(TINTING__ENABLED) || defined(UI_ENTITY__DISABLED)
    highp vec4 var_f8a49 = vec4(var_80976.xyz * var_80976.xyz, abs(var_80976.w)) + vec4(var_8060e.xyz, 0.0);
#endif
#if defined(TINTING__DISABLED) && defined(UI_ENTITY__ENABLED)
    highp vec4 var_f8a49 = vec4(var_80976.xyz * var_80976.xyz, abs(var_80976.w)) + vec4(var_99195.xyz, 0.0);
#endif
#if defined(TINTING__ENABLED) || defined(UI_ENTITY__DISABLED)
    var_f8a49.w = var_8060e.w;
#endif
#if defined(TINTING__DISABLED) && defined(UI_ENTITY__ENABLED)
    var_f8a49.w = var_99195.w;
#endif
    var_99195 = var_f8a49;
    var_99195.w = var_d8f56;
    highp vec4 var_e4436 = var_99195;
    var_e4436.w *= HudOpacity.x;
    var_99195 = var_e4436;
    highp vec4 var_4b012 = vec4(var_e4436.xyz, var_99195.w);
    highp vec4 var_72c1b = var_4b012;
    highp vec3 var_c6e56 = mix(var_4b012.xyz, v_fog.xyz, vec3(v_fog.w));
    var_72c1b.x = var_c6e56.x;
    var_72c1b.y = var_c6e56.y;
    var_72c1b.z = var_c6e56.z;
    bgfx_FragData0 = var_72c1b;
}
