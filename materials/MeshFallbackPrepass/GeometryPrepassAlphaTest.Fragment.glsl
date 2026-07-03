#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_PASS (not used)
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
* - uniform vec4 CurrentColor;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MERSUniforms;
* - uniform vec4 MaterialID;
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
layout(location = 0) out highp vec4 bgfx_FragData[gl_MaxDrawBuffers];
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
    highp vec4 var_6de71 = vec4(var_f7609.x, var_f7609.y, var_f7609.z, var_f7609.w);
    highp float var_1d2b2;
    func_70ecf(var_1d2b2);
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
    bgfx_FragData[2] = vec4(MERSUniforms.y, TileLightIntensity.x, TileLightIntensity.y, MERSUniforms.z);
}
