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
    mat4 var_26e67;
    var_26e67[0] = vec4(i_data1.x, i_data2.x, i_data3.x, 0.0);
    var_26e67[1] = vec4(i_data1.y, i_data2.y, i_data3.y, 0.0);
    var_26e67[2] = vec4(i_data1.z, i_data2.z, i_data3.z, 0.0);
    var_26e67[3] = vec4(i_data1.w, i_data2.w, i_data3.w, 1.0);
    gl_Position = u_viewProj * vec4((var_26e67 * vec4(a_position, 1.0)).xyz, 1.0);
#endif
}
