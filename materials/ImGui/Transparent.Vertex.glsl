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
* - uniform lowp sampler2D s_MatTexture;
*
* Uniforms:
* - uniform mat4 ImGuiProj;
*/

uniform mat4 ImGuiProj;
in vec4 a_color0;
in vec2 a_position;
in vec2 a_texcoord0;
out vec4 v_color;
out vec2 v_uv;
void main() {
    vec2 var_b3122 = a_texcoord0;
    v_color = a_color0;
    v_uv = vec2(var_b3122.x, var_b3122.y);
    gl_Position = ImGuiProj * vec4(a_position, 0.0, 1.0);
}
