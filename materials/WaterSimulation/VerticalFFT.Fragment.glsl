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
    highp vec2 var_37570 = v_texcoord0 * WaterResolution.x;
    highp float var_d8c66 = (floor(var_37570.y / StockhamFftSubTransformSize.x) * (StockhamFftSubTransformSize.x * 0.5)) + mod(var_37570.y, StockhamFftSubTransformSize.x * 0.5);
    highp vec2 var_96306 = texture(s_SimTexture, vec2(var_37570.x, var_d8c66) / u_viewRect.zw).xy;
    highp vec2 var_14e23 = texture(s_SimTexture, vec2(var_37570.x, var_d8c66 + (WaterResolution.x * 0.5)) / u_viewRect.zw).xy;
    highp float var_8c06e = (-6.283185482025146484375) * (var_37570.y / StockhamFftSubTransformSize.x);
    highp float var_26d90 = cos(var_8c06e);
    highp float var_c6742 = sin(var_8c06e);
    bgfx_FragData0 = vec4(var_96306.x + ((var_26d90 * var_14e23.x) - (var_c6742 * var_14e23.y)), var_96306.y + ((var_26d90 * var_14e23.y) + (var_c6742 * var_14e23.x)), 0.0, 0.0);
}
