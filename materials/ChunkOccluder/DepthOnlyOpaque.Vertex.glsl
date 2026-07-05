#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_OPAQUE_PASS (not used)
*
* Available Resources:
*/

uniform mat4 u_modelViewProj;
in vec3 a_position;
void main() {
    vec4 var_619a2 = u_modelViewProj * vec4(a_position, 1.0);
    var_619a2.z = max(var_619a2.z, -1.0);
    gl_Position = var_619a2;
}
