#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - BLEND_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* MultiColorTint:
* - MULTI_COLOR_TINT__OFF (not used)
* - MULTI_COLOR_TINT__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MatTexture;
*
* Uniforms:
* - uniform vec4 ChangeColor;
* - uniform vec4 HudOpacity;
* - uniform vec4 TintColor;
*/

uniform mat4 u_modelViewProj;
in vec4 a_color0;
in vec3 a_position;
in vec2 a_texcoord0;
out vec4 v_color0;
out vec2 v_texcoord0;
void main() {
    v_color0 = a_color0;
    v_texcoord0 = a_texcoord0;
    gl_Position = u_modelViewProj * vec4(a_position, 1.0);
}
