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
#ifdef SOURCE_INPUT_TYPE0__SAMPLED
    highp vec4 var_a6d23 = texture(s_MatTexture0, v_texcoord0);
#endif
    highp vec4 var_5b8d6 = OverlayColor;
#ifdef SOURCE_INPUT_TYPE0__CONSTANT
    highp vec3 var_99c58 = mix(MatColor0.xyz, OverlayColor.xyz, vec3(var_5b8d6.w));
    highp vec4 var_edeb5 = vec4(var_99c58.x, var_99c58.y, var_99c58.z, MatColor0.w);
#endif
#ifdef SOURCE_INPUT_TYPE0__SAMPLED
    highp vec3 var_99c58 = mix(var_a6d23.xyz, OverlayColor.xyz, vec3(var_5b8d6.w));
    highp vec4 var_edeb5 = vec4(var_99c58.x, var_99c58.y, var_99c58.z, var_a6d23.w);
#endif
    highp float var_e2805 = var_edeb5.w;
    highp vec3 var_840b4 = mix(var_99c58.xyz, var_99c58.xyz * v_light.xyz, vec3(var_e2805));
#ifdef SOURCE_INPUT_TYPE0__CONSTANT
    var_edeb5 = vec4(var_840b4.x, var_840b4.y, var_840b4.z, MatColor0.w);
#endif
#ifdef SOURCE_INPUT_TYPE0__SAMPLED
    var_edeb5 = vec4(var_840b4.x, var_840b4.y, var_840b4.z, var_a6d23.w);
#endif
    highp vec4 var_4d687 = v_fog;
#ifdef SOURCE_INPUT_TYPE0__CONSTANT
    bgfx_FragData0 = vec4(mix(var_840b4.xyz, v_fog.xyz, vec3(var_4d687.w)), MatColor0.w);
#endif
#ifdef SOURCE_INPUT_TYPE0__SAMPLED
    bgfx_FragData0 = vec4(mix(var_840b4.xyz, v_fog.xyz, vec3(var_4d687.w)), var_a6d23.w);
#endif
}
