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
* - uniform vec4 MaterialID;
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
    vec4 var_78b44 = i_data1;
    vec4 var_e67a8 = i_data2;
    vec4 var_1b7f0 = i_data3;
    mat4 var_e43a8;
    var_e43a8[0] = vec4(var_78b44.x, var_e67a8.x, var_1b7f0.x, 0.0);
    var_e43a8[1] = vec4(var_78b44.y, var_e67a8.y, var_1b7f0.y, 0.0);
    var_e43a8[2] = vec4(var_78b44.z, var_e67a8.z, var_1b7f0.z, 0.0);
    var_e43a8[3] = vec4(var_78b44.w, var_e67a8.w, var_1b7f0.w, 1.0);
    vec4 var_93fa5 = var_e43a8 * vec4(a_position, 1.0);
#endif
    vec3 var_57752 = var_93fa5.xyz;
    mat4 var_be69c = u_proj;
    var_be69c[2].x += SubPixelOffset.x;
    var_be69c[2].y -= SubPixelOffset.y;
    vec4 var_80820 = a_color0 * CloudColor;
    var_80820.w *= clamp(1.0 - max((length(var_57752) / DistanceControl.x) - 0.89999997615814208984375, 0.0), 0.0, 1.0);
    v_color0 = var_80820;
    v_texcoord0 = a_texcoord0;
    v_worldPos = var_57752;
    gl_Position = var_be69c * (u_view * vec4(var_93fa5.xyz, 1.0));
}
