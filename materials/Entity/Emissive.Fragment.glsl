#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - ALPHA_TEST_COLOR_MASK_PASS (not used)
* - ALPHA_TEST_COLOR_MASK_GLINT_PASS (not used)
* - ALPHA_TEST_COLOR_MASK_MULTIPLICATIVE_TINT_PASS (not used)
* - ALPHA_TEST_EMISSIVE_PASS (not used)
* - ALPHA_TEST_EMISSIVE_ONLY_PASS (not used)
* - ALPHA_TEST_GLINT_PASS (not used)
* - ALPHA_TEST_MASKED_OVERWRITE_PASS (not used)
* - ALPHA_TEST_MULTI_COLOR_PASS (not used)
* - BASE_COLOR_PASS (not used)
* - COLOR_MASK_PASS (not used)
* - EMISSIVE_PASS (not used)
* - GLINT_PASS (not used)
* - MULTI_COLOR_PASS (not used)
*
* SourceInputType0:
* - SOURCE_INPUT_TYPE0__CONSTANT
* - SOURCE_INPUT_TYPE0__SAMPLED
*
* SourceInputType1:
* - SOURCE_INPUT_TYPE1__CONSTANT (not used)
* - SOURCE_INPUT_TYPE1__SAMPLED (not used)
* - SOURCE_INPUT_TYPE1__SHARED0 (not used)
*
* SourceInputType2:
* - SOURCE_INPUT_TYPE2__CONSTANT (not used)
* - SOURCE_INPUT_TYPE2__SAMPLED (not used)
* - SOURCE_INPUT_TYPE2__SHARED0 (not used)
* - SOURCE_INPUT_TYPE2__SHARED1 (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MatTexture0;
* - uniform lowp sampler2D s_MatTexture1;
* - uniform lowp sampler2D s_MatTexture2;
*
* Uniforms:
* - uniform mat4 Bones[8];
* - uniform vec4 DiscardValue;
* - uniform vec4 FogColor;
* - uniform vec4 FogControl;
* - uniform vec4 GlintColor;
* - uniform vec4 MatColor0;
* - uniform vec4 MatColor1;
* - uniform vec4 MatColor2;
* - uniform vec4 OverlayColor;
* - uniform vec4 TileLightColor;
* - uniform vec4 TileLightIntensity;
* - uniform vec4 UVAnimation;
* - uniform vec4 UVScale;
*/

precision mediump float;
precision highp int;
#ifdef SOURCE_INPUT_TYPE0__CONSTANT
uniform highp vec4 MatColor0;
#endif
#ifdef SOURCE_INPUT_TYPE0__SAMPLED
uniform highp sampler2D s_MatTexture0;
#endif
uniform highp vec4 OverlayColor;
in highp vec4 v_fog;
in highp vec4 v_light;
#ifdef SOURCE_INPUT_TYPE0__SAMPLED
in highp vec2 v_texcoord0;
#endif
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
#ifdef SOURCE_INPUT_TYPE0__CONSTANT
    highp vec4 var_26660 = MatColor0;
#endif
#ifdef SOURCE_INPUT_TYPE0__SAMPLED
    highp vec4 var_a4eac = texture(s_MatTexture0, v_texcoord0);
    highp vec4 var_26660 = var_a4eac;
#endif
    highp vec4 var_5b8d6 = OverlayColor;
#ifdef SOURCE_INPUT_TYPE0__CONSTANT
    highp vec3 var_517d1 = mix(MatColor0.xyz, OverlayColor.xyz, vec3(var_5b8d6.w));
#endif
#ifdef SOURCE_INPUT_TYPE0__SAMPLED
    highp vec3 var_517d1 = mix(var_a4eac.xyz, OverlayColor.xyz, vec3(var_5b8d6.w));
#endif
    var_26660.x = var_517d1.x;
    var_26660.y = var_517d1.y;
    var_26660.z = var_517d1.z;
    highp vec4 var_6702e = var_26660;
    highp float var_e2805 = var_6702e.w;
    highp vec3 var_037d8 = mix(var_26660.xyz, var_26660.xyz * v_light.xyz, vec3(var_e2805));
    var_6702e.x = var_037d8.x;
    var_6702e.y = var_037d8.y;
    var_6702e.z = var_037d8.z;
    highp vec4 var_72c1b = var_6702e;
    highp vec3 var_c6e56 = mix(var_6702e.xyz, v_fog.xyz, vec3(v_fog.w));
    var_72c1b.x = var_c6e56.x;
    var_72c1b.y = var_c6e56.y;
    var_72c1b.z = var_c6e56.z;
    bgfx_FragData0 = var_72c1b;
}
