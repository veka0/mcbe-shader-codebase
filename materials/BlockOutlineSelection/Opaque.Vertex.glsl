#version 310 es

/*
* Available Macros:
*
* Passes:
* - OPAQUE_PASS (not used)
*
* Available Resources:
*
* Uniforms:
* - uniform vec4 OutlineColor;
* - uniform vec4 SubPixelOffset;
*/

uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 SubPixelOffset;
in vec3 a_position;
void main() {
    mat4 var_83c3f = u_proj;
    vec4 var_67767 = var_83c3f[2];
    var_67767.x += SubPixelOffset.x;
    var_67767.y -= SubPixelOffset.y;
    mat4 var_7913a = u_proj;
    var_7913a[2] = var_67767;
    gl_Position = var_7913a * (u_view * vec4(a_position, 1.0));
}
