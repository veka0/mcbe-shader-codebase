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
uniform highp vec4 StockhamFftSubTransformSize;
uniform highp vec4 WaterResolution;
uniform highp vec4 u_viewRect;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec4 var_37653 = vec4(0.0);
    highp vec2 var_ec871 = v_texcoord0 * WaterResolution.x;
    highp float var_7296a = (floor(var_ec871.x / StockhamFftSubTransformSize.x) * (StockhamFftSubTransformSize.x * 0.5)) + mod(var_ec871.x, StockhamFftSubTransformSize.x * 0.5);
    highp vec2 var_64a73 = texture(s_SimTexture, vec2(var_7296a, var_ec871.y) / u_viewRect.zw).xy;
    highp vec2 var_cd6bc = texture(s_SimTexture, vec2(var_7296a + (WaterResolution.x * 0.5), var_ec871.y) / u_viewRect.zw).xy;
    highp float var_d9bed = (-6.283185482025146484375) * (var_ec871.x / StockhamFftSubTransformSize.x);
    highp float var_f41ec = cos(var_d9bed);
    highp float var_38c2d = sin(var_d9bed);
    var_37653.x = var_64a73.x + ((var_f41ec * var_cd6bc.x) - (var_38c2d * var_cd6bc.y));
    var_37653.y = var_64a73.y + ((var_f41ec * var_cd6bc.y) + (var_38c2d * var_cd6bc.x));
    bgfx_FragData0 = var_37653;
}
