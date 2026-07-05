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
* - uniform vec4 GradientEndColor;
* - uniform vec4 GradientMidColor;
* - uniform vec4 GradientStartColor;
* - uniform vec4 GradientYCoord;
* - uniform vec4 MaskScaleAndOffset;
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
out vec4 v_VaryingParam1;
out vec4 v_zPosition;
void main() {
    vec4 var_7ebde = a_texcoord1;
    vec3 var_92a16 = a_position;
    vec4 var_997ac = vec4(0.0);
    uvec4 var_57f2e = uvec4(vec4(a_texcoord4));
    int var_f554c = int(((var_57f2e.y & 15u) << uint(8)) | var_57f2e.x);
    vec4 var_12588 = vec4(a_position, 1.0) * mat4(Data_VS[var_f554c], Data_VS[var_f554c + 1], Data_VS[var_f554c + 2], Data_VS[var_f554c + 3]);
    vec4 var_038e6;
    if (var_7ebde.w == 2.0)
    {
        var_038e6 = vec4(a_texcoord1.xy, 0.0, 1.0);
    }
    else
    {
        var_038e6 = vec4(a_position, 1.0);
    }
    vec4 var_a8244 = Data_VS[var_f554c + 8];
    var_997ac.x = (var_92a16.x * var_a8244.x) + var_a8244.z;
    var_997ac.y = (var_92a16.y * var_a8244.y) + var_a8244.w;
    float var_70560 = var_12588.w;
    var_12588.x = (var_12588.x * 2.0) - var_70560;
    var_12588.y = ((var_70560 - var_12588.y) * 2.0) - var_70560;
    v_Additional = a_texcoord1;
    v_NoPerspParam = vec4(0.0);
    v_ScreenNormalPosition = a_position;
    v_VaryingData = vec4(a_texcoord4);
    v_VaryingParam0 = var_038e6 * mat4(Data_VS[var_f554c + 4], Data_VS[var_f554c + 5], Data_VS[var_f554c + 6], Data_VS[var_f554c + 7]);
    v_VaryingParam1 = var_997ac;
    v_zPosition = vec4(0.0);
    gl_Position = var_12588;
}
