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

precision mediump float;
precision highp int;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    bgfx_FragData0 = vec4(0.0);
}
