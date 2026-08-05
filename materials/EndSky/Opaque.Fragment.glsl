#version 310 es

/*
* Available Macros:
*
* Passes:
* - OPAQUE_PASS (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_SkyTexture;
*
* Uniforms:
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 SkyColor;
* - uniform mat4 UV0Transform;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_SkyTexture;
uniform highp vec4 SkyColor;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_3cd15 = SkyColor * texture(s_SkyTexture, v_texcoord0);
    highp vec4 var_a3d19 = var_3cd15;
    bgfx_FragColor = vec4(var_3cd15.xyz, var_a3d19.w);
}
