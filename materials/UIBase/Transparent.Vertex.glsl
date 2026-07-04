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
in vec3 a_position;
void main() {
    gl_Position = u_modelViewProj * vec4(a_position, 1.0);
}
