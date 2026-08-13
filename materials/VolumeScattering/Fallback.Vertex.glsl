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
* - uniform lowp sampler2DArray s_ScatteringBufferIn;
* - uniform lowp sampler2DArray s_ScatteringBufferOut;
*
* Uniforms:
* - uniform vec4 VolumeDimensions;
* - uniform vec4 VolumeNearFar;
*/

void main() {
    gl_Position = vec4(0.0);
}
