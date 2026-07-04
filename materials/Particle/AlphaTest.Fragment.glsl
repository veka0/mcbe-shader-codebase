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
    highp vec4 var_f89cb = v_color0;
    highp vec4 var_ffe0d = texture(s_ParticleTexture, v_texcoord0);
    if (var_ffe0d.w < 0.5)
    {
        discard;
    }
    var_ffe0d *= vec4(v_color0.xyz, var_f89cb.w);
    var_ffe0d.w = 1.0;
    highp vec4 var_d4abf = vec4(var_ffe0d.xyz, var_ffe0d.w);
    highp vec4 var_6ca24 = v_fog;
    highp vec3 var_14685 = mix(var_d4abf.xyz, v_fog.xyz, vec3(var_6ca24.w));
    bgfx_FragColor = vec4(var_14685.x, var_14685.y, var_14685.z, var_d4abf.w);
}
