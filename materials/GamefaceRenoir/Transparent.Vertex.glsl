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
out vec4 v_NoPerspParam;
out vec3 v_ScreenNormalPosition;
flat out vec4 v_VaryingData;
out vec4 v_VaryingParam0;
out vec4 v_zPosition;
void main() {
    vec4 var_7ebde = a_texcoord1;
    uvec4 var_7bbc0 = uvec4(vec4(a_texcoord4));
    int var_1c26c = int(((var_7bbc0.y & 15u) << 8u) | var_7bbc0.x);
    vec4 var_12588 = vec4(a_position, 1.0) * mat4(Data_VS[var_1c26c], Data_VS[var_1c26c + 1], Data_VS[var_1c26c + 2], Data_VS[var_1c26c + 3]);
    vec4 var_038e6;
    if (var_7ebde.w == 2.0)
    {
        var_038e6 = vec4(a_texcoord1.xy, 0.0, 1.0);
    }
    else
    {
        var_038e6 = vec4(a_position, 1.0);
    }
    float var_70560 = var_12588.w;
    var_12588.x = (var_12588.x * 2.0) - var_70560;
    var_12588.y = ((var_70560 - var_12588.y) * 2.0) - var_70560;
    v_Additional = a_texcoord1;
    v_NoPerspParam = vec4(0.0);
    v_ScreenNormalPosition = a_position;
    v_VaryingData = vec4(a_texcoord4);
    v_VaryingParam0 = var_038e6 * mat4(Data_VS[var_1c26c + 4], Data_VS[var_1c26c + 5], Data_VS[var_1c26c + 6], Data_VS[var_1c26c + 7]);
    v_zPosition = vec4(0.0);
    gl_Position = var_12588;
}
