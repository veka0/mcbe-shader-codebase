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
    highp vec4 var_68f82 = v_color0;
    highp vec4 var_12a12 = texture(s_MatTexture, v_texcoord0);
#ifdef MULTI_COLOR_TINT__OFF
    highp vec4 var_7b560 = var_12a12;
    highp vec3 var_20015 = mix(var_12a12.xyz, var_12a12.xyz * v_color0.xyz, vec3(var_7b560.w));
    var_7b560 = vec4(var_20015.x, var_20015.y, var_20015.z, var_12a12.w);
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec2 var_f9d9d = var_12a12.xy;
    highp vec3 var_82ef0 = mix((var_12a12.xxx * v_color0.xyz).xyz, var_12a12.yyy * ChangeColor.xyz, vec3(ceil(var_f9d9d.y)));
    highp vec4 var_7b560 = vec4(var_82ef0.x, var_82ef0.y, var_82ef0.z, var_12a12.w);
#endif
    if (var_68f82.w > 0.0)
    {
        var_7b560.w = ceil(var_7b560.w);
    }
    var_7b560 *= TintColor;
    var_7b560.w *= HudOpacity.x;
    bgfx_FragColor = var_7b560;
}
