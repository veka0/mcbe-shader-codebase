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
* Uniforms:
* - uniform vec4 BlockLightColor;
* - uniform vec4 ChangeColor;
* - uniform vec4 ColorBased;
* - uniform vec4 DitherParams;
* - uniform vec4 DitherParams2[3];
* - uniform vec4 DitheringEnabledToggle;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MaterialID;
* - uniform vec4 MultiplicativeTintColor;
* - uniform vec4 OverlayColor;
* - uniform mat4 PrevWorld;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 TileLightColor;
* - uniform vec4 TileLightIntensity;
* - uniform vec4 ViewPositionAndTime;
*/

precision mediump float;
precision highp int;
float var_33fae;
uniform highp mat4 u_invView;
uniform highp mat4 u_prevViewProj;
uniform highp mat4 u_view;
uniform highp mat4 u_viewProj;
uniform highp vec4 ChangeColor;
uniform highp vec4 ColorBased;
uniform highp vec4 DitherParams2[3];
uniform highp vec4 DitherParams;
uniform highp vec4 DitheringEnabledToggle;
#ifdef MULTI_COLOR_TINT__ON
uniform highp vec4 MultiplicativeTintColor;
#endif
uniform highp vec4 OverlayColor;
uniform highp vec4 TileLightIntensity;
uniform highp vec4 u_prevWorldPosOffset;
in highp vec4 v_clipPosition;
in highp vec4 v_color0;
in highp vec4 v_mers;
in highp vec3 v_normal;
in highp vec3 v_prevWorldPos;
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragData0;
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
    highp vec4 var_517fd = v_color0;
#endif
    highp vec4 var_7a2d2 = v_mers;
#ifdef MULTI_COLOR_TINT__OFF
    highp vec3 var_05ab4 = mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x));
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec3 var_620d5 = mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x));
    highp vec2 var_35473 = var_620d5.xy;
    highp vec3 var_9489a = mix(mix((var_620d5.xxx * ChangeColor.xyz).xyz, var_620d5.yyy * MultiplicativeTintColor.xyz, vec3(ceil(var_35473.y))).xyz, OverlayColor.xyz, vec3(OverlayColor.w));
    highp vec4 var_db2c1 = vec4(var_9489a.x, var_9489a.y, var_9489a.z, vec4(1.0).w);
#endif
#ifdef MULTI_COLOR_TINT__OFF
    highp vec4 var_e2f60 = vec4(var_05ab4.x, var_05ab4.y, var_05ab4.z, vec4(1.0).w);
    highp vec3 var_a7fd7 = mix(mix(var_e2f60, var_e2f60 * ChangeColor, vec4(var_517fd.w)).xyz, OverlayColor.xyz, vec3(OverlayColor.w));
    highp vec4 var_db2c1 = vec4(var_a7fd7.x, var_a7fd7.y, var_a7fd7.z, vec4(1.0).w);
#endif
    highp vec2 var_7c9c5 = DitherParams2[0].xy;
    bool var_410b5;
    if (DitheringEnabledToggle.x != 0.0)
    {
        highp mat4 var_4971e = u_view;
        highp vec4 var_d36cf = v_clipPosition;
        highp vec2 var_886c2 = floor(((((v_clipPosition.xyz / vec3(var_d36cf.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[0].z)) * DitherParams2[0].z;
        highp vec2 var_f4989 = floor(var_886c2 * 0.25);
        highp vec2 var_85686 = floor(var_886c2 * 0.5);
        highp vec2 var_09c49 = floor(var_886c2);
        var_410b5 = smoothstep(var_7c9c5.x, var_7c9c5.y, dot(-normalize(vec4(var_4971e[0].z, var_4971e[1].z, var_4971e[2].z, var_33fae).xyz), v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz)) <= (((((((fract((var_f4989.x * 0.5) + ((var_f4989.y * var_f4989.y) * 0.75)) * 0.25) + fract((var_85686.x * 0.5) + ((var_85686.y * var_85686.y) * 0.75))) * 0.25) + fract((var_09c49.x * 0.5) + ((var_09c49.y * var_09c49.y) * 0.75))) * 64.0) + 0.5) * 0.015625);
    }
    else
    {
        var_410b5 = false;
    }
    if (var_410b5)
    {
        var_db2c1.w = 0.0;
    }
    highp vec4 var_08b04 = vec4(var_db2c1.xyz, var_db2c1.w);
    highp vec4 var_e74f1 = vec4(var_08b04.x, var_08b04.y, var_08b04.z, var_08b04.w);
    highp float var_e206e;
    func_42a6a(var_7a2d2, var_e206e);
    var_e74f1.w = var_e206e;
    highp vec3 var_8c816 = normalize(v_normal);
    highp vec3 var_cd914 = var_8c816;
    highp vec2 var_645ff = var_8c816.xy * (1.0 / ((abs(var_cd914.x) + abs(var_cd914.y)) + abs(var_cd914.z)));
    highp vec2 var_72494;
    if (var_cd914.z < 0.0)
    {
        var_72494 = (vec2(1.0) - abs(var_645ff.yx)) * ((step(vec2(0.0), var_645ff) * 2.0) - vec2(1.0));
    }
    else
    {
        var_72494 = var_645ff;
    }
    highp vec4 var_5dd1c = u_viewProj * vec4(v_worldPos, 1.0);
    highp vec4 var_46c40 = var_5dd1c;
    highp float var_bc97b = var_46c40.w;
    highp vec4 var_efb33 = ((var_5dd1c / vec4(var_bc97b)) * 0.5) + vec4(0.5);
    var_46c40 = var_efb33;
    highp vec4 var_21b68 = u_prevViewProj * vec4(v_prevWorldPos - u_prevWorldPosOffset.xyz, 1.0);
    highp vec4 var_96bda = var_21b68;
    highp float var_9ef48 = var_96bda.w;
    highp vec4 var_c94a9 = ((var_21b68 / vec4(var_9ef48)) * 0.5) + vec4(0.5);
    var_96bda = var_c94a9;
    bgfx_FragData0 = var_e74f1;
    bgfx_FragData1 = vec4(var_72494, var_efb33.xy - var_c94a9.xy);
    bgfx_FragData2 = vec4(var_7a2d2.y, TileLightIntensity.x, TileLightIntensity.y, var_7a2d2.z);
}
