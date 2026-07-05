#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* Instancing:
* - INSTANCING__OFF
* - INSTANCING__ON
*
* Available Resources:
*
* Uniforms:
* - uniform vec4 Data_PS[128];
* - uniform vec4 Data_VS[128];
*/

#ifdef INSTANCING__OFF
uniform mat4 u_model[4];
#endif
uniform vec4 Data_VS[128];
in vec4 a_position;
#ifdef INSTANCING__ON
in vec4 i_data0;
#endif
out vec4 v_ExtraParams;
flat out vec4 v_VaryingData;
void main() {
#ifdef INSTANCING__OFF
    mat4 World = u_model[0];
    uvec4 var_133e3 = floatBitsToUint(World[0]);
#endif
#ifdef INSTANCING__ON
    uvec4 var_133e3 = floatBitsToUint(i_data0);
#endif
    int var_3fc52 = int(((var_133e3.y & 15u) << uint(8)) | var_133e3.x);
    vec4 var_03d4a = vec4(a_position.xy, 0.0, 1.0) * mat4(Data_VS[var_3fc52], Data_VS[var_3fc52 + 1], Data_VS[var_3fc52 + 2], Data_VS[var_3fc52 + 3]);
    float var_70560 = var_03d4a.w;
    var_03d4a.x = (var_03d4a.x * 2.0) - var_70560;
    var_03d4a.y = ((var_70560 - var_03d4a.y) * 2.0) - var_70560;
    v_ExtraParams = vec4(a_position.zw, 0.0, 0.0);
#ifdef INSTANCING__OFF
    v_VaryingData = World[0];
#endif
#ifdef INSTANCING__ON
    v_VaryingData = i_data0;
#endif
    gl_Position = var_03d4a;
}
