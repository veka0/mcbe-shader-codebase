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
* - SOURCE_INPUT_TYPE1__CONSTANT
* - SOURCE_INPUT_TYPE1__SAMPLED
* - SOURCE_INPUT_TYPE1__SHARED0
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
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SAMPLED)
uniform highp sampler2D s_MatTexture1;
#endif
#ifdef SOURCE_INPUT_TYPE0__SAMPLED
uniform highp sampler2D s_MatTexture0;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED)
uniform highp sampler2D s_MatTexture1;
#endif
uniform highp sampler2D s_MatTexture2;
uniform highp vec4 GlintColor;
#ifdef SOURCE_INPUT_TYPE0__CONSTANT
uniform highp vec4 MatColor0;
#endif
#ifdef SOURCE_INPUT_TYPE1__CONSTANT
uniform highp vec4 MatColor1;
#endif
uniform highp vec4 OverlayColor;
uniform highp vec4 TileLightColor;
in highp vec4 v_fog;
in highp vec4 v_layerUv;
in highp vec4 v_light;
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) || defined(SOURCE_INPUT_TYPE1__SAMPLED)
in highp vec2 v_texcoord0;
#endif
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
#ifdef SOURCE_INPUT_TYPE1__SAMPLED
    highp vec4 var_943c3 = texture(s_MatTexture1, v_texcoord0);
#endif
#ifdef SOURCE_INPUT_TYPE0__CONSTANT
    highp vec4 var_92827 = MatColor0;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && !defined(SOURCE_INPUT_TYPE1__SHARED0)
    highp vec4 var_92827 = texture(s_MatTexture0, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SHARED0)
    highp vec4 var_943c3 = texture(s_MatTexture0, v_texcoord0);
    highp vec4 var_92827 = var_943c3;
#endif
    if (var_92827.w <= 0.0)
    {
        discard;
    }
    highp vec4 var_46c40 = var_92827;
    highp float var_0a4b5 = var_46c40.w;
#ifdef SOURCE_INPUT_TYPE1__CONSTANT
    highp vec3 var_6ba0e = mix(var_92827.xyz, var_92827.xyz * MatColor1.xyz, vec3(var_0a4b5));
#endif
#if !defined(SOURCE_INPUT_TYPE1__CONSTANT) && (defined(SOURCE_INPUT_TYPE0__SAMPLED) || defined(SOURCE_INPUT_TYPE1__SAMPLED))
    highp vec3 var_6ba0e = mix(var_92827.xyz, var_92827.xyz * var_943c3.xyz, vec3(var_0a4b5));
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SHARED0)
    highp vec3 var_6ba0e = mix(var_92827.xyz, var_92827.xyz * MatColor0.xyz, vec3(var_0a4b5));
#endif
    highp vec4 var_b626b = vec4(var_6ba0e.x, var_6ba0e.y, var_6ba0e.z, var_92827.w);
    var_46c40 = var_b626b;
    highp vec4 var_8dd6c = var_b626b;
#ifdef SOURCE_INPUT_TYPE1__CONSTANT
    highp vec4 var_a42dd = MatColor1;
#endif
#if !defined(SOURCE_INPUT_TYPE1__CONSTANT) && (defined(SOURCE_INPUT_TYPE0__SAMPLED) || defined(SOURCE_INPUT_TYPE1__SAMPLED))
    highp vec4 var_a42dd = var_943c3;
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SHARED0)
    highp vec4 var_a42dd = MatColor0;
#endif
    var_8dd6c.w *= var_a42dd.w;
    highp vec4 var_67487 = OverlayColor;
    highp vec4 var_27484 = v_fog;
    highp vec4 var_e6442 = ((texture(s_MatTexture2, fract(v_layerUv.xy)).xyzx * GlintColor) + (texture(s_MatTexture2, fract(v_layerUv.zw)).xyzx * GlintColor)) * TileLightColor;
    highp vec4 var_40943 = var_e6442;
    highp vec4 var_da12a = vec4(var_e6442.xyz * var_e6442.xyz, abs(var_40943.w)) + vec4(mix((mix(var_8dd6c.xyz, OverlayColor.xyz, vec3(var_67487.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_27484.w)), 0.0);
    var_92827 = var_da12a;
    bgfx_FragData0 = var_da12a;
}
