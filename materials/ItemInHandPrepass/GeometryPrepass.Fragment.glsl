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
uniform highp vec4 BlockLightColor;
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
layout(location = 0) out uvec4 bgfx_FragData0;
layout(location = 1) out highp vec4 bgfx_FragData1;
layout(location = 2) out highp vec4 bgfx_FragData2;
void func_59429(inout highp float arg_b5546) {
    if (v_mers.x > v_mers.w)
    {
        arg_b5546 = 0.501960813999176025390625 + (0.4980392158031463623046875 * v_mers.x);
        return;
    }
    else
    {
        arg_b5546 = 0.4980392158031463623046875 - (0.4980392158031463623046875 * v_mers.w);
        return;
    }
}
void main() {
    highp vec4 var_056fc = vec4(1.0);
    highp vec3 var_08760 = mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x));
    var_056fc.x = var_08760.x;
    var_056fc.y = var_08760.y;
    var_056fc.z = var_08760.z;
    highp vec4 var_9d23e = var_056fc;
#ifdef MULTI_COLOR_TINT__OFF
    highp vec4 var_754d5 = mix(var_056fc, var_056fc * ChangeColor, vec4(v_color0.w));
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec2 var_e1236 = var_056fc.xy;
    highp vec3 var_754d5 = var_056fc.xxx * ChangeColor.xyz;
#endif
    var_9d23e.x = var_754d5.x;
    var_9d23e.y = var_754d5.y;
    var_9d23e.z = var_754d5.z;
#ifdef MULTI_COLOR_TINT__OFF
    highp vec4 var_28bc5 = var_9d23e;
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec4 var_60355 = var_9d23e;
    highp vec3 var_ef570 = mix(var_60355.xyz, var_056fc.yyy * MultiplicativeTintColor.xyz, vec3(ceil(var_e1236.y)));
    var_9d23e.x = var_ef570.x;
    var_9d23e.y = var_ef570.y;
    var_9d23e.z = var_ef570.z;
    highp vec4 var_28bc5 = var_9d23e;
#endif
    highp vec3 var_2a9cf = mix(var_9d23e.xyz, OverlayColor.xyz, vec3(OverlayColor.w));
    var_28bc5.x = var_2a9cf.x;
    var_28bc5.y = var_2a9cf.y;
    var_28bc5.z = var_2a9cf.z;
    var_056fc = var_28bc5;
    highp vec4 var_08281 = var_28bc5;
    highp vec2 var_7c9c5 = DitherParams2[0].xy;
    bool var_410b5;
    if (DitheringEnabledToggle.x != 0.0)
    {
        highp mat4 var_4971e = u_view;
        highp vec2 var_2c6b3 = floor(((((v_clipPosition.xyz / vec3(v_clipPosition.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[0].z)) * DitherParams2[0].z;
        highp vec2 var_f4989 = floor(var_2c6b3 * 0.25);
        highp vec2 var_85686 = floor(var_2c6b3 * 0.5);
        highp vec2 var_09c49 = floor(var_2c6b3);
        var_410b5 = smoothstep(var_7c9c5.x, var_7c9c5.y, dot(-normalize(vec4(var_4971e[0].z, var_4971e[1].z, var_4971e[2].z, var_33fae).xyz), v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz)) <= (((((((fract((var_f4989.x * 0.5) + ((var_f4989.y * var_f4989.y) * 0.75)) * 0.25) + fract((var_85686.x * 0.5) + ((var_85686.y * var_85686.y) * 0.75))) * 0.25) + fract((var_09c49.x * 0.5) + ((var_09c49.y * var_09c49.y) * 0.75))) * 64.0) + 0.5) * 0.015625);
    }
    else
    {
        var_410b5 = false;
    }
    if (var_410b5)
    {
        var_08281.w = 0.0;
    }
    highp vec4 var_7cd00 = vec4(BlockLightColor.xyz, 0.0);
    highp vec4 var_73c41 = var_7cd00;
    highp vec4 var_d93e5 = vec4(var_08281.xyz, var_08281.w);
    highp vec4 var_33385 = vec4(0.0);
    var_d93e5.x = var_08281.x;
    var_d93e5.y = var_08281.y;
    var_d93e5.z = var_08281.z;
    highp float var_1d2b2;
    func_59429(var_1d2b2);
    var_d93e5.w = var_1d2b2;
    highp vec3 var_8c816 = normalize(v_normal);
    highp vec3 var_cd914 = var_8c816;
    highp vec2 var_645ff = var_8c816.xy * (1.0 / ((abs(var_cd914.x) + abs(var_cd914.y)) + abs(var_cd914.z)));
    highp vec2 var_8860a;
    if (var_cd914.z < 0.0)
    {
        var_8860a = (vec2(1.0) - abs(var_645ff.yx)) * ((step(vec2(0.0), var_645ff) * 2.0) - vec2(1.0));
    }
    else
    {
        var_8860a = var_645ff;
    }
    var_33385.x = var_8860a.x;
    var_33385.y = var_8860a.y;
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
    highp vec2 var_fd2cd = var_7ed87.xy - var_82203.xy;
    var_33385.z = var_fd2cd.x;
    var_33385.w = var_fd2cd.y;
    highp vec3 var_d13a4 = var_7cd00.xyz;
    highp vec3 var_ec82b = var_d13a4;
    highp vec3 var_eb137;
    if ((((var_ec82b.x + var_ec82b.y) + var_ec82b.z) < 9.9999997473787516355514526367188e-05) && (TileLightIntensity.x > 9.9999997473787516355514526367188e-05))
    {
        highp float var_c1e8f = TileLightIntensity.x * TileLightIntensity.x;
        var_eb137 = clamp(vec3(var_c1e8f, var_c1e8f * ((((var_c1e8f * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625), var_c1e8f * (((var_c1e8f * var_c1e8f) * 0.60000002384185791015625) + 0.4000000059604644775390625)), vec3(0.0), vec3(1.0));
    }
    else
    {
        var_eb137 = var_d13a4;
    }
    highp vec3 var_8f0e5 = var_eb137 * vec3(0.16666667163372039794921875);
    highp vec4 var_f46ce = vec4(var_8f0e5, 0.0039215688593685626983642578125);
    highp vec2 var_8a7dd = max(var_f46ce.xy, var_f46ce.zw);
    highp float var_a7109 = ceil(clamp(max(var_8a7dd.x, var_8a7dd.y), 0.0, 1.0) * 255.0) * 0.0039215688593685626983642578125;
    uvec4 var_63c1c = uvec4(clamp(vec4(var_8f0e5 / vec3(var_a7109), var_a7109), vec4(0.0), vec4(1.0)) * 255.0);
    uvec2 var_768db = var_63c1c.xy;
    uvec2 var_f7a74 = uvec2(var_768db.x & 255u, var_768db.y & 255u);
    uvec2 var_cc1c7 = var_63c1c.zw;
    uvec2 var_8bc3e = uvec2(var_cc1c7.x & 255u, var_cc1c7.y & 255u);
    uvec2 var_a74c0 = uvec2((var_f7a74.x << 8u) | var_f7a74.y, (var_8bc3e.x << 8u) | var_8bc3e.y);
    highp vec3 var_0b329 = normalize(v_normal);
    bvec3 var_50211 = greaterThanEqual(abs(var_0b329), vec3(0.9900000095367431640625));
    ivec3 var_f1fb7 = ivec3(any(lessThan(var_0b329, vec3(-0.5))) ? (-1) : 1) * ivec3(int(var_50211.x), int(var_50211.y), int(var_50211.z));
    ivec3 var_6364f = abs(var_f1fb7);
    uvec2 var_ea3d7 = uvec2(uint(clamp(v_mers.z, 0.0, 1.0) * 255.0) & 255u, uint(clamp(v_mers.y, 0.0, 1.0) * 255.0) & 255u);
    bgfx_FragData0 = uvec4((var_ea3d7.x << 8u) | var_ea3d7.y, var_a74c0.x, var_a74c0.y, (uint(clamp(TileLightIntensity.y, 0.0, 1.0) * 255.0) | uint(((uint(floor(var_73c41.w * 255.0)) & 1u) != 0u) ? 256 : 0)) | ((((uint(var_6364f.x + var_6364f.z) | uint((var_6364f.y + var_6364f.z) << 1)) | uint(int(any(equal(vec3(var_f1fb7), vec3(-1.0)))) << 2)) & 7u) << uint(9)));
    bgfx_FragData1 = var_d93e5;
    bgfx_FragData2 = var_33385;
}
