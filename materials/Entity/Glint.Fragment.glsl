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
#ifdef SOURCE_INPUT_TYPE0__SAMPLED
uniform highp sampler2D s_MatTexture0;
#endif
uniform highp sampler2D s_MatTexture1;
uniform highp vec4 GlintColor;
#ifdef SOURCE_INPUT_TYPE0__CONSTANT
uniform highp vec4 MatColor0;
#endif
uniform highp vec4 OverlayColor;
uniform highp vec4 TileLightColor;
in highp vec4 v_fog;
in highp vec4 v_layerUv;
in highp vec4 v_light;
#ifdef SOURCE_INPUT_TYPE0__SAMPLED
in highp vec2 v_texcoord0;
#endif
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_c52eb = OverlayColor;
    highp vec4 var_d30fe = v_fog;
    highp vec4 var_a1024 = ((texture(s_MatTexture1, fract(v_layerUv.xy)).xyzx * GlintColor) + (texture(s_MatTexture1, fract(v_layerUv.zw)).xyzx * GlintColor)) * TileLightColor;
    highp vec4 var_fc575 = var_a1024;
#ifdef SOURCE_INPUT_TYPE0__CONSTANT
    bgfx_FragColor = vec4(var_a1024.xyz * var_a1024.xyz, abs(var_fc575.w)) + vec4(mix((mix(MatColor0.xyz, OverlayColor.xyz, vec3(var_c52eb.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_d30fe.w)), 0.0);
#endif
#ifdef SOURCE_INPUT_TYPE0__SAMPLED
    bgfx_FragColor = vec4(var_a1024.xyz * var_a1024.xyz, abs(var_fc575.w)) + vec4(mix((mix(texture(s_MatTexture0, v_texcoord0).xyz, OverlayColor.xyz, vec3(var_c52eb.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_d30fe.w)), 0.0);
#endif
}
