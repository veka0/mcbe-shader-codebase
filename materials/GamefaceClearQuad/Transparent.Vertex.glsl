#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* Available Resources:
*/

in vec4 a_texcoord1;
in vec3 a_position;
out vec4 v_Additional;
out vec4 v_Color_;
out vec4 v_NoPerspParam;
out vec3 v_ScreenNormalPosition;
flat out vec4 v_VaryingData;
out vec4 v_zPosition;
void main() {
    v_Additional = vec4(0.0);
    v_Color_ = a_texcoord1;
    v_NoPerspParam = vec4(0.0);
    v_ScreenNormalPosition = vec3(0.0);
    v_VaryingData = vec4(0.0);
    v_zPosition = vec4(0.0);
    gl_Position = vec4(a_position, 1.0);
}
