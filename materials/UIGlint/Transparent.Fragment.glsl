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
    highp vec4 var_2a160 = texture(s_MatTexture, v_texcoord0);
    if (var_2a160.w <= 0.00390625)
    {
        discard;
    }
    highp vec4 var_eeca4 = (texture(s_GlintTexture, fract(v_layer1UV)) + texture(s_GlintTexture, fract(v_layer2UV))) * GlintColor;
    highp vec4 var_fc82d = var_2a160;
    highp vec4 var_b0958 = vec4(var_eeca4.x, var_eeca4.y, var_eeca4.z, var_fc82d.w) * TintColor;
    highp vec3 var_c4547 = (var_b0958.xyz * var_b0958.xyz).xyz * TintColor.w;
    highp vec4 var_37270 = vec4(var_c4547.x, var_c4547.y, var_c4547.z, var_b0958.w) * HudOpacity.x;
    var_2a160 = var_37270;
    bgfx_FragData0 = var_37270;
}
