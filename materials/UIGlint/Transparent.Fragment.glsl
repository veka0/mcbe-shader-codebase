#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_GlintTexture;
* - uniform lowp sampler2D s_MatTexture;
*
* Uniforms:
* - uniform vec4 GlintColor;
* - uniform vec4 HudOpacity;
* - uniform vec4 TintColor;
* - uniform vec4 UVOffset;
* - uniform vec4 UVRotation;
* - uniform vec4 UVScale;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_GlintTexture;
uniform highp sampler2D s_MatTexture;
uniform highp vec4 GlintColor;
uniform highp vec4 HudOpacity;
uniform highp vec4 TintColor;
in highp vec2 v_layer1UV;
in highp vec2 v_layer2UV;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec4 var_7a830 = texture(s_MatTexture, v_texcoord0);
    if (var_7a830.w <= 0.00390625)
    {
        discard;
    }
    highp vec4 var_a3c32 = (texture(s_GlintTexture, fract(v_layer1UV)) + texture(s_GlintTexture, fract(v_layer2UV))) * GlintColor;
    var_7a830.x = var_a3c32.x;
    var_7a830.y = var_a3c32.y;
    var_7a830.z = var_a3c32.z;
    highp vec4 var_6a5ab = var_7a830;
    highp vec4 var_4495a = var_6a5ab * TintColor;
    var_7a830 = var_4495a;
    highp vec3 var_10da9 = var_4495a.xyz * var_4495a.xyz;
    var_7a830.x = var_10da9.x;
    var_7a830.y = var_10da9.y;
    var_7a830.z = var_10da9.z;
    highp vec4 var_03be5 = var_7a830;
    highp vec3 var_2eebd = var_03be5.xyz * TintColor.w;
    var_7a830.x = var_2eebd.x;
    var_7a830.y = var_2eebd.y;
    var_7a830.z = var_2eebd.z;
    highp vec4 var_01084 = var_7a830;
    highp vec4 var_d2e6b = var_01084 * HudOpacity.x;
    var_7a830 = var_d2e6b;
    bgfx_FragData0 = var_d2e6b;
}
