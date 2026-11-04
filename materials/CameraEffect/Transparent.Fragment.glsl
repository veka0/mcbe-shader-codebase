#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* AlphaTest:
* - ALPHA_TEST__OFF
* - ALPHA_TEST__ON_DISCARD_VALUE_BASED
*
* Lit:
* - LIT__OFF
* - LIT__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MatTexture;
*
* Uniforms:
* - uniform vec4 DiscardValue;
* - uniform vec4 FogColor;
* - uniform vec4 FogControl;
* - uniform vec4 HudOpacity;
* - uniform vec4 OverlayColor;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 TileLightColor;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_MatTexture;
#ifdef ALPHA_TEST__ON_DISCARD_VALUE_BASED
uniform highp vec4 DiscardValue;
#endif
uniform highp vec4 HudOpacity;
uniform highp vec4 OverlayColor;
in highp vec4 v_color;
in highp vec4 v_fog;
#ifdef LIT__ON
in highp vec4 v_light;
#endif
centroid in highp vec2 v_texCoords;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
#ifdef ALPHA_TEST__OFF
    highp vec4 var_96ebd = texture(s_MatTexture, v_texCoords);
#endif
#ifdef ALPHA_TEST__ON_DISCARD_VALUE_BASED
    highp vec4 var_83801 = texture(s_MatTexture, v_texCoords);
    if (var_83801.w < DiscardValue.x)
    {
        discard;
    }
    highp vec4 var_96ebd = var_83801;
#endif
#ifdef ALPHA_TEST__OFF
    highp vec4 var_83801 = var_96ebd;
#endif
    highp vec3 var_2a9cf = mix(var_96ebd.xyz, OverlayColor.xyz, vec3(OverlayColor.w));
    var_83801.x = var_2a9cf.x;
    var_83801.y = var_2a9cf.y;
    var_83801.z = var_2a9cf.z;
#ifdef LIT__OFF
    var_83801 = v_color * var_83801;
#endif
#ifdef LIT__ON
    var_83801 = v_color * (var_83801 * v_light);
#endif
    var_83801.w *= HudOpacity.x;
    highp vec4 var_906d5 = var_83801;
    highp vec3 var_c6e56 = mix(var_906d5.xyz, v_fog.xyz, vec3(v_fog.w));
    var_83801.x = var_c6e56.x;
    var_83801.y = var_c6e56.y;
    var_83801.z = var_c6e56.z;
    bgfx_FragData0 = var_83801;
}
