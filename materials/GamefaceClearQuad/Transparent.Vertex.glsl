#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* Available Resources:
*/

in vec4 a_color0;
in vec4 a_position;
out vec4 v_color;
void main() {
    v_color = a_color0;
    gl_Position = a_position;
}
