#version 310 es

/*
* Available Macros:
*
* Passes:
* - OPAQUE_PASS (not used)
* - RASTERIZED_OPAQUE_PASS (not used)
* - RASTERIZED_TRANSPARENT_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* Available Resources:
*
* Uniforms:
* - uniform vec4 CameraDirection;
* - uniform vec4 MatColor;
*/

uniform mat4 u_modelViewProj;
in vec3 a_normal;
in vec3 a_position;
in vec2 a_texcoord0;
out vec3 v_normal;
out vec2 v_texcoord0;
void main() {
    v_normal = a_normal;
    v_texcoord0 = a_texcoord0;
    gl_Position = u_modelViewProj * vec4(a_position, 1.0);
}
