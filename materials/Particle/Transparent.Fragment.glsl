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
* - uniform vec4 MaterialID;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_ParticleTexture;
in highp vec4 v_color0;
in highp vec4 v_fog;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_e966b = v_color0;
    highp vec4 var_6ca24 = v_fog;
    highp vec4 var_de643 = texture(s_ParticleTexture, v_texcoord0) * vec4(v_color0.xyz, var_e966b.w);
    highp vec3 var_2cb07 = mix(var_de643.xyz, v_fog.xyz, vec3(var_6ca24.w));
    highp vec4 var_89833 = vec4(var_2cb07.x, var_2cb07.y, var_2cb07.z, var_de643.w);
    highp vec4 var_baf55 = vec4(var_2cb07, var_89833.w);
    highp vec4 var_3b1ba = v_fog;
    highp vec3 var_14685 = mix(var_baf55.xyz, v_fog.xyz, vec3(var_3b1ba.w));
    bgfx_FragColor = vec4(var_14685.x, var_14685.y, var_14685.z, var_baf55.w);
}
