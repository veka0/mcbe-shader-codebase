#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - BLEND_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* MultiColorTint:
* - MULTI_COLOR_TINT__OFF
* - MULTI_COLOR_TINT__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MatTexture;
*
* Uniforms:
* - uniform vec4 ChangeColor;
* - uniform vec4 HudOpacity;
* - uniform vec4 TintColor;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_MatTexture;
#ifdef MULTI_COLOR_TINT__ON
uniform highp vec4 ChangeColor;
#endif
uniform highp vec4 HudOpacity;
uniform highp vec4 TintColor;
in highp vec4 v_color0;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_586c3 = texture(s_MatTexture, v_texcoord0);
#ifdef MULTI_COLOR_TINT__OFF
    highp vec4 var_55cab = var_586c3;
    highp vec3 var_2a8c3 = mix(var_586c3.xyz, var_586c3.xyz * v_color0.xyz, vec3(var_55cab.w));
    var_55cab = vec4(var_2a8c3.x, var_2a8c3.y, var_2a8c3.z, var_586c3.w) * TintColor;
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec2 var_f9d9d = var_586c3.xy;
    highp vec3 var_50f30 = mix((var_586c3.xxx * v_color0.xyz).xyz, var_586c3.yyy * ChangeColor.xyz, vec3(ceil(var_f9d9d.y)));
    highp vec4 var_55cab = vec4(var_50f30.x, var_50f30.y, var_50f30.z, var_586c3.w) * TintColor;
#endif
    var_55cab.w *= HudOpacity.x;
    bgfx_FragColor = var_55cab;
}
