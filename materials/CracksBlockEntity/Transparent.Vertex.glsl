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
* - uniform lowp sampler2D s_CracksTexture;
*
* Uniforms:
* - uniform mat4 Bones[8];
* - uniform vec4 SubPixelOffset;
* - uniform vec4 UVScale;
*/

uniform mat4 Bones[8];
uniform mat4 u_model[4];
uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 SubPixelOffset;
uniform vec4 UVScale;
in float a_indices;
in vec3 a_position;
in vec2 a_texcoord0;
out vec2 v_texcoord0;
void main() {
    mat4 var_b058a = u_proj;
    var_b058a[2].x += SubPixelOffset.x;
    var_b058a[2].y -= SubPixelOffset.y;
    v_texcoord0 = a_texcoord0 * UVScale.xy;
    gl_Position = var_b058a * (u_view * vec4(((u_model[0] * Bones[int(a_indices)]) * vec4(a_position, 1.0)).xyz, 1.0));
}
