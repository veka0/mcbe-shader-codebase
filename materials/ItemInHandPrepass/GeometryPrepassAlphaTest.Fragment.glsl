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
* - uniform vec4 ChangeColor;
* - uniform vec4 ColorBased;
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
uniform highp mat4 u_prevViewProj;
uniform highp mat4 u_viewProj;
uniform highp vec4 ChangeColor;
uniform highp vec4 ColorBased;
#ifdef MULTI_COLOR_TINT__ON
uniform highp vec4 MultiplicativeTintColor;
#endif
uniform highp vec4 OverlayColor;
uniform highp vec4 TileLightIntensity;
uniform highp vec4 u_prevWorldPosOffset;
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
    highp vec3 var_d7f97 = mix(mix((var_620d5.xxx * ChangeColor.xyz).xyz, var_620d5.yyy * MultiplicativeTintColor.xyz, vec3(ceil(var_35473.y))).xyz, OverlayColor.xyz, vec3(OverlayColor.w));
    highp vec4 var_bac29 = vec4(var_d7f97.x, var_d7f97.y, var_d7f97.z, vec4(1.0).w);
#endif
#ifdef MULTI_COLOR_TINT__OFF
    highp vec4 var_e2f60 = vec4(var_05ab4.x, var_05ab4.y, var_05ab4.z, vec4(1.0).w);
    highp vec3 var_ba02f = mix(mix(var_e2f60, var_e2f60 * ChangeColor, vec4(var_517fd.w)).xyz, OverlayColor.xyz, vec3(OverlayColor.w));
    highp vec4 var_bac29 = vec4(var_ba02f.x, var_ba02f.y, var_ba02f.z, vec4(1.0).w);
#endif
    if (var_bac29.w < 0.5)
    {
        discard;
    }
#ifdef MULTI_COLOR_TINT__OFF
    highp vec4 var_bbaa8 = vec4(var_ba02f, var_bac29.w);
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec4 var_bbaa8 = vec4(var_d7f97, var_bac29.w);
#endif
    highp vec4 var_e74f1 = vec4(var_bbaa8.x, var_bbaa8.y, var_bbaa8.z, var_bbaa8.w);
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
