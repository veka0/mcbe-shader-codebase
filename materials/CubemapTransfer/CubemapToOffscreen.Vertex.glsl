#version 310 es

/*
* Available Macros:
*
* Passes:
* - CUBEMAP_TO_OFFSCREEN_PASS (not used)
* - FALLBACK_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp samplerCube s_SrcTextureCube;
*
* Uniforms:
* - uniform vec4 CurrentFace;
* - uniform vec4 CurrentMip;
*/

in vec4 a_position;
in vec2 a_texcoord0;
out vec2 v_texCoord;
void main() {
    v_texCoord = a_texcoord0;
    gl_Position = vec4((a_position.xy * 2.0) - vec2(1.0), 0.0, 1.0);
}
