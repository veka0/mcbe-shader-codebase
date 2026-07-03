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
* - uniform vec4 TextureSize1;
*/

in vec4 a_texcoord3;
in vec4 a_color0;
in vec4 a_position;
out vec4 v_additional;
out vec4 v_color;
out float v_shaderType;
void main() {
    vec4 var_b39b9 = a_texcoord3;
    vec4 var_d63c2 = a_position;
    float var_70560 = var_d63c2.w;
    var_d63c2.x = (var_d63c2.x * 2.0) - var_70560;
    var_d63c2.y = ((var_70560 - var_d63c2.y) * 2.0) - var_70560;
    v_additional = a_texcoord3;
    v_color = a_color0;
    v_shaderType = var_b39b9.w;
    gl_Position = var_d63c2;
}
