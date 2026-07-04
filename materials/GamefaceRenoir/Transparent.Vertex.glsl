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
* - uniform lowp sampler2D s_Texture0;
* - uniform lowp sampler2D s_Texture1;
* - uniform lowp sampler2D s_Texture2;
*
* Uniforms:
* - uniform mat4 CoordTransformVS;
* - uniform vec4 GradientEndColor;
* - uniform vec4 GradientMidColor;
* - uniform vec4 GradientStartColor;
* - uniform vec4 GradientYCoord;
* - uniform vec4 MaskScaleAndOffset;
* - uniform vec4 ShaderType;
* - uniform mat4 Transform;
*/

uniform mat4 CoordTransformVS;
uniform mat4 Transform;
uniform vec4 MaskScaleAndOffset;
in vec4 a_texcoord3;
in vec4 a_color0;
in vec4 a_position;
out vec4 v_additional;
out vec4 v_color;
out vec4 v_screenPosition;
out vec4 v_varyingParam0;
out vec4 v_varyingParam1;
void main() {
    vec4 var_2363d = a_texcoord3;
    vec4 var_37bed = a_position;
    vec4 var_ee2f1 = vec4(0.0);
    vec4 var_3ccf0 = a_position * Transform;
    vec4 var_21c2d;
    if (var_2363d.w == 2.0)
    {
        var_21c2d = vec4(a_texcoord3.xy, 0.0, 1.0);
    }
    else
    {
        var_21c2d = a_position;
    }
    var_ee2f1.x = (var_37bed.x * MaskScaleAndOffset.x) + MaskScaleAndOffset.z;
    var_ee2f1.y = (var_37bed.y * MaskScaleAndOffset.y) + MaskScaleAndOffset.w;
    float var_70560 = var_3ccf0.w;
    var_3ccf0.x = (var_3ccf0.x * 2.0) - var_70560;
    var_3ccf0.y = ((var_70560 - var_3ccf0.y) * 2.0) - var_70560;
    v_additional = a_texcoord3;
    v_color = a_color0;
    v_screenPosition = a_position;
    v_varyingParam0 = var_21c2d * CoordTransformVS;
    v_varyingParam1 = var_ee2f1;
    gl_Position = var_3ccf0;
}
