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

void main() {
    gl_Position = vec4(0.0);
}
