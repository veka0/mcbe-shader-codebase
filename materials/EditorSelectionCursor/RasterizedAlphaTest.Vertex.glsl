#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - RASTERIZED_ALPHA_TEST_PASS (not used)
* - RASTERIZED_TRANSPARENT_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* Available Resources:
*
* Uniforms:
* - uniform vec4 FrameTime;
* - uniform vec4 MatColor;
*/

uniform mat4 u_modelViewProj;
uniform vec4 FrameTime;
in vec4 a_position;
out float v_w;
void main() {
    v_w = a_position.w + (FrameTime.x * 0.5);
    gl_Position = u_modelViewProj * vec4(a_position.xyz, 1.0);
}
