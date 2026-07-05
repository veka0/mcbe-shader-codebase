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
* Fancy:
* - FANCY__OFF (not used)
* - FANCY__ON (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* MultiColorTint:
* - MULTI_COLOR_TINT__OFF
* - MULTI_COLOR_TINT__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_GlintTexture;
*
* Uniforms:
* - uniform vec4 BlockLightColor;
* - uniform vec4 ChangeColor;
* - uniform vec4 ColorBased;
* - uniform vec4 DitherParams;
* - uniform vec4 DitherParams2[3];
* - uniform vec4 DitheringEnabledToggle;
* - uniform vec4 FogColor;
* - uniform vec4 FogControl;
* - uniform vec4 GlintColor;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MaterialID;
* - uniform vec4 MultiplicativeTintColor;
* - uniform vec4 OverlayColor;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 TileLightColor;
* - uniform vec4 TileLightIntensity;
* - uniform vec4 UVAnimation;
* - uniform vec4 UVScale;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_GlintTexture;
uniform highp vec4 ChangeColor;
uniform highp vec4 ColorBased;
uniform highp vec4 GlintColor;
#ifdef MULTI_COLOR_TINT__ON
uniform highp vec4 MultiplicativeTintColor;
#endif
uniform highp vec4 OverlayColor;
uniform highp vec4 TileLightColor;
in highp vec4 v_color0;
in highp vec4 v_fog;
in highp vec4 v_glintUV;
in highp vec4 v_light;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
#ifdef MULTI_COLOR_TINT__OFF
    highp vec4 var_f8735 = v_color0;
#endif
    highp vec3 var_ac065 = mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x));
#ifdef MULTI_COLOR_TINT__OFF
    highp vec4 var_01aa6 = vec4(var_ac065.x, var_ac065.y, var_ac065.z, vec4(1.0).w);
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec2 var_449c5 = var_ac065.xy;
#endif
    highp vec4 var_d4311 = (GlintColor * (texture(s_GlintTexture, fract(v_glintUV.xy)).xyzx + texture(s_GlintTexture, fract(v_glintUV.zw)).xyzx)) * TileLightColor;
#ifdef MULTI_COLOR_TINT__OFF
    highp vec4 var_b8bc1 = vec4(var_d4311.xyz * var_d4311.xyz, abs(var_d4311.w)) + vec4(mix(mix(var_01aa6, var_01aa6 * ChangeColor, vec4(var_f8735.w)).xyz, OverlayColor.xyz, vec3(OverlayColor.w)).xyz * v_light.xyz, 0.0);
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec4 var_b8bc1 = vec4(var_d4311.xyz * var_d4311.xyz, abs(var_d4311.w)) + vec4(mix(mix((var_ac065.xxx * ChangeColor.xyz).xyz, var_ac065.yyy * MultiplicativeTintColor.xyz, vec3(ceil(var_449c5.y))).xyz, OverlayColor.xyz, vec3(OverlayColor.w)).xyz * v_light.xyz, 0.0);
#endif
    var_b8bc1.w = 1.0;
    highp vec4 var_6ef7d = var_b8bc1;
    highp vec4 var_8544b = v_fog;
    bgfx_FragColor = vec4(mix(vec4(var_b8bc1.xyz, var_6ef7d.w).xyz, v_fog.xyz, vec3(var_8544b.w)), var_6ef7d.w);
}
