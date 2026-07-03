#version 310 es

/*
* Available Macros:
*
* Passes:
* - STENCIL_WRITE_PASS (not used)
*
* Instancing:
* - INSTANCING__OFF
* - INSTANCING__ON
*
* Available Resources:
*/

#ifdef INSTANCING__OFF
uniform mat4 u_model[4];
#endif
uniform mat4 u_viewProj;
in vec3 a_position;
#ifdef INSTANCING__ON
in vec4 i_data1;
in vec4 i_data2;
in vec4 i_data3;
#endif
void main() {
#ifdef INSTANCING__OFF
    gl_Position = u_viewProj * vec4((u_model[0] * vec4(a_position, 1.0)).xyz, 1.0);
#endif
#ifdef INSTANCING__ON
    vec4 var_78b44 = i_data1;
    vec4 var_e67a8 = i_data2;
    vec4 var_1b7f0 = i_data3;
    mat4 var_a6d58;
    var_a6d58[0] = vec4(var_78b44.x, var_e67a8.x, var_1b7f0.x, 0.0);
    var_a6d58[1] = vec4(var_78b44.y, var_e67a8.y, var_1b7f0.y, 0.0);
    var_a6d58[2] = vec4(var_78b44.z, var_e67a8.z, var_1b7f0.z, 0.0);
    var_a6d58[3] = vec4(var_78b44.w, var_e67a8.w, var_1b7f0.w, 1.0);
    gl_Position = u_viewProj * vec4((var_a6d58 * vec4(a_position, 1.0)).xyz, 1.0);
#endif
}
