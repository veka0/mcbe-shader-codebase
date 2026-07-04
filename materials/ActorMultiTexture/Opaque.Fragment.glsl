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
uniform highp sampler2D s_MatTexture1;
uniform highp sampler2D s_MatTexture2;
uniform highp sampler2D s_MatTexture;
#ifdef COLOR_SECOND_TEXTURE__ON
uniform highp vec4 ActorFPEpsilon;
#endif
#if defined(COLOR_SECOND_TEXTURE__ON) || !defined(CHANGE_COLOR__OFF)
uniform highp vec4 ChangeColor;
#endif
uniform highp vec4 ColorBased;
uniform highp vec4 MatColor;
#ifdef CHANGE_COLOR__MULTI
uniform highp vec4 MultiplicativeTintColor;
#endif
uniform highp vec4 OverlayColor;
in highp vec4 v_color0;
in highp vec4 v_fog;
in highp vec4 v_light;
centroid in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
#if defined(MASKED_MULTITEXTURE__OFF) && !defined(CHANGE_COLOR__OFF)
    highp vec4 var_98b25 = MatColor * texture(s_MatTexture, v_texcoord0);
#endif
#if defined(CHANGE_COLOR__OFF) && defined(MASKED_MULTITEXTURE__OFF)
    highp vec4 var_df431 = MatColor * texture(s_MatTexture, v_texcoord0);
#endif
#ifdef MASKED_MULTITEXTURE__ON
    highp vec4 var_7fef3 = texture(s_MatTexture1, v_texcoord0);
    highp vec4 var_0b7d3 = var_7fef3;
#endif
#if defined(CHANGE_COLOR__ON) && defined(MASKED_MULTITEXTURE__OFF)
    highp vec4 var_df431 = var_98b25;
#endif
#if defined(MASKED_MULTITEXTURE__ON) && !defined(CHANGE_COLOR__OFF)
    highp vec4 var_98b25 = mix(var_7fef3, MatColor * texture(s_MatTexture, v_texcoord0), vec4(float((((var_0b7d3.x + var_0b7d3.y) + var_0b7d3.z) * (1.0 - var_0b7d3.w)) > 0.0)));
#endif
#if defined(CHANGE_COLOR__OFF) && defined(MASKED_MULTITEXTURE__ON)
    highp vec4 var_df431 = mix(var_7fef3, MatColor * texture(s_MatTexture, v_texcoord0), vec4(float((((var_0b7d3.x + var_0b7d3.y) + var_0b7d3.z) * (1.0 - var_0b7d3.w)) > 0.0)));
#endif
#ifdef CHANGE_COLOR__MULTI
    highp vec2 var_459de = var_98b25.xy;
    highp vec3 var_1099e = mix((var_98b25.xxx * ChangeColor.xyz).xyz, var_98b25.yyy * MultiplicativeTintColor.xyz, vec3(ceil(var_459de.y)));
    highp vec4 var_df431 = vec4(var_1099e.x, var_1099e.y, var_1099e.z, var_98b25.w);
#endif
#if defined(CHANGE_COLOR__ON) && defined(MASKED_MULTITEXTURE__ON)
    highp vec4 var_df431 = var_98b25;
#endif
#ifdef CHANGE_COLOR__ON
    highp vec4 var_8a135 = ChangeColor;
    highp vec3 var_fba6e = mix(var_98b25.xyz, var_98b25.xyz * ChangeColor.xyz, vec3(var_df431.w));
    var_df431 = vec4(var_fba6e.x, var_fba6e.y, var_fba6e.z, var_98b25.w);
    var_df431.w *= var_8a135.w;
#endif
    var_df431.w = max(0.0, var_df431.w);
    highp vec4 var_47058 = texture(s_MatTexture1, v_texcoord0);
    highp vec4 var_89907 = var_47058;
#ifdef COLOR_SECOND_TEXTURE__ON
    highp vec3 var_41dfa = mix(var_df431.xyz, var_47058.xyz, vec3(var_89907.w));
#endif
    highp vec4 var_5f29b = texture(s_MatTexture2, v_texcoord0);
    highp vec4 var_a1438 = var_5f29b;
#ifdef COLOR_SECOND_TEXTURE__OFF
    highp vec3 var_7f8f2 = mix((mix(mix(var_df431.xyz, var_47058.xyz, vec3(var_89907.w)).xyz, var_5f29b.xyz, vec3(var_a1438.w)).xyz * mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x))).xyz, OverlayColor.xyz, vec3(OverlayColor.w)).xyz * v_light.xyz;
#endif
#ifdef COLOR_SECOND_TEXTURE__ON
    highp vec4 var_419cb;
    if (var_a1438.w > ActorFPEpsilon.x)
    {
        highp vec3 var_d6fab = mix(var_5f29b.xyz, var_5f29b.xyz * ChangeColor.xyz, vec3(var_a1438.w));
        var_419cb = vec4(var_d6fab.x, var_d6fab.y, var_d6fab.z, var_df431.w);
    }
    else
    {
        var_419cb = vec4(var_41dfa.x, var_41dfa.y, var_41dfa.z, var_df431.w);
    }
    highp vec3 var_7f8f2 = mix((var_419cb.xyz * mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x))).xyz, OverlayColor.xyz, vec3(OverlayColor.w)).xyz * v_light.xyz;
    highp vec4 var_d1ac0 = vec4(var_7f8f2.x, var_7f8f2.y, var_7f8f2.z, var_419cb.w);
#endif
#ifdef COLOR_SECOND_TEXTURE__OFF
    highp vec4 var_d1ac0 = vec4(var_7f8f2.x, var_7f8f2.y, var_7f8f2.z, var_df431.w);
#endif
    highp vec4 var_dc02c = v_fog;
    bgfx_FragColor = vec4(mix(vec4(var_7f8f2, var_d1ac0.w).xyz, v_fog.xyz, vec3(var_dc02c.w)), var_d1ac0.w);
}
