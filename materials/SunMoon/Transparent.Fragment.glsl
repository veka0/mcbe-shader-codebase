#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_SunMoonTexture;
*
* Uniforms:
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 SunMoonColor;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_SunMoonTexture;
uniform highp vec4 SunMoonColor;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_c1f25 = SunMoonColor * texture(s_SunMoonTexture, v_texcoord0);
    highp vec4 var_a3d19 = var_c1f25;
    bgfx_FragColor = vec4(var_c1f25.xyz, var_a3d19.w);
}
