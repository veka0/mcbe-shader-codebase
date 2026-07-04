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
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
#ifdef SOURCE_INPUT_TYPE0__CONSTANT
    highp vec4 var_5a1c2 = MatColor0;
#endif
#ifdef SOURCE_INPUT_TYPE0__SAMPLED
    highp vec4 var_5a1c2 = texture(s_MatTexture0, v_texcoord0);
#endif
    if ((var_5a1c2.w <= 0.0) || (var_5a1c2.w >= 1.0))
    {
        discard;
    }
    highp vec4 var_a2517 = var_5a1c2;
    highp vec4 var_54e30 = OverlayColor;
    highp vec3 var_a02ec = mix(var_a2517.xyz, OverlayColor.xyz, vec3(var_54e30.w));
    highp vec4 var_1c0ec = vec4(var_a02ec.x, var_a02ec.y, var_a02ec.z, var_a2517.w);
    highp float var_e2805 = var_1c0ec.w;
    highp vec3 var_53779 = mix(var_a02ec.xyz, var_a02ec.xyz * v_light.xyz, vec3(var_e2805));
    var_1c0ec = vec4(var_53779.x, var_53779.y, var_53779.z, var_a2517.w);
    highp vec4 var_6ca24 = v_fog;
    highp vec3 var_76a37 = mix(var_53779.xyz, v_fog.xyz, vec3(var_6ca24.w));
    var_5a1c2 = vec4(var_76a37.x, var_76a37.y, var_76a37.z, var_a2517.w);
    bgfx_FragColor = vec4(var_76a37, var_a2517.w);
}
