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
* - uniform vec4 CloudColor;
* - uniform vec4 DistanceControl;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 SubPixelOffset;
*/

#ifdef INSTANCING__OFF
uniform mat4 u_model[4];
#endif
uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 CloudColor;
uniform vec4 DistanceControl;
uniform vec4 SubPixelOffset;
in vec4 a_color0;
in vec3 a_position;
in vec2 a_texcoord0;
#ifdef INSTANCING__ON
in vec4 i_data1;
in vec4 i_data2;
in vec4 i_data3;
#endif
out vec4 v_color0;
out vec2 v_texcoord0;
out vec3 v_worldPos;
void main() {
#ifdef INSTANCING__OFF
    vec4 var_93fa5 = u_model[0] * vec4(a_position, 1.0);
#endif
#ifdef INSTANCING__ON
    mat4 var_53a7d;
    var_53a7d[0] = vec4(i_data1.x, i_data2.x, i_data3.x, 0.0);
    var_53a7d[1] = vec4(i_data1.y, i_data2.y, i_data3.y, 0.0);
    var_53a7d[2] = vec4(i_data1.z, i_data2.z, i_data3.z, 0.0);
    var_53a7d[3] = vec4(i_data1.w, i_data2.w, i_data3.w, 1.0);
    vec4 var_93fa5 = var_53a7d * vec4(a_position, 1.0);
#endif
    vec3 var_57752 = var_93fa5.xyz;
    mat4 var_83c3f = u_proj;
    vec4 var_67767 = var_83c3f[2];
    var_67767.x += SubPixelOffset.x;
    var_67767.y -= SubPixelOffset.y;
    mat4 var_8e1af = u_proj;
    var_8e1af[2] = var_67767;
    vec4 var_80820 = a_color0 * CloudColor;
    var_80820.w *= clamp(1.0 - max((length(var_57752) / DistanceControl.x) - 0.89999997615814208984375, 0.0), 0.0, 1.0);
    v_color0 = var_80820;
    v_texcoord0 = a_texcoord0;
    v_worldPos = var_57752;
    gl_Position = var_8e1af * (u_view * vec4(var_93fa5.xyz, 1.0));
}
