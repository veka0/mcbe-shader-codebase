#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* showDF:
* - SHOW_DF__OFF (not used)
* - SHOW_DF__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_Texture0;
* - uniform lowp sampler2D s_Texture1;
* - uniform lowp sampler2D s_Texture2;
*
* Uniforms:
* - uniform vec4 PrimProps0;
* - uniform vec4 PrimProps1;
* - uniform vec4 ShaderType;
* - uniform mat4 Transform;
*/

uniform mat4 Transform;
in vec4 a_texcoord3;
in vec4 a_color0;
in vec4 a_position;
out vec4 v_additional;
out vec4 v_color;
out vec4 v_screenPosition;
void main() {
    vec4 var_3ccf0 = a_position * Transform;
    float var_70560 = var_3ccf0.w;
    var_3ccf0.x = (var_3ccf0.x * 2.0) - var_70560;
    var_3ccf0.y = ((var_70560 - var_3ccf0.y) * 2.0) - var_70560;
    v_additional = a_texcoord3;
    v_color = a_color0;
    v_screenPosition = a_position;
    gl_Position = var_3ccf0;
}
