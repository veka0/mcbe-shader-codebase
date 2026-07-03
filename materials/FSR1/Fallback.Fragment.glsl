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
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    bgfx_FragColor = vec4(0.0);
}
