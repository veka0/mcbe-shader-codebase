#version 310 es

/*
* Available Macros:
*
* Passes:
* - FSR1_COMPUTE_PASS (not used)
* - FSR1_FRAG_PASS (not used)
* - FALLBACK_PASS (not used)
*
* FFXPrecision:
* - FFX_PRECISION__FULL (not used)
* - FFX_PRECISION__HALF (not used)
*
* FSRFilterMode:
* - FSR_FILTER_MODE__BILINEAR (not used)
* - FSR_FILTER_MODE__EASU (not used)
* - FSR_FILTER_MODE__RCAS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_InputTex;
* - uniform lowp sampler2D s_OutputTex;
*
* Uniforms:
* - uniform vec4 FSRConst0;
* - uniform vec4 FSRConst1;
* - uniform vec4 FSRConst2;
* - uniform vec4 FSRConst3;
* - uniform vec4 InputAndOutputResolution;
*/

precision mediump float;
precision highp int;
uniform highp vec4 InputAndOutputResolution;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    ivec2 var_9f883 = ivec2(v_texcoord0 * InputAndOutputResolution.zw);
    bgfx_FragData0 = vec4(vec3(0.9570000171661376953125, 0.2750000059604644775390625, 0.0670000016689300537109375) * step(mod(float(var_9f883.x - var_9f883.y), 16.0) * 0.066666670143604278564453125, 0.0625), 1.0);
}
