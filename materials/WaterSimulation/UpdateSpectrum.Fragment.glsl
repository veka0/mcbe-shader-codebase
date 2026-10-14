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
    highp vec4 var_3ec0c = vec4(0.0);
    highp vec4 var_ce231 = texture(s_SimTexture, v_texcoord0);
    highp vec2 var_c0e75 = (((v_texcoord0 - vec2(0.5)) * 6.283185482025146484375) * WaterResolution.x) / vec2(WaterPatchSize.x);
    highp float var_eec20 = mod((sqrt(G.x * length(var_c0e75)) * fract(sin(dot(var_c0e75, vec2(25.9796009063720703125, 156.46600341796875))) * 43758.546875)) * WaterSimTime.x, 6.283185482025146484375);
    highp vec2 var_3a539 = var_ce231.xy;
    highp vec2 var_6552a = var_ce231.zw;
    highp float var_70460 = cos(var_eec20);
    highp float var_33f43 = sin(var_eec20);
    highp float var_2c792 = -var_33f43;
    var_3ec0c.x = ((var_3a539.x * var_70460) - (var_3a539.y * var_33f43)) + ((var_6552a.x * var_70460) - (var_6552a.y * var_2c792));
    var_3ec0c.y = ((var_3a539.x * var_33f43) + (var_3a539.y * var_70460)) + ((var_6552a.x * var_2c792) + (var_6552a.y * var_70460));
    bgfx_FragData0 = var_3ec0c;
}
