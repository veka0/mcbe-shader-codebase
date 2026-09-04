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
    highp vec4 var_7f649 = v_color0;
#ifdef USE_TEXTURES__OFF
    highp vec4 var_895bf = vec4(1.0);
#endif
#ifdef USE_TEXTURES__ON
    highp vec4 var_895bf = texture(s_MatTexture, v_texcoord0);
#endif
    if (var_895bf.w < 0.5)
    {
        discard;
    }
    highp vec4 var_a2360 = var_895bf;
    highp vec4 var_9d69b = var_a2360 * CurrentColor;
    var_895bf = var_9d69b;
    highp vec4 var_f7609 = vec4(var_9d69b.xyz * v_color0.xyz, var_895bf.w * var_7f649.w);
    highp vec4 var_7cd00 = vec4(BlockLightColor.xyz, 0.0);
    highp vec4 var_224c9 = var_7cd00;
    highp vec4 var_6bfdc = vec4(var_f7609.x, var_f7609.y, var_f7609.z, var_f7609.w);
    highp float var_1d2b2;
    func_70ecf(var_1d2b2);
    var_6bfdc.w = var_1d2b2;
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
    highp vec3 var_d13a4 = var_7cd00.xyz;
    highp vec3 var_ec82b = var_d13a4;
    highp vec3 var_774df;
    if ((((var_ec82b.x + var_ec82b.y) + var_ec82b.z) < 9.9999997473787516355514526367188e-05) && (TileLightIntensity.x > 9.9999997473787516355514526367188e-05))
    {
        highp vec4 var_0bc6f = vec4(0.0);
        highp float var_88ce0 = TileLightIntensity.x * TileLightIntensity.x;
        var_774df = clamp(vec3(var_88ce0 + (var_0bc6f.x * var_0bc6f.w), (var_88ce0 * ((((var_88ce0 * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_0bc6f.y * var_0bc6f.w), (var_88ce0 * (((var_88ce0 * var_88ce0) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_0bc6f.z * var_0bc6f.w)), vec3(0.0), vec3(1.0));
    }
    else
    {
        var_774df = var_d13a4;
    }
    highp vec3 var_8f0e5 = var_774df * vec3(0.16666667163372039794921875);
    highp vec4 var_f46ce = vec4(var_8f0e5, 0.0039215688593685626983642578125);
    highp vec2 var_8a7dd = max(var_f46ce.xy, var_f46ce.zw);
    highp float var_a7109 = ceil(clamp(max(var_8a7dd.x, var_8a7dd.y), 0.0, 1.0) * 255.0) * 0.0039215688593685626983642578125;
    uvec4 var_63c1c = uvec4(clamp(vec4(var_8f0e5 / vec3(var_a7109), var_a7109), vec4(0.0), vec4(1.0)) * 255.0);
    uvec2 var_768db = var_63c1c.xy;
    uvec2 var_f7a74 = uvec2(var_768db.x & 255u, var_768db.y & 255u);
    uvec2 var_cc1c7 = var_63c1c.zw;
    uvec2 var_8bc3e = uvec2(var_cc1c7.x & 255u, var_cc1c7.y & 255u);
    uvec2 var_34fa8 = uvec2((var_f7a74.x << 8u) | var_f7a74.y, (var_8bc3e.x << 8u) | var_8bc3e.y);
    uint var_4c32f = uint(floor(var_224c9.w * 255.0));
    uvec2 var_bc2e5 = uvec2(uint(clamp(MERSUniforms.z, 0.0, 1.0) * 255.0) & 255u, uint(clamp(MERSUniforms.y, 0.0, 1.0) * 255.0) & 255u);
    bgfx_FragData0 = uvec4((var_bc2e5.x << 8u) | var_bc2e5.y, var_34fa8.x, var_34fa8.y, (uint(clamp(TileLightIntensity.y, 0.0, 1.0) * 255.0) | uint(((var_4c32f & 1u) != 0u) ? 256 : 0)) | uint(((var_4c32f & 2u) != 0u) ? 512 : 0));
    bgfx_FragData1 = var_6bfdc;
    bgfx_FragData2 = vec4(var_532c2, var_603d8.xy - var_d0ebc.xy);
}
