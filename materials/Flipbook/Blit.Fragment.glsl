#version 310 es

/*
* Available Macros:
*
* Passes:
* - BLIT_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BlitTexture;
*
* Uniforms:
* - uniform vec4 VBlendControl;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_BlitTexture;
uniform highp vec4 VBlendControl;
in highp vec2 v_texcoord0;
in highp vec2 v_texcoord1;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec4 var_2cfdc = texture(s_BlitTexture, v_texcoord0);
    highp vec4 var_b514a = var_2cfdc;
    highp vec4 var_d6955 = texture(s_BlitTexture, v_texcoord1);
    highp vec4 var_44f15 = var_d6955;
    highp vec4 var_855b6;
    if (var_b514a.w < 0.00999999977648258209228515625)
    {
        var_855b6 = var_d6955;
    }
    else
    {
        highp vec4 var_ac0eb;
        if (var_44f15.w >= 0.00999999977648258209228515625)
        {
            var_ac0eb = mix(var_2cfdc, var_d6955, vec4(VBlendControl.z));
        }
        else
        {
            var_ac0eb = var_2cfdc;
        }
        var_855b6 = var_ac0eb;
    }
    bgfx_FragData0 = var_855b6;
}
