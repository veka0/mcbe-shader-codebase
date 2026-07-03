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
    highp vec3 var_d251a = normalize(v_texcoord0);
    var_d251a.x *= (-1.0);
    highp vec4 var_e45ae = texture(s_MatTexture, var_d251a);
    highp vec4 var_55afb = var_e45ae;
    bgfx_FragColor = vec4(pow(max(var_e45ae.xyz, vec3(0.0)), vec3(2.2000000476837158203125)), var_55afb.w);
}
