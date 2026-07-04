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
    highp vec4 var_2b4f7 = v_color0;
    highp vec4 var_8a9e5 = texture(s_MatTexture, v_texcoord0);
#ifdef MULTI_COLOR_TINT__OFF
    highp vec4 var_92da2 = var_8a9e5;
    highp vec3 var_993b3 = mix(var_8a9e5.xyz, var_8a9e5.xyz * v_color0.xyz, vec3(var_92da2.w)).xyz * var_2b4f7.w;
    var_92da2 = vec4(var_993b3.x, var_993b3.y, var_993b3.z, var_8a9e5.w) * TintColor;
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec2 var_60d6d = var_8a9e5.xy;
    highp vec3 var_4c902 = mix((var_8a9e5.xxx * v_color0.xyz).xyz, var_8a9e5.yyy * ChangeColor.xyz, vec3(ceil(var_60d6d.y))).xyz * var_2b4f7.w;
    highp vec4 var_92da2 = vec4(var_4c902.x, var_4c902.y, var_4c902.z, var_8a9e5.w) * TintColor;
#endif
    var_92da2.w *= HudOpacity.x;
    bgfx_FragColor = var_92da2;
}
