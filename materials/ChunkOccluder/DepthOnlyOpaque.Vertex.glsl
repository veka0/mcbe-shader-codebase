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
    vec4 var_58502 = u_modelViewProj * vec4(a_position, 1.0);
    var_58502.z = max(var_58502.z, -var_58502.w);
    gl_Position = var_58502;
}
