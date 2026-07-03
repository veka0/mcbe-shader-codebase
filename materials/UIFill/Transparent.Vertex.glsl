#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* Available Resources:
*
* Uniforms:
* - uniform vec4 HudOpacity;
* - uniform vec4 TintColor;
*/

uniform mat4 u_modelViewProj;
in vec4 a_color0;
in vec3 a_position;
out vec4 v_color0;
void main() {
    v_color0 = a_color0;
    gl_Position = u_modelViewProj * vec4(a_position, 1.0);
}
