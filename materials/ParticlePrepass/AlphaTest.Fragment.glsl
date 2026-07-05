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
* - uniform lowp sampler2D s_MERSTexture;
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
uniform highp sampler2D s_ParticleTexture;
in highp vec4 v_color0;
in highp vec4 v_fog;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData[gl_MaxDrawBuffers];
void main() {
    highp vec4 var_f89cb = v_color0;
    highp vec4 var_ffe0d = texture(s_ParticleTexture, v_texcoord0);
    if (var_ffe0d.w < 0.5)
    {
        discard;
    }
    var_ffe0d *= vec4(v_color0.xyz, var_f89cb.w);
    var_ffe0d.w = 1.0;
    highp vec4 var_f1e9e = vec4(var_ffe0d.xyz, var_ffe0d.w);
    highp vec4 var_6ca24 = v_fog;
    highp vec3 var_76f40 = mix(var_f1e9e.xyz, v_fog.xyz, vec3(var_6ca24.w));
    bgfx_FragData[0] = vec4(var_76f40.x, var_76f40.y, var_76f40.z, var_f1e9e.w);
    bgfx_FragData[1] = vec4(0.0);
    bgfx_FragData[2] = vec4(0.0);
}
