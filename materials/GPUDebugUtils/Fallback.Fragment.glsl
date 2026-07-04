#version 310 es

/*
* Available Macros:
*
* Passes:
* - FALLBACK_PASS (not used)
* - GPU_VALIDATION_PASS (not used)
* - TDR_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - layout(binding = 0, std430) buffer s_FakeRWBufferBuffer { int s_FakeRWBuffer[]; };
*/

precision mediump float;
precision highp int;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    bgfx_FragColor = vec4(0.0);
}
