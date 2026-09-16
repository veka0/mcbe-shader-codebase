#version 310 es

/*
* Available Macros:
*
* Passes:
* - BLEND_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_TexColor;
*
* Uniforms:
* - uniform vec4 PaperWhite;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_TexColor;
uniform highp vec4 PaperWhite;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec4 var_1b510 = texture(s_TexColor, v_texcoord0);
    highp vec4 var_cd480 = var_1b510;
    highp vec3 var_4524e = ((transpose(mat3(vec3(0.6274039745330810546875, 0.329281985759735107421875, 0.043313600122928619384765625), vec3(0.06909699738025665283203125, 0.919539988040924072265625, 0.0113612003624439239501953125), vec3(0.01639159955084323883056640625, 0.0880132019519805908203125, 0.895595014095306396484375))) * var_1b510.xyz) * PaperWhite.x) * vec3(9.9999997473787516355514526367188e-05);
    highp vec3 var_c261f = pow((vec3(0.8359375) + (pow(abs(var_4524e), vec3(0.1593017578125)) * 18.8515625)) / (vec3(1.0) + (pow(abs(var_4524e), vec3(0.1593017578125)) * 18.6875)), vec3(78.84375));
    bgfx_FragData0 = vec4(var_c261f.x, var_c261f.y, var_c261f.z, var_cd480.w);
}
