#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_ALPHA_TEST_PASS (not used)
* - GEOMETRY_PREPASS_PASS (not used)
* - GEOMETRY_PREPASS_ALPHA_TEST_PASS (not used)
*
* AlphaTest:
* - ALPHA_TEST__OFF (not used)
* - ALPHA_TEST__ON_DISCARD_VALUE_BASED (not used)
* - ALPHA_TEST__ON_VERTEX_TINT_MASK_BASED (not used)
*
* Fancy:
* - FANCY__ON (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* Lit:
* - LIT__OFF (not used)
* - LIT__ON (not used)
*
* UseTextures:
* - USE_TEXTURES__OFF
* - USE_TEXTURES__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MatTexture;
*
* Uniforms:
* - uniform vec4 BlockLightColor;
* - uniform vec4 CurrentColor;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MERSUniforms;
* - uniform vec4 OverlayColor;
* - uniform mat4 PrevWorld;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 TileLightIntensity;
* - uniform vec4 UVAnimation;
* - uniform vec4 ZShiftValue;
*/

precision mediump float;
precision highp int;
uniform highp mat4 u_prevViewProj;
uniform highp mat4 u_viewProj;
#ifdef USE_TEXTURES__ON
uniform highp sampler2D s_MatTexture;
#endif
uniform highp vec4 BlockLightColor;
uniform highp vec4 CurrentColor;
uniform highp vec4 MERSUniforms;
uniform highp vec4 TileLightIntensity;
uniform highp vec4 u_prevWorldPosOffset;
in highp vec4 v_color0;
in highp vec3 v_normal;
in highp vec3 v_prevWorldPos;
#ifdef USE_TEXTURES__ON
in highp vec2 v_texcoord0;
#endif
in highp vec3 v_worldPos;
layout(location = 0) out uvec4 bgfx_FragData0;
layout(location = 1) out highp vec4 bgfx_FragData1;
layout(location = 2) out highp vec4 bgfx_FragData2;
void func_70ecf(inout highp float arg_781f8) {
    if (MERSUniforms.x > MERSUniforms.w)
    {
        arg_781f8 = 0.501960813999176025390625 + (0.4980392158031463623046875 * MERSUniforms.x);
        return;
    }
    else
    {
        arg_781f8 = 0.4980392158031463623046875 - (0.4980392158031463623046875 * MERSUniforms.w);
        return;
    }
}
void main() {
#ifdef USE_TEXTURES__OFF
    highp vec4 var_cf12b = vec4(1.0);
#endif
#ifdef USE_TEXTURES__ON
    highp vec4 var_cf12b = texture(s_MatTexture, v_texcoord0);
#endif
    if (var_cf12b.w < 0.5)
    {
        discard;
    }
    highp vec4 var_a2360 = var_cf12b;
    highp vec4 var_705a1 = var_a2360 * CurrentColor;
    var_cf12b = var_705a1;
    highp vec3 var_a7e47 = var_705a1.xyz * v_color0.xyz;
    highp float var_f67e1 = var_a7e47.x;
    highp vec4 var_7cd00 = vec4(BlockLightColor.xyz, 0.0);
    highp vec4 var_73c41 = var_7cd00;
    highp vec4 var_26212 = vec4(var_f67e1, var_a7e47.yz, var_cf12b.w * v_color0.w);
    highp vec4 var_33385 = vec4(0.0);
    var_26212.x = var_f67e1;
    var_26212.y = var_a7e47.y;
    var_26212.z = var_a7e47.z;
    highp float var_1d2b2;
    func_70ecf(var_1d2b2);
    var_26212.w = var_1d2b2;
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
    uvec2 var_7d776 = uvec2(uint(clamp(MERSUniforms.z, 0.0, 1.0) * 255.0) & 255u, uint(clamp(MERSUniforms.y, 0.0, 1.0) * 255.0) & 255u);
    bgfx_FragData0 = uvec4((var_7d776.x << 8u) | var_7d776.y, var_a74c0.x, var_a74c0.y, (uint(clamp(TileLightIntensity.y, 0.0, 1.0) * 255.0) | uint(((uint(floor(var_73c41.w * 255.0)) & 1u) != 0u) ? 256 : 0)) | ((((uint(var_6364f.x + var_6364f.z) | uint((var_6364f.y + var_6364f.z) << 1)) | uint(int(any(equal(vec3(var_f1fb7), vec3(-1.0)))) << 2)) & 7u) << uint(9)));
    bgfx_FragData1 = var_26212;
    bgfx_FragData2 = var_33385;
}
