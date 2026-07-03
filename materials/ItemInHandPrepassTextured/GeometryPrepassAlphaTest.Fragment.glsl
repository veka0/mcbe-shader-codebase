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
* - uniform lowp sampler2D s_MatTexture;
*
* Uniforms:
* - uniform vec4 ChangeColor;
* - uniform vec4 ColorBased;
* - uniform vec4 FogColor;
* - uniform vec4 FogControl;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MatColor;
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
uniform highp sampler2D s_MatTexture;
uniform highp vec4 ChangeColor;
uniform highp vec4 ColorBased;
uniform highp vec4 MatColor;
#ifdef MULTI_COLOR_TINT__ON
uniform highp vec4 MultiplicativeTintColor;
#endif
uniform highp vec4 OverlayColor;
uniform highp vec4 TileLightIntensity;
uniform highp vec4 u_prevWorldPosOffset;
in highp vec4 v_color0;
in highp vec3 v_normal;
in highp vec3 v_prevWorldPos;
in highp vec2 v_texcoord0;
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragData[gl_MaxDrawBuffers];
void func_9b13f(inout highp float arg_6097c) {
    if (false)
    {
        arg_6097c = 0.501960813999176025390625;
        return;
    }
    else
    {
        arg_6097c = 0.4980392158031463623046875;
        return;
    }
}
void main() {
    highp vec4 var_8b5b4 = v_color0;
    highp vec4 var_7dda5 = texture(s_MatTexture, v_texcoord0);
    highp vec4 var_d9c64 = MatColor * var_7dda5;
#ifdef MULTI_COLOR_TINT__OFF
    highp vec3 var_2ce32 = var_d9c64.xyz * mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x));
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec3 var_0bba1 = var_d9c64.xyz * mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x));
    highp vec2 var_35473 = var_0bba1.xy;
    highp vec3 var_280a7 = mix(mix((var_0bba1.xxx * ChangeColor.xyz).xyz, var_0bba1.yyy * MultiplicativeTintColor.xyz, vec3(ceil(var_35473.y))).xyz, OverlayColor.xyz, vec3(OverlayColor.w));
    highp vec4 var_c01f5 = vec4(var_280a7.x, var_280a7.y, var_280a7.z, var_d9c64.w);
#endif
#ifdef MULTI_COLOR_TINT__OFF
    highp vec4 var_24ae4 = vec4(var_2ce32.x, var_2ce32.y, var_2ce32.z, var_d9c64.w);
    highp vec3 var_189a9 = mix(mix(var_24ae4, var_24ae4 * ChangeColor, vec4(var_8b5b4.w)).xyz, OverlayColor.xyz, vec3(OverlayColor.w));
    highp vec4 var_c01f5 = vec4(var_189a9.x, var_189a9.y, var_189a9.z, var_d9c64.w);
#endif
    if (var_c01f5.w < 0.5)
    {
        discard;
    }
#ifdef MULTI_COLOR_TINT__OFF
    highp vec4 var_b46bf = vec4(var_189a9.xyz * v_color0.xyz, var_c01f5.w * var_8b5b4.w);
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec4 var_b46bf = vec4(var_280a7.xyz * v_color0.xyz, var_c01f5.w * var_8b5b4.w);
#endif
    highp vec4 var_6de71 = vec4(var_b46bf.x, var_b46bf.y, var_b46bf.z, var_b46bf.w);
    highp float var_1d2b2;
    func_9b13f(var_1d2b2);
    var_6de71.w = var_1d2b2;
    highp vec3 var_8c816 = normalize(v_normal);
    highp vec3 var_cd914 = var_8c816;
    highp vec2 var_645ff = var_8c816.xy * (1.0 / ((abs(var_cd914.x) + abs(var_cd914.y)) + abs(var_cd914.z)));
    highp vec2 var_5a694;
    if (var_cd914.z < 0.0)
    {
        var_5a694 = (vec2(1.0) - abs(var_645ff.yx)) * ((step(vec2(0.0), var_645ff) * 2.0) - vec2(1.0));
    }
    else
    {
        var_5a694 = var_645ff;
    }
    highp vec4 var_5dd1c = u_viewProj * vec4(v_worldPos, 1.0);
    highp vec4 var_46c40 = var_5dd1c;
    highp float var_bc97b = var_46c40.w;
    highp vec4 var_7ed87 = ((var_5dd1c / vec4(var_bc97b)) * 0.5) + vec4(0.5);
    var_46c40 = var_7ed87;
    highp vec4 var_21b68 = u_prevViewProj * vec4(v_prevWorldPos - u_prevWorldPosOffset.xyz, 1.0);
    highp vec4 var_96bda = var_21b68;
    highp float var_9ef48 = var_96bda.w;
    highp vec4 var_82203 = ((var_21b68 / vec4(var_9ef48)) * 0.5) + vec4(0.5);
    var_96bda = var_82203;
    highp vec2 var_ec5a5 = var_7ed87.xy - var_82203.xy;
    bgfx_FragData[0] = var_6de71;
    bgfx_FragData[1] = vec4(var_5a694.x, var_5a694.y, var_ec5a5.x, var_ec5a5.y);
    bgfx_FragData[2] = vec4(0.0, TileLightIntensity.x, TileLightIntensity.y, 0.5);
}
