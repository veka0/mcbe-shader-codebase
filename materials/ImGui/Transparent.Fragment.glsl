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

precision mediump float;
precision highp int;
uniform highp sampler2D s_MatTexture;
in highp vec4 v_color;
in highp vec2 v_uv;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    bgfx_FragData0 = v_color * texture(s_MatTexture, v_uv);
}
