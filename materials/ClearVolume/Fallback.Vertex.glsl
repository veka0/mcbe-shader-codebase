#version 310 es

/*
* Available Macros:
*
* Passes:
* - CLEAR_PASS (not used)
* - FALLBACK_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2DArray s_Volume;
*
* Uniforms:
* - uniform vec4 ClearValue;
* - uniform vec4 VolumeDimensions;
*/

void main() {
    gl_Position = vec4(0.0);
}
