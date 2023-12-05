#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS
* - ALPHA_TEST_COLOR_MASK_PASS
* - ALPHA_TEST_COLOR_MASK_GLINT_PASS
* - ALPHA_TEST_COLOR_MASK_MULTIPLICATIVE_TINT_PASS
* - ALPHA_TEST_EMISSIVE_PASS
* - ALPHA_TEST_EMISSIVE_ONLY_PASS
* - ALPHA_TEST_GLINT_PASS
* - ALPHA_TEST_MASKED_OVERWRITE_PASS
* - ALPHA_TEST_MULTI_COLOR_PASS
* - BASE_COLOR_PASS
* - COLOR_MASK_PASS
* - EMISSIVE_PASS
* - GLINT_PASS
* - MULTI_COLOR_PASS
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
*/

#if GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif
#define attribute in
#define varying in
out vec4 bgfx_FragColor;
varying vec4 v_fog;
varying vec4 v_layerUv;
varying vec4 v_light;
varying vec2 v_texcoord0;
struct NoopSampler {
    int noop;
};

#if defined(ALPHA_TEST_COLOR_MASK_GLINT_PASS)|| defined(ALPHA_TEST_GLINT_PASS)|| defined(GLINT_PASS)|| defined(SOURCE_INPUT_TYPE0__SAMPLED)|| defined(SOURCE_INPUT_TYPE1__SAMPLED)|| defined(SOURCE_INPUT_TYPE2__SAMPLED)
vec4 textureSample(mediump sampler2D _sampler, vec2 _coord) {
    return texture(_sampler, _coord);
}
vec4 textureSample(mediump sampler3D _sampler, vec3 _coord) {
    return texture(_sampler, _coord);
}
vec4 textureSample(mediump samplerCube _sampler, vec3 _coord) {
    return texture(_sampler, _coord);
}
vec4 textureSample(mediump sampler2D _sampler, vec2 _coord, float _lod) {
    return textureLod(_sampler, _coord, _lod);
}
vec4 textureSample(mediump sampler3D _sampler, vec3 _coord, float _lod) {
    return textureLod(_sampler, _coord, _lod);
}
vec4 textureSample(mediump sampler2DArray _sampler, vec3 _coord) {
    return texture(_sampler, _coord);
}
vec4 textureSample(mediump sampler2DArray _sampler, vec3 _coord, float _lod) {
    return textureLod(_sampler, _coord, _lod);
}
vec4 textureSample(NoopSampler noopsampler, vec2 _coord) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec3 _coord) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec2 _coord, float _lod) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec3 _coord, float _lod) {
    return vec4(0, 0, 0, 0);
}
#endif
struct NoopImage2D {
    int noop;
};

struct NoopImage3D {
    int noop;
};

struct rayQueryKHR {
    int noop;
};

struct accelerationStructureKHR {
    int noop;
};

uniform vec4 u_viewRect;
uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 FogControl;
uniform vec4 u_viewTexel;
uniform mat4 u_invView;
uniform mat4 u_invProj;
uniform mat4 u_viewProj;
uniform vec4 OverlayColor;
uniform mat4 u_invViewProj;
uniform mat4 u_prevViewProj;
uniform mat4 u_model[4];
uniform mat4 u_modelView;
uniform mat4 u_modelViewProj;
uniform vec4 u_prevWorldPosOffset;
uniform vec4 u_alphaRef4;
uniform mat4 Bones[8];
uniform vec4 FogColor;
uniform vec4 DiscardValue;
uniform vec4 GlintColor;
uniform vec4 UVAnimation;
uniform vec4 MatColor0;
uniform vec4 MatColor1;
uniform vec4 MatColor2;
uniform vec4 TileLightColor;
uniform vec4 TileLightIntensity;
uniform vec4 UVScale;
vec4 ViewRect;
mat4 Proj;
mat4 View;
vec4 ViewTexel;
mat4 InvView;
mat4 InvProj;
mat4 ViewProj;
mat4 InvViewProj;
mat4 PrevViewProj;
mat4 WorldArray[4];
mat4 World;
mat4 WorldView;
mat4 WorldViewProj;
vec4 PrevWorldPosOffset;
vec4 AlphaRef4;
float AlphaRef;
struct VertexInput {
    int boneId;
    vec4 normal;
    vec3 position;
    vec2 texcoord0;
};

struct VertexOutput {
    vec4 position;
    vec4 fog;
    vec4 layerUv;
    vec4 light;
    vec2 texcoord0;
};

struct FragmentInput {
    vec4 fog;
    vec4 layerUv;
    vec4 light;
    vec2 texcoord0;
};

struct FragmentOutput {
    vec4 Color0;
};

uniform lowp sampler2D s_MatTexture0;
uniform lowp sampler2D s_MatTexture1;
uniform lowp sampler2D s_MatTexture2;
void Base(inout vec4 pixel, vec4 source) {
    pixel = source;
}
#if ! defined(ALPHA_TEST_EMISSIVE_ONLY_PASS)&& ! defined(ALPHA_TEST_EMISSIVE_PASS)&& ! defined(EMISSIVE_PASS)
void Tint_Rgb(inout vec4 pixel, vec4 source) {
    pixel.rgb = pixel.rgb * source.rgb;
}
#endif
#if defined(ALPHA_TEST_COLOR_MASK_GLINT_PASS)|| defined(ALPHA_TEST_COLOR_MASK_MULTIPLICATIVE_TINT_PASS)|| defined(ALPHA_TEST_COLOR_MASK_PASS)|| defined(COLOR_MASK_PASS)
void Tint_Alpha(inout vec4 pixel, vec4 source) {
    pixel.a = pixel.a * source.a;
}
#endif
void Blend_ComponentAlpha_Rgb(inout vec4 pixel, vec4 source) {
    pixel.rgb = mix(pixel.rgb, source.rgb, source.a);
}
#ifdef ALPHA_TEST_MASKED_OVERWRITE_PASS
void ReplaceIf_ColorMask(inout vec4 pixel, vec4 source) {
    float mask = ceil((source.r + source.g + source.b) * (1.0 - source.a));
    pixel = mix(source, pixel, clamp(mask, 0.0, 1.0));
}
#endif
#if defined(ALPHA_TEST_GLINT_PASS)|| defined(ALPHA_TEST_MASKED_OVERWRITE_PASS)|| defined(ALPHA_TEST_PASS)
void Discard_LessEqual(float alpha, float value) {
    if (alpha <= value) {
        discard;
    }
}
#endif
#if defined(ALPHA_TEST_COLOR_MASK_GLINT_PASS)|| defined(ALPHA_TEST_COLOR_MASK_MULTIPLICATIVE_TINT_PASS)|| defined(ALPHA_TEST_COLOR_MASK_PASS)|| defined(ALPHA_TEST_EMISSIVE_ONLY_PASS)|| defined(ALPHA_TEST_EMISSIVE_PASS)|| defined(COLOR_MASK_PASS)|| defined(EMISSIVE_PASS)
void BlendTint_CurrentAlpha_Rgb(inout vec4 pixel, vec4 source) {
    pixel.rgb = mix(pixel.rgb, pixel.rgb * source.rgb, pixel.a);
}
#endif
#if defined(ALPHA_TEST_COLOR_MASK_MULTIPLICATIVE_TINT_PASS)|| defined(ALPHA_TEST_MULTI_COLOR_PASS)
void BlendSourceTint_ComponentAlpha_Rgb(inout vec4 pixel, vec4 source, vec4 tint) {
    source.rgb *= tint.rgb;
    Blend_ComponentAlpha_Rgb(pixel, source);
}
#endif
#if defined(ALPHA_TEST_COLOR_MASK_GLINT_PASS)|| defined(ALPHA_TEST_COLOR_MASK_MULTIPLICATIVE_TINT_PASS)|| defined(ALPHA_TEST_COLOR_MASK_PASS)
void Discard(float alpha) {
    if (alpha <= 0.0) {
        discard;
    }
}
#endif
#if defined(ALPHA_TEST_COLOR_MASK_GLINT_PASS)|| defined(ALPHA_TEST_COLOR_MASK_MULTIPLICATIVE_TINT_PASS)|| defined(ALPHA_TEST_COLOR_MASK_PASS)|| defined(COLOR_MASK_PASS)
void BlendTint_CurrentAlpha_Rgb_Tint_Alpha(inout vec4 pixel, vec4 source) {
    BlendTint_CurrentAlpha_Rgb(pixel, source);
    Tint_Alpha(pixel, source);
}
#endif
#if defined(ALPHA_TEST_COLOR_MASK_GLINT_PASS)|| defined(ALPHA_TEST_GLINT_PASS)|| defined(GLINT_PASS)
void Glint(inout vec4 pixel, vec4 layerUV, sampler2D glintTexture) {
    vec4 tex1 = textureSample(glintTexture, fract(layerUV.xy)).rgbr * GlintColor;
    vec4 tex2 = textureSample(glintTexture, fract(layerUV.zw)).rgbr * GlintColor;
    vec4 glint = (tex1 + tex2) * TileLightColor;
    pixel = vec4(glint.rgb * glint.rgb, abs(glint.a)) + vec4(pixel.rgb, 0.0);
}
#endif
#ifdef ALPHA_TEST_COLOR_MASK_MULTIPLICATIVE_TINT_PASS
void BlendSourceTint_ComponentAlpha_Rgb_Discard(inout vec4 pixel, vec4 source, vec4 tint) {
    BlendSourceTint_ComponentAlpha_Rgb(pixel, source, tint);
    Discard(pixel.a + source.a);
}
#endif
#ifdef ALPHA_TEST_EMISSIVE_PASS
void Discard_Rgba(vec4 pixel) {
    if ((pixel.r + pixel.g + pixel.b + pixel.a) <= 0.0) {
        discard;
    }
}
#endif
#ifdef ALPHA_TEST_EMISSIVE_ONLY_PASS
void Discard_ZeroOne(float alpha) {
    if (alpha <= 0.0 || alpha >= 1.0) {
        discard;
    }
}
#endif
#ifdef ALPHA_TEST_MULTI_COLOR_PASS
void ReplaceIf_ComponentAlpha_Rgb(inout vec4 pixel, vec4 source) {
    pixel.rgb = mix(pixel.rgb, source.rgb, ceil(source.a));
}
void Discard_AlphaMask(float alpha, float value, float sourceAlpha) {
    if (alpha <= value && sourceAlpha <= 0.0) {
        discard;
    }
}
void ReplaceIf_ComponentAlpha_Rgb_BlendSourceTint(inout vec4 pixel, vec4 source, vec4 tint) {
    vec4 color = source;
    BlendSourceTint_ComponentAlpha_Rgb(color, source, tint);
    ReplaceIf_ComponentAlpha_Rgb(pixel, color);
}
void Blend_ComponentAlpha_Rgb_Discard_AlphaMask(inout vec4 pixel, vec4 source, float discardValue) {
    Blend_ComponentAlpha_Rgb(pixel, source);
    Discard_AlphaMask(pixel.a, discardValue, source.a);
}
#endif
vec4 SourceInput0(vec2 uv) {
    #ifdef SOURCE_INPUT_TYPE0__CONSTANT
    return MatColor0;
    #endif
    #ifdef SOURCE_INPUT_TYPE0__SAMPLED
    return textureSample(s_MatTexture0, uv);
    #endif
}
#ifndef SOURCE_INPUT_TYPE1__SHARED0
vec4 SourceInput1(vec2 uv) {
    #ifdef SOURCE_INPUT_TYPE1__CONSTANT
    return MatColor1;
    #endif
    #ifdef SOURCE_INPUT_TYPE1__SAMPLED
    return textureSample(s_MatTexture1, uv);
    #endif
}
#endif
#if defined(SOURCE_INPUT_TYPE2__CONSTANT)|| defined(SOURCE_INPUT_TYPE2__SAMPLED)
vec4 SourceInput2(vec2 uv) {
    #ifdef SOURCE_INPUT_TYPE2__CONSTANT
    return MatColor2;
    #endif
    #ifdef SOURCE_INPUT_TYPE2__SAMPLED
    return textureSample(s_MatTexture2, uv);
    #endif
}
#endif
void GetSourceInput(vec2 uv, inout vec4 source0) {
    source0 = SourceInput0(uv);
}
void GetSourceInput(vec2 uv, inout vec4 source0, inout vec4 source1) {
    GetSourceInput(uv, source0);
    #ifndef SOURCE_INPUT_TYPE1__SHARED0
    source1 = SourceInput1(uv);
    #endif
    #ifdef SOURCE_INPUT_TYPE1__SHARED0
    source1 = source0;
    #endif
}
void GetSourceInput(vec2 uv, inout vec4 source0, inout vec4 source1, inout vec4 source2) {
    GetSourceInput(uv, source0, source1);
    #if defined(SOURCE_INPUT_TYPE2__CONSTANT)|| defined(SOURCE_INPUT_TYPE2__SAMPLED)
    source2 = SourceInput2(uv);
    #endif
    #ifdef SOURCE_INPUT_TYPE2__SHARED0
    source2 = source0;
    #endif
    #ifdef SOURCE_INPUT_TYPE2__SHARED1
    source2 = source1;
    #endif
}
#if ! defined(ALPHA_TEST_EMISSIVE_ONLY_PASS)&& ! defined(ALPHA_TEST_EMISSIVE_PASS)&& ! defined(EMISSIVE_PASS)
void OverlayLightingFog(inout vec4 pixel, FragmentInput fragInput) {
    Blend_ComponentAlpha_Rgb(pixel, OverlayColor);
    Tint_Rgb(pixel, fragInput.light);
    Blend_ComponentAlpha_Rgb(pixel, fragInput.fog);
}
#endif
#if defined(ALPHA_TEST_EMISSIVE_ONLY_PASS)|| defined(ALPHA_TEST_EMISSIVE_PASS)|| defined(EMISSIVE_PASS)
void OverlayEmissiveFog(inout vec4 pixel, FragmentInput fragInput) {
    Blend_ComponentAlpha_Rgb(pixel, OverlayColor);
    BlendTint_CurrentAlpha_Rgb(pixel, fragInput.light);
    Blend_ComponentAlpha_Rgb(pixel, fragInput.fog);
}
#endif
void Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    vec4 pixel = vec4(1, 1, 1, 1);
    #if defined(ALPHA_TEST_EMISSIVE_ONLY_PASS)|| defined(ALPHA_TEST_EMISSIVE_PASS)|| defined(ALPHA_TEST_GLINT_PASS)|| defined(ALPHA_TEST_PASS)|| defined(BASE_COLOR_PASS)|| defined(EMISSIVE_PASS)|| defined(GLINT_PASS)
    vec4 sourceInput0;
    GetSourceInput(fragInput.texcoord0, sourceInput0);
    #endif
    #if defined(ALPHA_TEST_COLOR_MASK_GLINT_PASS)|| defined(ALPHA_TEST_COLOR_MASK_PASS)|| defined(ALPHA_TEST_MASKED_OVERWRITE_PASS)|| defined(COLOR_MASK_PASS)
    vec4 sourceInput0, sourceInput1;
    GetSourceInput(fragInput.texcoord0, sourceInput0, sourceInput1);
    #endif
    #if defined(MULTI_COLOR_PASS)|| ! defined(SOURCE_INPUT_TYPE2__CONSTANT)
    vec4 sourceInput0, sourceInput1, sourceInput2;
    GetSourceInput(fragInput.texcoord0, sourceInput0, sourceInput1, sourceInput2);
    #endif
    Base(pixel, sourceInput0);
    #ifdef ALPHA_TEST_MASKED_OVERWRITE_PASS
    ReplaceIf_ColorMask(pixel, sourceInput1);
    #endif
    #if defined(ALPHA_TEST_GLINT_PASS)|| defined(ALPHA_TEST_MASKED_OVERWRITE_PASS)|| defined(ALPHA_TEST_PASS)
    Discard_LessEqual(pixel.a, DiscardValue.x);
    #endif
    #if defined(ALPHA_TEST_COLOR_MASK_GLINT_PASS)|| defined(ALPHA_TEST_COLOR_MASK_PASS)
    Discard(pixel.a);
    #endif
    #if defined(ALPHA_TEST_COLOR_MASK_GLINT_PASS)|| defined(ALPHA_TEST_COLOR_MASK_MULTIPLICATIVE_TINT_PASS)|| defined(ALPHA_TEST_COLOR_MASK_PASS)|| defined(COLOR_MASK_PASS)
    BlendTint_CurrentAlpha_Rgb_Tint_Alpha(pixel, sourceInput1);
    #endif
    #ifdef ALPHA_TEST_COLOR_MASK_MULTIPLICATIVE_TINT_PASS
    BlendSourceTint_ComponentAlpha_Rgb_Discard(pixel, sourceInput2, MatColor2);
    #endif
    #ifdef ALPHA_TEST_MULTI_COLOR_PASS
    Blend_ComponentAlpha_Rgb_Discard_AlphaMask(pixel, sourceInput1, DiscardValue.x);
    ReplaceIf_ComponentAlpha_Rgb_BlendSourceTint(pixel, sourceInput2, MatColor2);
    #endif
    #ifdef MULTI_COLOR_PASS
    Blend_ComponentAlpha_Rgb(pixel, sourceInput1);
    Blend_ComponentAlpha_Rgb(pixel, sourceInput2);
    #endif
    #if ! defined(ALPHA_TEST_EMISSIVE_ONLY_PASS)&& ! defined(ALPHA_TEST_EMISSIVE_PASS)&& ! defined(EMISSIVE_PASS)
    OverlayLightingFog(pixel, fragInput);
    #endif
    #ifdef ALPHA_TEST_COLOR_MASK_GLINT_PASS
    Glint(pixel, fragInput.layerUv, s_MatTexture2);
    #endif
    #ifdef ALPHA_TEST_EMISSIVE_PASS
    Discard_Rgba(pixel);
    #endif
    #ifdef ALPHA_TEST_EMISSIVE_ONLY_PASS
    Discard_ZeroOne(pixel.a);
    #endif
    #if defined(ALPHA_TEST_EMISSIVE_ONLY_PASS)|| defined(ALPHA_TEST_EMISSIVE_PASS)|| defined(EMISSIVE_PASS)
    OverlayEmissiveFog(pixel, fragInput);
    #endif
    #if defined(ALPHA_TEST_GLINT_PASS)|| defined(GLINT_PASS)
    Glint(pixel, fragInput.layerUv, s_MatTexture1);
    #endif
    fragOutput.Color0 = pixel;
}
void main() {
    FragmentInput fragmentInput;
    FragmentOutput fragmentOutput;
    fragmentInput.fog = v_fog;
    fragmentInput.layerUv = v_layerUv;
    fragmentInput.light = v_light;
    fragmentInput.texcoord0 = v_texcoord0;
    fragmentOutput.Color0 = vec4(0, 0, 0, 0);
    ViewRect = u_viewRect;
    Proj = u_proj;
    View = u_view;
    ViewTexel = u_viewTexel;
    InvView = u_invView;
    InvProj = u_invProj;
    ViewProj = u_viewProj;
    InvViewProj = u_invViewProj;
    PrevViewProj = u_prevViewProj;
    {
        WorldArray[0] = u_model[0];
        WorldArray[1] = u_model[1];
        WorldArray[2] = u_model[2];
        WorldArray[3] = u_model[3];
    }
    World = u_model[0];
    WorldView = u_modelView;
    WorldViewProj = u_modelViewProj;
    PrevWorldPosOffset = u_prevWorldPosOffset;
    AlphaRef4 = u_alphaRef4;
    AlphaRef = u_alphaRef4.x;
    Frag(fragmentInput, fragmentOutput);
    bgfx_FragColor = fragmentOutput.Color0;
}

