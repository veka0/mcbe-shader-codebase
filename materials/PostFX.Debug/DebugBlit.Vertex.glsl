#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEBUG_BLIT_PASS (not used)
*
* Available Resources:
*
* Uniforms:
* - uniform vec4 ClipPlanes;
* - uniform vec4 DebugMode;
*/

in vec4 a_position;
in vec2 a_texcoord0;
out vec2 v_texcoord0;
void main() {
    v_texcoord0 = vec2(a_texcoord0.x, a_texcoord0.y);
    gl_Position = vec4((a_position.xy * 2.0) - vec2(1.0), 0.0, 1.0);
}
