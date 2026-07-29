#version 310 es

/*
* Available Macros:
*
* Passes:
* - FALLBACK_PASS (not used)
* - SCATTERING_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2DArray s_LightingBuffer;
* - uniform lowp sampler2DArray s_ScatteringBuffer;
*
* Uniforms:
* - uniform vec4 VolumeDimensions;
* - uniform vec4 VolumeNearFar;
*/

precision mediump float;
precision highp int;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    bgfx_FragData0 = vec4(0.0);
}
