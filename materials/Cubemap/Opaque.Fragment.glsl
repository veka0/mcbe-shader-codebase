#version 310 es

/*
* Available Macros:
*
* Passes:
* - OPAQUE_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp samplerCube s_MatTexture;
*
* Uniforms:
* - uniform mat4 CubemapRotation;
* - uniform vec4 SubPixelOffset;
*/

precision mediump float;
precision highp int;
uniform highp samplerCube s_MatTexture;
in highp vec3 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec3 var_afcc1 = normalize(v_texcoord0);
    var_afcc1.x *= (-1.0);
    bgfx_FragColor = texture(s_MatTexture, var_afcc1);
}
