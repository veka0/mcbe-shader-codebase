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
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec4 var_277a1 = SunMoonColor * texture(s_SunMoonTexture, v_texcoord0);
    highp vec4 var_171b1 = var_277a1;
    bgfx_FragData0 = vec4(var_277a1.xyz, var_171b1.w);
}
