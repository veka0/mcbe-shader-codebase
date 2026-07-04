#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_txBuffer;
* - uniform lowp sampler2D s_txBuffer1;
* - uniform lowp sampler2D s_txBuffer2;
* - uniform lowp sampler2D s_txBuffer3;
* - uniform lowp sampler2D s_txBuffer4;
*
* Uniforms:
* - uniform vec4 Data_PS[128];
* - uniform vec4 Data_VS[128];
* - uniform vec4 UVTransform[5];
*/

uniform vec4 Data_VS[128];
in vec4 a_texcoord1;
in uvec4 a_texcoord4;
in vec3 a_position;
out vec4 v_Additional;
out vec4 v_Color_;
out vec4 v_NoPerspParam;
out vec3 v_ScreenNormalPosition;
flat out vec4 v_VaryingData;
out vec4 v_zPosition;
void main() {
    uvec4 var_7bbc0 = uvec4(vec4(a_texcoord4));
    int var_a178f = int(((var_7bbc0.y & 15u) << 8u) | var_7bbc0.x);
    vec4 var_12588 = vec4(a_position, 1.0) * mat4(Data_VS[var_a178f], Data_VS[var_a178f + 1], Data_VS[var_a178f + 2], Data_VS[var_a178f + 3]);
    float var_70560 = var_12588.w;
    var_12588.x = (var_12588.x * 2.0) - var_70560;
    var_12588.y = ((var_70560 - var_12588.y) * 2.0) - var_70560;
    v_Additional = a_texcoord1;
    v_Color_ = vec4(0.0);
    v_NoPerspParam = a_texcoord1;
    v_ScreenNormalPosition = a_position;
    v_VaryingData = vec4(a_texcoord4);
    v_zPosition = vec4(0.0);
    gl_Position = var_12588;
}
