#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_OPAQUE_PASS (not used)
*
* Available Resources:
*/

uniform mat4 u_model[4];
uniform mat4 u_viewProj;
in vec3 a_position;
void main() {
    gl_Position = u_viewProj * vec4((u_model[0] * vec4(a_position, 1.0)).xyz, 1.0);
}
