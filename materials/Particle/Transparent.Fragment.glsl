#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_ParticleTexture;
*
* Uniforms:
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_ParticleTexture;
in highp vec4 v_color0;
in highp vec4 v_fog;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec4 var_eba1c = texture(s_ParticleTexture, v_texcoord0) * vec4(v_color0.xyz, v_color0.w);
    highp vec4 var_4388e = var_eba1c;
    highp vec3 var_c6e56 = mix(var_eba1c.xyz, v_fog.xyz, vec3(v_fog.w));
    var_4388e.x = var_c6e56.x;
    var_4388e.y = var_c6e56.y;
    var_4388e.z = var_c6e56.z;
    highp vec4 var_4b012 = vec4(var_4388e.xyz, var_4388e.w);
    highp vec4 var_72c1b = var_4b012;
    highp vec3 var_8d1a2 = mix(var_4b012.xyz, v_fog.xyz, vec3(v_fog.w));
    var_72c1b.x = var_8d1a2.x;
    var_72c1b.y = var_8d1a2.y;
    var_72c1b.z = var_8d1a2.z;
    bgfx_FragData0 = var_72c1b;
}
