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
    highp vec4 var_f89cb = v_color0;
    highp vec4 var_e9859 = texture(s_ParticleTexture, v_texcoord0);
    if (var_e9859.w < 0.5)
    {
        discard;
    }
    var_e9859 *= vec4(v_color0.xyz, var_f89cb.w);
    var_e9859.w = 1.0;
    highp vec4 var_f6e07 = v_fog;
    bgfx_FragData0 = vec4(mix(vec4(var_e9859.xyz, var_e9859.w).xyz, v_fog.xyz, vec3(var_f6e07.w)), var_e9859.w);
}
