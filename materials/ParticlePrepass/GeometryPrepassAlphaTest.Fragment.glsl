#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - GEOMETRY_PREPASS_ALPHA_TEST_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MERTexture;
* - uniform lowp sampler2D s_NormalTexture;
* - uniform lowp sampler2D s_ParticleTexture;
*
* Uniforms:
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MERSUniforms;
* - uniform vec4 MaterialID;
* - uniform vec4 PBRTextureFlags;
* - uniform vec4 SubPixelOffset;
*/

precision mediump float;
precision highp int;
uniform highp mat4 u_model[4];
uniform highp mat4 u_prevViewProj;
uniform highp mat4 u_viewProj;
uniform highp sampler2D s_MERTexture;
uniform highp sampler2D s_NormalTexture;
uniform highp sampler2D s_ParticleTexture;
uniform highp vec4 MERSUniforms;
uniform highp vec4 PBRTextureFlags;
uniform highp vec4 u_prevWorldPosOffset;
in highp vec2 v_ambientLight;
in highp vec4 v_color0;
in highp vec4 v_fog;
in highp vec3 v_normal;
in highp vec2 v_texcoord0;
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragData[gl_MaxDrawBuffers];
void func_fd1b4(inout highp vec4 arg_07931, inout bool arg_5e3ed) {
    if (arg_07931.w < 0.5)
    {
        arg_5e3ed = true;
        return;
    }
    arg_5e3ed = false;
}
void func_343f7(inout highp float arg_8dfc0, inout highp float arg_38773) {
    if (arg_8dfc0 > MERSUniforms.w)
    {
        arg_38773 = 0.501960813999176025390625 + (0.4980392158031463623046875 * arg_8dfc0);
        return;
    }
    else
    {
        arg_38773 = 0.4980392158031463623046875 - (0.4980392158031463623046875 * MERSUniforms.w);
        return;
    }
}
void main() {
    highp vec4 var_e966b = v_color0;
    highp vec4 var_6ca24 = v_fog;
    highp vec4 var_4f8bf = texture(s_ParticleTexture, v_texcoord0) * vec4(v_color0.xyz, var_e966b.w);
    bool var_c9230;
    func_fd1b4(var_4f8bf, var_c9230);
    if (var_c9230)
    {
        discard;
    }
    highp vec4 var_592a0 = var_4f8bf;
    highp vec3 var_17844 = mix(var_592a0.xyz, v_fog.xyz, vec3(var_6ca24.w));
    var_4f8bf = vec4(var_17844.x, var_17844.y, var_17844.z, var_592a0.w);
    int var_f3b79 = int(PBRTextureFlags.x);
    highp float var_7fda0;
    highp float var_833ea;
    highp float var_6d437;
    if ((var_f3b79 & 1) == 1)
    {
        highp vec3 var_f3e08 = texture(s_MERTexture, v_texcoord0).xyz;
        var_6d437 = var_f3e08.z;
        var_833ea = var_f3e08.y;
        var_7fda0 = var_f3e08.x;
    }
    else
    {
        var_6d437 = MERSUniforms.z;
        var_833ea = MERSUniforms.y;
        var_7fda0 = MERSUniforms.x;
    }
    highp vec3 var_256a8;
    if ((var_f3b79 & 4) == 4)
    {
        var_256a8 = (u_model[0] * vec4((texture(s_NormalTexture, v_texcoord0).xyz * 2.0) - vec3(1.0), 0.0)).xyz;
    }
    else
    {
        var_256a8 = v_normal;
    }
    highp vec4 var_39c01 = vec4(var_17844, var_4f8bf.w);
    highp vec2 var_f3dd7 = v_ambientLight;
    highp vec4 var_6de71 = vec4(var_39c01.x, var_39c01.y, var_39c01.z, var_39c01.w);
    highp float var_e206e;
    func_343f7(var_7fda0, var_e206e);
    var_6de71.w = var_e206e;
    highp vec3 var_089df = normalize(var_256a8);
    highp vec3 var_cd914 = var_089df;
    highp vec2 var_645ff = var_089df.xy * (1.0 / ((abs(var_cd914.x) + abs(var_cd914.y)) + abs(var_cd914.z)));
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
    highp vec4 var_eaa92 = u_prevViewProj * vec4(v_worldPos - u_prevWorldPosOffset.xyz, 1.0);
    highp vec4 var_96bda = var_eaa92;
    highp float var_9ef48 = var_96bda.w;
    highp vec4 var_82203 = ((var_eaa92 / vec4(var_9ef48)) * 0.5) + vec4(0.5);
    var_96bda = var_82203;
    highp vec2 var_ec5a5 = var_7ed87.xy - var_82203.xy;
    bgfx_FragData[0] = var_6de71;
    bgfx_FragData[1] = vec4(var_5a694.x, var_5a694.y, var_ec5a5.x, var_ec5a5.y);
    bgfx_FragData[2] = vec4(var_833ea, var_f3dd7.x, var_f3dd7.y, var_6d437);
}
