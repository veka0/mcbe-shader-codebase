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
uniform highp vec4 DiscardValue;
#ifdef SOURCE_INPUT_TYPE0__CONSTANT
uniform highp vec4 MatColor0;
#endif
#ifdef SOURCE_INPUT_TYPE1__CONSTANT
uniform highp vec4 MatColor1;
#endif
uniform highp vec4 OverlayColor;
in highp vec4 v_fog;
in highp vec4 v_light;
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) || defined(SOURCE_INPUT_TYPE1__SAMPLED)
in highp vec2 v_texcoord0;
#endif
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
#ifdef SOURCE_INPUT_TYPE1__CONSTANT
    highp vec4 var_44320 = MatColor1;
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__CONSTANT)
    highp vec4 var_b72dd = mix(MatColor1, MatColor0, vec4(clamp(ceil(((var_44320.x + var_44320.y) + var_44320.z) * (1.0 - var_44320.w)), 0.0, 1.0)));
#endif
#ifdef SOURCE_INPUT_TYPE1__SAMPLED
    highp vec4 var_492a3 = texture(s_MatTexture1, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SHARED0)
    highp vec4 var_492a3 = texture(s_MatTexture0, v_texcoord0);
#endif
#if !defined(SOURCE_INPUT_TYPE1__CONSTANT) && (defined(SOURCE_INPUT_TYPE0__SAMPLED) || defined(SOURCE_INPUT_TYPE1__SAMPLED))
    highp vec4 var_48bcc = var_492a3;
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SAMPLED)
    highp vec4 var_b72dd = mix(var_492a3, MatColor0, vec4(clamp(ceil(((var_48bcc.x + var_48bcc.y) + var_48bcc.z) * (1.0 - var_48bcc.w)), 0.0, 1.0)));
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SHARED0)
    highp vec4 var_cb362 = MatColor0;
    highp vec4 var_b72dd = mix(MatColor0, MatColor0, vec4(clamp(ceil(((var_cb362.x + var_cb362.y) + var_cb362.z) * (1.0 - var_cb362.w)), 0.0, 1.0)));
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__CONSTANT)
    highp vec4 var_b72dd = mix(MatColor1, texture(s_MatTexture0, v_texcoord0), vec4(clamp(ceil(((var_44320.x + var_44320.y) + var_44320.z) * (1.0 - var_44320.w)), 0.0, 1.0)));
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED)
    highp vec4 var_b72dd = mix(var_492a3, texture(s_MatTexture0, v_texcoord0), vec4(clamp(ceil(((var_48bcc.x + var_48bcc.y) + var_48bcc.z) * (1.0 - var_48bcc.w)), 0.0, 1.0)));
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SHARED0)
    highp vec4 var_b72dd = mix(var_492a3, var_492a3, vec4(clamp(ceil(((var_48bcc.x + var_48bcc.y) + var_48bcc.z) * (1.0 - var_48bcc.w)), 0.0, 1.0)));
#endif
    if (var_b72dd.w <= DiscardValue.x)
    {
        discard;
    }
    highp vec4 var_281a5 = var_b72dd;
    highp vec4 var_21b35 = OverlayColor;
    highp vec4 var_d77d6 = v_fog;
    highp vec3 var_76654 = mix((mix(var_281a5.xyz, OverlayColor.xyz, vec3(var_21b35.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_d77d6.w));
    var_b72dd = vec4(var_76654.x, var_76654.y, var_76654.z, var_281a5.w);
    bgfx_FragData0 = vec4(var_76654, var_281a5.w);
}
