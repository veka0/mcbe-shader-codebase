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
    mat4 var_69af0 = u_proj;
    var_69af0[2].x += SubPixelOffset.x;
    var_69af0[2].y -= SubPixelOffset.y;
    gl_Position = var_69af0 * (u_view * vec4(a_position, 1.0));
}
