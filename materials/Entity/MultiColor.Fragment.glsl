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
* - SOURCE_INPUT_TYPE2__CONSTANT
* - SOURCE_INPUT_TYPE2__SAMPLED
* - SOURCE_INPUT_TYPE2__SHARED0
* - SOURCE_INPUT_TYPE2__SHARED1
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
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SAMPLED) && !defined(SOURCE_INPUT_TYPE1__SAMPLED)
uniform highp sampler2D s_MatTexture2;
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SAMPLED)
uniform highp sampler2D s_MatTexture1;
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
uniform highp sampler2D s_MatTexture2;
#endif
#ifdef SOURCE_INPUT_TYPE0__CONSTANT
uniform highp vec4 MatColor0;
#endif
#ifdef SOURCE_INPUT_TYPE0__SAMPLED
uniform highp sampler2D s_MatTexture0;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SAMPLED) && !defined(SOURCE_INPUT_TYPE1__SAMPLED)
uniform highp sampler2D s_MatTexture2;
#endif
#ifdef SOURCE_INPUT_TYPE1__CONSTANT
uniform highp vec4 MatColor1;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED)
uniform highp sampler2D s_MatTexture1;
#endif
#ifdef SOURCE_INPUT_TYPE2__CONSTANT
uniform highp vec4 MatColor2;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
uniform highp sampler2D s_MatTexture2;
#endif
uniform highp vec4 OverlayColor;
in highp vec4 v_fog;
in highp vec4 v_light;
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) || defined(SOURCE_INPUT_TYPE1__SAMPLED) || defined(SOURCE_INPUT_TYPE2__SAMPLED)
in highp vec2 v_texcoord0;
#endif
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    highp vec4 var_ff0ca = texture(s_MatTexture2, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SHARED0) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    highp vec4 var_10db1 = texture(s_MatTexture2, v_texcoord0);
#endif
#ifdef SOURCE_INPUT_TYPE0__SAMPLED
    highp vec4 var_63c6d = texture(s_MatTexture0, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE1__CONSTANT) && (defined(SOURCE_INPUT_TYPE0__CONSTANT) || !defined(SOURCE_INPUT_TYPE2__SAMPLED))
    highp vec4 var_93a6a = MatColor1;
#endif
#if defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__CONSTANT)
    highp vec4 var_6b8e9 = MatColor2;
#endif
#if defined(SOURCE_INPUT_TYPE1__SAMPLED) && (defined(SOURCE_INPUT_TYPE0__CONSTANT) || defined(SOURCE_INPUT_TYPE2__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec4 var_ff0ca = texture(s_MatTexture1, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && (defined(SOURCE_INPUT_TYPE2__CONSTANT) || defined(SOURCE_INPUT_TYPE2__SAMPLED))
    highp vec4 var_4c26f = texture(s_MatTexture1, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE2__SAMPLED) && (defined(SOURCE_INPUT_TYPE0__SAMPLED) || defined(SOURCE_INPUT_TYPE1__SAMPLED))
    highp vec4 var_10db1 = texture(s_MatTexture2, v_texcoord0);
#endif
// Approximation, matches 23 cases out of 24
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    highp vec4 var_02614 = var_ff0ca;
#endif
// Approximation, matches 23 cases out of 24
#if defined(SOURCE_INPUT_TYPE1__SAMPLED) && (defined(SOURCE_INPUT_TYPE0__CONSTANT) || defined(SOURCE_INPUT_TYPE2__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec4 var_fed9b = var_ff0ca;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && (defined(SOURCE_INPUT_TYPE1__CONSTANT) || defined(SOURCE_INPUT_TYPE1__SHARED0)) && (defined(SOURCE_INPUT_TYPE1__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED0))
    highp vec4 var_be2c2 = var_63c6d;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && (defined(SOURCE_INPUT_TYPE2__CONSTANT) || defined(SOURCE_INPUT_TYPE2__SAMPLED))
    highp vec4 var_08849 = var_4c26f;
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && (defined(SOURCE_INPUT_TYPE1__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED0))
    highp vec4 var_799c6 = MatColor0;
#endif
#if defined(SOURCE_INPUT_TYPE1__CONSTANT) && (defined(SOURCE_INPUT_TYPE0__SAMPLED) || defined(SOURCE_INPUT_TYPE2__SHARED1)) && (defined(SOURCE_INPUT_TYPE2__SAMPLED) || defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec4 var_78656 = MatColor1;
#endif
#if defined(SOURCE_INPUT_TYPE2__CONSTANT) && !defined(SOURCE_INPUT_TYPE1__CONSTANT)
    highp vec4 var_2d692 = MatColor2;
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    highp vec4 var_f0c90 = var_10db1;
#endif
#if defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED1)
    highp vec4 var_d8891 = var_ff0ca;
#endif
#if defined(SOURCE_INPUT_TYPE2__SAMPLED) && (defined(SOURCE_INPUT_TYPE0__SAMPLED) || defined(SOURCE_INPUT_TYPE1__SHARED0))
    highp vec4 var_9d20d = var_10db1;
#endif
// Approximation, matches 23 cases out of 24
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED0) && !defined(SOURCE_INPUT_TYPE1__CONSTANT)
    highp vec4 var_234e1 = var_63c6d;
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SHARED0) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec4 var_2f81b = MatColor0;
#endif
    highp vec4 var_341fe = OverlayColor;
    highp vec4 var_07019 = v_fog;
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__CONSTANT)
    highp vec3 var_4603e = mix((mix(mix(mix(MatColor0.xyz, MatColor1.xyz, vec3(var_93a6a.w)).xyz, MatColor2.xyz, vec3(var_6b8e9.w)).xyz, OverlayColor.xyz, vec3(var_341fe.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_07019.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    highp vec3 var_4603e = mix((mix(mix(mix(MatColor0.xyz, MatColor1.xyz, vec3(var_93a6a.w)).xyz, var_ff0ca.xyz, vec3(var_02614.w)).xyz, OverlayColor.xyz, vec3(var_341fe.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_07019.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SHARED0)
    highp vec3 var_4603e = mix((mix(mix(mix(MatColor0.xyz, MatColor1.xyz, vec3(var_93a6a.w)).xyz, MatColor0.xyz, vec3(var_799c6.w)).xyz, OverlayColor.xyz, vec3(var_341fe.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_07019.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SHARED1)
    highp vec3 var_4603e = mix((mix(mix(mix(MatColor0.xyz, MatColor1.xyz, vec3(var_93a6a.w)).xyz, MatColor1.xyz, vec3(var_78656.w)).xyz, OverlayColor.xyz, vec3(var_341fe.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_07019.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__CONSTANT)
    highp vec3 var_4603e = mix((mix(mix(mix(MatColor0.xyz, var_ff0ca.xyz, vec3(var_fed9b.w)).xyz, MatColor2.xyz, vec3(var_2d692.w)).xyz, OverlayColor.xyz, vec3(var_341fe.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_07019.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    highp vec3 var_4603e = mix((mix(mix(mix(MatColor0.xyz, var_ff0ca.xyz, vec3(var_fed9b.w)).xyz, var_10db1.xyz, vec3(var_f0c90.w)).xyz, OverlayColor.xyz, vec3(var_341fe.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_07019.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED1)
    highp vec3 var_4603e = mix((mix(mix(mix(MatColor0.xyz, var_ff0ca.xyz, vec3(var_02614.w)).xyz, var_ff0ca.xyz, vec3(var_d8891.w)).xyz, OverlayColor.xyz, vec3(var_341fe.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_07019.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED0)
    highp vec3 var_4603e = mix((mix(mix(mix(MatColor0.xyz, var_ff0ca.xyz, vec3(var_fed9b.w)).xyz, MatColor0.xyz, vec3(var_799c6.w)).xyz, OverlayColor.xyz, vec3(var_341fe.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_07019.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SHARED0) && defined(SOURCE_INPUT_TYPE2__CONSTANT)
    highp vec3 var_4603e = mix((mix(mix(mix(MatColor0.xyz, MatColor0.xyz, vec3(var_799c6.w)).xyz, MatColor2.xyz, vec3(var_2d692.w)).xyz, OverlayColor.xyz, vec3(var_341fe.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_07019.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SHARED0) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    highp vec3 var_4603e = mix((mix(mix(mix(MatColor0.xyz, MatColor0.xyz, vec3(var_799c6.w)).xyz, var_10db1.xyz, vec3(var_9d20d.w)).xyz, OverlayColor.xyz, vec3(var_341fe.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_07019.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SHARED0) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec3 var_4603e = mix((mix(mix(mix(MatColor0.xyz, MatColor0.xyz, vec3(var_799c6.w)).xyz, MatColor0.xyz, vec3(var_2f81b.w)).xyz, OverlayColor.xyz, vec3(var_341fe.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_07019.w));
#endif
#ifdef SOURCE_INPUT_TYPE0__CONSTANT
    bgfx_FragColor = vec4(var_4603e.x, var_4603e.y, var_4603e.z, MatColor0.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__CONSTANT)
    highp vec3 var_4e864 = mix((mix(mix(mix(var_63c6d.xyz, MatColor1.xyz, vec3(var_93a6a.w)).xyz, MatColor2.xyz, vec3(var_6b8e9.w)).xyz, OverlayColor.xyz, vec3(var_341fe.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_07019.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    highp vec3 var_4e864 = mix((mix(mix(mix(var_63c6d.xyz, MatColor1.xyz, vec3(var_78656.w)).xyz, var_10db1.xyz, vec3(var_9d20d.w)).xyz, OverlayColor.xyz, vec3(var_341fe.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_07019.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SHARED0)
    highp vec3 var_4d3f1 = mix((mix(mix(mix(var_63c6d.xyz, MatColor1.xyz, vec3(var_93a6a.w)).xyz, var_63c6d.xyz, vec3(var_be2c2.w)).xyz, OverlayColor.xyz, vec3(var_341fe.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_07019.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SHARED1)
    highp vec3 var_4e864 = mix((mix(mix(mix(var_63c6d.xyz, MatColor1.xyz, vec3(var_93a6a.w)).xyz, MatColor1.xyz, vec3(var_78656.w)).xyz, OverlayColor.xyz, vec3(var_341fe.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_07019.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__CONSTANT)
    highp vec3 var_4e864 = mix((mix(mix(mix(var_63c6d.xyz, var_4c26f.xyz, vec3(var_08849.w)).xyz, MatColor2.xyz, vec3(var_2d692.w)).xyz, OverlayColor.xyz, vec3(var_341fe.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_07019.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SHARED0) && defined(SOURCE_INPUT_TYPE2__CONSTANT)
    highp vec3 var_4d3f1 = mix((mix(mix(mix(var_63c6d.xyz, var_63c6d.xyz, vec3(var_be2c2.w)).xyz, MatColor2.xyz, vec3(var_2d692.w)).xyz, OverlayColor.xyz, vec3(var_341fe.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_07019.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    highp vec3 var_4e864 = mix((mix(mix(mix(var_63c6d.xyz, var_4c26f.xyz, vec3(var_08849.w)).xyz, var_10db1.xyz, vec3(var_9d20d.w)).xyz, OverlayColor.xyz, vec3(var_341fe.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_07019.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED0)
    highp vec3 var_4e864 = mix((mix(mix(mix(var_63c6d.xyz, var_ff0ca.xyz, vec3(var_fed9b.w)).xyz, var_63c6d.xyz, vec3(var_234e1.w)).xyz, OverlayColor.xyz, vec3(var_341fe.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_07019.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED1)
    highp vec3 var_4e864 = mix((mix(mix(mix(var_63c6d.xyz, var_ff0ca.xyz, vec3(var_fed9b.w)).xyz, var_ff0ca.xyz, vec3(var_d8891.w)).xyz, OverlayColor.xyz, vec3(var_341fe.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_07019.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SHARED0) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    highp vec3 var_4d3f1 = mix((mix(mix(mix(var_63c6d.xyz, var_63c6d.xyz, vec3(var_be2c2.w)).xyz, var_10db1.xyz, vec3(var_9d20d.w)).xyz, OverlayColor.xyz, vec3(var_341fe.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_07019.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SHARED0) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec3 var_4d3f1 = mix((mix(mix(mix(var_63c6d.xyz, var_63c6d.xyz, vec3(var_be2c2.w)).xyz, var_63c6d.xyz, vec3(var_234e1.w)).xyz, OverlayColor.xyz, vec3(var_341fe.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_07019.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && (defined(SOURCE_INPUT_TYPE1__CONSTANT) || defined(SOURCE_INPUT_TYPE1__SAMPLED)) && (defined(SOURCE_INPUT_TYPE1__SAMPLED) || !defined(SOURCE_INPUT_TYPE2__SHARED0))
    bgfx_FragColor = vec4(var_4e864.x, var_4e864.y, var_4e864.z, var_63c6d.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && (defined(SOURCE_INPUT_TYPE1__CONSTANT) || defined(SOURCE_INPUT_TYPE1__SHARED0)) && (defined(SOURCE_INPUT_TYPE1__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED0))
    bgfx_FragColor = vec4(var_4d3f1.x, var_4d3f1.y, var_4d3f1.z, var_63c6d.w);
#endif
}
