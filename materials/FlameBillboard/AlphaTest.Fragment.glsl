#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - RASTERIZED_ALPHA_TEST_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_FlameAtlas;
*
* Uniforms:
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 UVOffset;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_FlameAtlas;
uniform highp vec4 UVOffset;
in highp vec4 v_fog;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_6ca24 = v_fog;
    highp vec4 var_dbc16 = texture(s_FlameAtlas, v_texcoord0 + UVOffset.xy);
    if (var_dbc16.w < 0.5)
    {
        discard;
    }
    highp vec4 var_d0db0 = var_dbc16;
    highp vec3 var_42372 = mix(var_d0db0.xyz, v_fog.xyz, vec3(var_6ca24.w));
    highp vec4 var_bec98 = vec4(var_42372.x, var_42372.y, var_42372.z, var_d0db0.w);
    var_dbc16 = var_bec98;
    bgfx_FragColor = var_bec98;
}
