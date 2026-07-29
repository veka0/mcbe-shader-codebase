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
float var_33fae;
uniform highp mat4 u_invView;
uniform highp mat4 u_view;
uniform highp sampler2D s_GlintTexture;
uniform highp vec4 ChangeColor;
uniform highp vec4 ColorBased;
uniform highp vec4 DitherParams2[3];
uniform highp vec4 DitherParams;
uniform highp vec4 DitheringEnabledToggle;
uniform highp vec4 GlintColor;
#ifdef MULTI_COLOR_TINT__ON
uniform highp vec4 MultiplicativeTintColor;
#endif
uniform highp vec4 OverlayColor;
uniform highp vec4 TileLightColor;
in highp vec4 v_clipPosition;
in highp vec4 v_color0;
in highp vec4 v_fog;
in highp vec4 v_glintUV;
in highp vec4 v_light;
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragData0;
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
    highp vec4 var_94eb4 = vec4(var_d4311.xyz * var_d4311.xyz, abs(var_d4311.w)) + vec4(mix(mix(var_01aa6, var_01aa6 * ChangeColor, vec4(var_f8735.w)).xyz, OverlayColor.xyz, vec3(OverlayColor.w)).xyz * v_light.xyz, 0.0);
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec4 var_94eb4 = vec4(var_d4311.xyz * var_d4311.xyz, abs(var_d4311.w)) + vec4(mix(mix((var_ac065.xxx * ChangeColor.xyz).xyz, var_ac065.yyy * MultiplicativeTintColor.xyz, vec3(ceil(var_449c5.y))).xyz, OverlayColor.xyz, vec3(OverlayColor.w)).xyz * v_light.xyz, 0.0);
#endif
    var_94eb4.w = 1.0;
    highp vec4 var_a8757 = var_94eb4;
    highp vec2 var_7c9c5 = DitherParams2[0].xy;
    bool var_ab7ce;
    if (DitheringEnabledToggle.x != 0.0)
    {
        highp mat4 var_4971e = u_view;
        highp vec4 var_d36cf = v_clipPosition;
        highp vec2 var_886c2 = floor(((((v_clipPosition.xyz / vec3(var_d36cf.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[0].z)) * DitherParams2[0].z;
        highp vec2 var_f4989 = floor(var_886c2 * 0.25);
        highp vec2 var_85686 = floor(var_886c2 * 0.5);
        highp vec2 var_09c49 = floor(var_886c2);
        var_ab7ce = smoothstep(var_7c9c5.x, var_7c9c5.y, dot(-normalize(vec4(var_4971e[0].z, var_4971e[1].z, var_4971e[2].z, var_33fae).xyz), v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz)) <= (((((((fract((var_f4989.x * 0.5) + ((var_f4989.y * var_f4989.y) * 0.75)) * 0.25) + fract((var_85686.x * 0.5) + ((var_85686.y * var_85686.y) * 0.75))) * 0.25) + fract((var_09c49.x * 0.5) + ((var_09c49.y * var_09c49.y) * 0.75))) * 64.0) + 0.5) * 0.015625);
    }
    else
    {
        var_ab7ce = false;
    }
    if (var_ab7ce || (var_a8757.w < 0.5))
    {
        discard;
    }
    highp vec4 var_f6e07 = v_fog;
    bgfx_FragData0 = vec4(mix(vec4(var_94eb4.xyz, var_a8757.w).xyz, v_fog.xyz, vec3(var_f6e07.w)), var_a8757.w);
}
