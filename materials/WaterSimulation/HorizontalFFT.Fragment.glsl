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
    highp vec2 var_ec871 = v_texcoord0 * WaterResolution.x;
    highp float var_7296a = (floor(var_ec871.x / StockhamFftSubTransformSize.x) * (StockhamFftSubTransformSize.x * 0.5)) + mod(var_ec871.x, StockhamFftSubTransformSize.x * 0.5);
    highp vec2 var_ea76f = texture(s_SimTexture, vec2(var_7296a, var_ec871.y) / u_viewRect.zw).xy;
    highp vec2 var_0ff1c = texture(s_SimTexture, vec2(var_7296a + (WaterResolution.x * 0.5), var_ec871.y) / u_viewRect.zw).xy;
    highp float var_d9bed = (-6.283185482025146484375) * (var_ec871.x / StockhamFftSubTransformSize.x);
    highp float var_26d90 = cos(var_d9bed);
    highp float var_c6742 = sin(var_d9bed);
    bgfx_FragData0 = vec4(var_ea76f.x + ((var_26d90 * var_0ff1c.x) - (var_c6742 * var_0ff1c.y)), var_ea76f.y + ((var_26d90 * var_0ff1c.y) + (var_c6742 * var_0ff1c.x)), 0.0, 0.0);
}
