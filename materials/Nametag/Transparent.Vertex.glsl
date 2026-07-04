#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* Available Resources:
*
* Uniforms:
* - uniform vec4 CurrentColor;
* - uniform vec4 OverlayColor;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 ZShiftValue;
*/

uniform mat4 u_model[4];
uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 SubPixelOffset;
uniform vec4 ZShiftValue;
in vec4 a_color0;
in vec3 a_position;
out vec4 v_clipPosition;
out vec4 v_color;
out vec3 v_worldPos;
void main() {
    vec4 var_8815e = u_model[0] * vec4(a_position, 1.0);
    mat4 var_83c3f = u_proj;
    vec4 var_67767 = var_83c3f[2];
    var_67767.x += SubPixelOffset.x;
    var_67767.y -= SubPixelOffset.y;
    mat4 var_cbf5d = u_proj;
    var_cbf5d[2] = var_67767;
    vec4 var_79258 = var_cbf5d * (u_view * vec4(var_8815e.xyz, 1.0));
    vec4 var_b1929 = var_79258;
    var_b1929.z += ZShiftValue.x;
    v_clipPosition = var_79258;
    v_color = a_color0;
    v_worldPos = var_8815e.xyz;
    gl_Position = var_b1929;
}
