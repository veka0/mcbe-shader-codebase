#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - BLEND_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* Grayscale:
* - GRAYSCALE__OFF (not used)
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
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec4 var_4ba9b = texture(s_MatTexture, v_texcoord0);
    highp vec4 var_6aa4d = var_4ba9b;
#ifdef MULTI_COLOR_TINT__OFF
    highp float var_ff5cc = var_6aa4d.w;
    highp vec3 var_c05c0 = mix(var_4ba9b.xyz, var_4ba9b.xyz * v_color0.xyz, vec3(var_ff5cc));
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec2 var_5bae6 = var_4ba9b.xy;
    highp vec3 var_c05c0 = var_4ba9b.xxx * v_color0.xyz;
#endif
    var_6aa4d.x = var_c05c0.x;
    var_6aa4d.y = var_c05c0.y;
    var_6aa4d.z = var_c05c0.z;
#ifdef MULTI_COLOR_TINT__ON
    highp vec4 var_c3ac5 = var_6aa4d;
    highp vec3 var_c928b = mix(var_c3ac5.xyz, var_4ba9b.yyy * ChangeColor.xyz, vec3(ceil(var_5bae6.y)));
    var_6aa4d.x = var_c928b.x;
    var_6aa4d.y = var_c928b.y;
    var_6aa4d.z = var_c928b.z;
#endif
    var_6aa4d *= TintColor;
    var_6aa4d.w *= HudOpacity.x;
    bgfx_FragData0 = var_6aa4d;
}
