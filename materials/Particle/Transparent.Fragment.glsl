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
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_e966b = v_color0;
    highp vec4 var_6ca24 = v_fog;
    highp vec4 var_de643 = texture(s_ParticleTexture, v_texcoord0) * vec4(v_color0.xyz, var_e966b.w);
    highp vec3 var_2ce89 = mix(var_de643.xyz, v_fog.xyz, vec3(var_6ca24.w));
    highp vec4 var_74ef0 = vec4(var_2ce89.x, var_2ce89.y, var_2ce89.z, var_de643.w);
    highp vec4 var_dc02c = v_fog;
    bgfx_FragColor = vec4(mix(vec4(var_2ce89, var_74ef0.w).xyz, v_fog.xyz, vec3(var_dc02c.w)), var_74ef0.w);
}
