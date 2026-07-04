#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_OPAQUE_PASS (not used)
* - GEOMETRY_PREPASS_PASS (not used)
* - GEOMETRY_PREPASS_ALPHA_TEST_PASS (not used)
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
* - uniform mat4 PrevWorld;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 TileLightColor;
* - uniform vec4 TileLightIntensity;
* - uniform vec4 UVAnimation;
* - uniform vec4 UVScale;
* - uniform vec4 ViewPositionAndTime;
*/

precision mediump float;
precision highp int;
float var_33fae;
uniform highp mat4 u_invView;
uniform highp mat4 u_prevViewProj;
uniform highp mat4 u_view;
uniform highp mat4 u_viewProj;
uniform highp sampler2D s_GlintTexture;
uniform highp vec4 BlockLightColor;
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
uniform highp vec4 TileLightIntensity;
uniform highp vec4 u_prevWorldPosOffset;
in highp vec4 v_clipPosition;
in highp vec4 v_color0;
in highp vec4 v_glintUV;
in highp vec4 v_mers;
in highp vec3 v_normal;
in highp vec3 v_prevWorldPos;
in highp vec3 v_worldPos;
layout(location = 0) out uvec4 bgfx_FragData0;
layout(location = 1) out highp vec4 bgfx_FragData1;
layout(location = 2) out highp vec4 bgfx_FragData2;
void func_42a6a(inout highp vec4 arg_df1c1, inout highp float arg_310da) {
    if (arg_df1c1.x > arg_df1c1.w)
    {
        arg_310da = 0.501960813999176025390625 + (0.4980392158031463623046875 * arg_df1c1.x);
        return;
    }
    else
    {
        arg_310da = 0.4980392158031463623046875 - (0.4980392158031463623046875 * arg_df1c1.w);
        return;
    }
}
void main() {
#ifdef MULTI_COLOR_TINT__OFF
    highp vec4 var_6f02f = v_color0;
#endif
    highp vec4 var_2ef20 = v_mers;
    highp vec3 var_fde9e = mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x));
#ifdef MULTI_COLOR_TINT__OFF
    highp vec4 var_27c73 = vec4(var_fde9e.x, var_fde9e.y, var_fde9e.z, vec4(1.0).w);
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec2 var_e2e9b = var_fde9e.xy;
#endif
    highp vec4 var_52763 = (GlintColor * (texture(s_GlintTexture, fract(v_glintUV.xy)).xyzx + texture(s_GlintTexture, fract(v_glintUV.zw)).xyzx)) * TileLightColor;
#ifdef MULTI_COLOR_TINT__OFF
    highp vec4 var_0e868 = vec4(var_52763.xyz * var_52763.xyz, abs(var_52763.w)) + vec4(mix(mix(var_27c73, var_27c73 * ChangeColor, vec4(var_6f02f.w)).xyz, OverlayColor.xyz, vec3(OverlayColor.w)), 0.0);
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec4 var_0e868 = vec4(var_52763.xyz * var_52763.xyz, abs(var_52763.w)) + vec4(mix(mix((var_fde9e.xxx * ChangeColor.xyz).xyz, var_fde9e.yyy * MultiplicativeTintColor.xyz, vec3(ceil(var_e2e9b.y))).xyz, OverlayColor.xyz, vec3(OverlayColor.w)), 0.0);
#endif
    var_0e868.w = 1.0;
    highp vec4 var_31b5e = var_0e868;
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
    if (var_ab7ce || (var_31b5e.w < 0.5))
    {
        discard;
    }
    highp vec4 var_08b04 = vec4(var_0e868.xyz, var_31b5e.w);
    highp vec4 var_6bfdc = vec4(var_08b04.x, var_08b04.y, var_08b04.z, var_08b04.w);
    highp float var_e206e;
    func_42a6a(var_2ef20, var_e206e);
    var_6bfdc.w = var_e206e;
    highp vec3 var_8c816 = normalize(v_normal);
    highp vec3 var_cd914 = var_8c816;
    highp vec2 var_645ff = var_8c816.xy * (1.0 / ((abs(var_cd914.x) + abs(var_cd914.y)) + abs(var_cd914.z)));
    highp vec2 var_532c2;
    if (var_cd914.z < 0.0)
    {
        var_532c2 = (vec2(1.0) - abs(var_645ff.yx)) * ((step(vec2(0.0), var_645ff) * 2.0) - vec2(1.0));
    }
    else
    {
        var_532c2 = var_645ff;
    }
    highp vec4 var_5dd1c = u_viewProj * vec4(v_worldPos, 1.0);
    highp vec4 var_46c40 = var_5dd1c;
    highp float var_bc97b = var_46c40.w;
    highp vec4 var_603d8 = ((var_5dd1c / vec4(var_bc97b)) * 0.5) + vec4(0.5);
    var_46c40 = var_603d8;
    highp vec4 var_21b68 = u_prevViewProj * vec4(v_prevWorldPos - u_prevWorldPosOffset.xyz, 1.0);
    highp vec4 var_96bda = var_21b68;
    highp float var_9ef48 = var_96bda.w;
    highp vec4 var_d0ebc = ((var_21b68 / vec4(var_9ef48)) * 0.5) + vec4(0.5);
    var_96bda = var_d0ebc;
    highp vec3 var_f88c4 = BlockLightColor.xyz;
    highp vec3 var_fbfa9;
    if ((((var_f88c4.x + var_f88c4.y) + var_f88c4.z) < 9.9999997473787516355514526367188e-05) && (TileLightIntensity.x > 9.9999997473787516355514526367188e-05))
    {
        highp vec4 var_0bc6f = vec4(0.0);
        highp float var_88ce0 = TileLightIntensity.x * TileLightIntensity.x;
        var_fbfa9 = clamp(vec3(var_88ce0 + (var_0bc6f.x * var_0bc6f.w), (var_88ce0 * ((((var_88ce0 * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_0bc6f.y * var_0bc6f.w), (var_88ce0 * (((var_88ce0 * var_88ce0) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_0bc6f.z * var_0bc6f.w)), vec3(0.0), vec3(1.0));
    }
    else
    {
        var_fbfa9 = BlockLightColor.xyz;
    }
    highp vec3 var_8f0e5 = var_fbfa9 * vec3(0.16666667163372039794921875);
    highp vec4 var_f46ce = vec4(var_8f0e5, 0.0039215688593685626983642578125);
    highp vec2 var_8a7dd = max(var_f46ce.xy, var_f46ce.zw);
    highp float var_a7109 = ceil(clamp(max(var_8a7dd.x, var_8a7dd.y), 0.0, 1.0) * 255.0) * 0.0039215688593685626983642578125;
    uvec4 var_63c1c = uvec4(clamp(vec4(var_8f0e5 / vec3(var_a7109), var_a7109), vec4(0.0), vec4(1.0)) * 255.0);
    uvec2 var_768db = var_63c1c.xy;
    uvec2 var_f7a74 = uvec2(var_768db.x & 255u, var_768db.y & 255u);
    uvec2 var_cc1c7 = var_63c1c.zw;
    uvec2 var_8bc3e = uvec2(var_cc1c7.x & 255u, var_cc1c7.y & 255u);
    uvec2 var_92e39 = uvec2((var_f7a74.x << 8u) | var_f7a74.y, (var_8bc3e.x << 8u) | var_8bc3e.y);
    uvec2 var_800fa = uvec2(uint(clamp(var_2ef20.z, 0.0, 1.0) * 255.0) & 255u, uint(clamp(var_2ef20.y, 0.0, 1.0) * 255.0) & 255u);
    bgfx_FragData0 = uvec4((var_800fa.x << 8u) | var_800fa.y, var_92e39.x, var_92e39.y, uint(clamp(TileLightIntensity.y, 0.0, 1.0) * 255.0));
    bgfx_FragData1 = var_6bfdc;
    bgfx_FragData2 = vec4(var_532c2, var_603d8.xy - var_d0ebc.xy);
}
