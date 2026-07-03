#version 310 es

/*
* Available Macros:
*
* Passes:
* - SCREEN_PASS (not used)
*
* Available Resources:
*/

in vec3 a_position;
in vec2 a_texcoord0;
out vec4 v_color;
void main() {
    v_color = vec4(a_texcoord0, 1.0, 1.0);
    gl_Position = vec4((a_position.xy * 2.0) - vec2(1.0), 0.0, 1.0);
}
