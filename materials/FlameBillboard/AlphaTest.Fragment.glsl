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
    highp vec4 var_6ca24 = v_fog;
    highp vec4 var_5536a = texture(s_FlameAtlas, v_texcoord0 + UVOffset.xy);
    if (var_5536a.w < 0.5)
    {
        discard;
    }
    highp vec4 var_f1fd0 = var_5536a;
    highp vec3 var_e88fd = mix(var_f1fd0.xyz, v_fog.xyz, vec3(var_6ca24.w));
    var_5536a = vec4(var_e88fd.x, var_e88fd.y, var_e88fd.z, var_f1fd0.w);
    bgfx_FragData0 = vec4(var_e88fd, var_f1fd0.w);
}
