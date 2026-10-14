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
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec4 var_4d251 = texture(s_FlameAtlas, v_texcoord0 + UVOffset.xy);
    if (var_4d251.w < 0.5)
    {
        discard;
    }
    highp vec4 var_906d5 = var_4d251;
    highp vec3 var_c6e56 = mix(var_906d5.xyz, v_fog.xyz, vec3(v_fog.w));
    var_4d251.x = var_c6e56.x;
    var_4d251.y = var_c6e56.y;
    var_4d251.z = var_c6e56.z;
    bgfx_FragData0 = var_4d251;
}
