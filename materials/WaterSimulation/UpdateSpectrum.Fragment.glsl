#version 310 es

/*
* Available Macros:
*
* Passes:
* - HORIZONTAL_FFT_PASS (not used)
* - INIT_SPECTRUM_PASS (not used)
* - UPDATE_SPECTRUM_PASS (not used)
* - VERTICAL_FFT_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_SimTexture;
*
* Uniforms:
* - uniform vec4 G;
* - uniform vec4 StockhamFftSubTransformSize;
* - uniform vec4 WaterPatchSize;
* - uniform vec4 WaterResolution;
* - uniform vec4 WaterSimTime;
* - uniform vec4 WaterWaveDampening;
* - uniform vec4 WaterWindAlignment;
* - uniform vec4 WaterWindVelocity;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_SimTexture;
uniform highp vec4 G;
uniform highp vec4 WaterPatchSize;
uniform highp vec4 WaterResolution;
uniform highp vec4 WaterSimTime;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec4 var_ce231 = texture(s_SimTexture, v_texcoord0);
    highp vec2 var_c0e75 = (((v_texcoord0 - vec2(0.5)) * 6.283185482025146484375) * WaterResolution.x) / vec2(WaterPatchSize.x);
    highp float var_eec20 = mod((sqrt(G.x * length(var_c0e75)) * fract(sin(dot(var_c0e75, vec2(25.9796009063720703125, 156.46600341796875))) * 43758.546875)) * WaterSimTime.x, 6.283185482025146484375);
    highp vec2 var_f9bfe = var_ce231.xy;
    highp vec2 var_214d5 = var_ce231.zw;
    highp float var_1317c = cos(var_eec20);
    highp float var_ce8c8 = sin(var_eec20);
    highp float var_ff6bc = -var_ce8c8;
    bgfx_FragData0 = vec4(((var_f9bfe.x * var_1317c) - (var_f9bfe.y * var_ce8c8)) + ((var_214d5.x * var_1317c) - (var_214d5.y * var_ff6bc)), ((var_f9bfe.x * var_ce8c8) + (var_f9bfe.y * var_1317c)) + ((var_214d5.x * var_ff6bc) + (var_214d5.y * var_1317c)), 0.0, 0.0);
}
