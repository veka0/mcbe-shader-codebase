#version 310 es

/*
* Available Macros:
*
* Passes:
* - BLOOM_BLEND_PASS
* - BLOOM_HIGH_PASS
* - DF_DOWN_SAMPLE_PASS
* - DF_DOWN_SAMPLE_WITH_DEPTH_EROSION_PASS
* - DF_UP_SAMPLE_PASS
*/

#if GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif
#define attribute in
#define varying in
out vec4 bgfx_FragColor;
varying vec2 v_texcoord0;
struct NoopSampler {
    int noop;
};

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
uniform vec4 u_viewTexel;
uniform mat4 u_invView;
uniform mat4 u_invProj;
uniform mat4 u_viewProj;
uniform mat4 u_invViewProj;
uniform mat4 u_prevViewProj;
uniform mat4 u_model[4];
uniform mat4 u_modelView;
uniform mat4 u_modelViewProj;
uniform vec4 u_prevWorldPosOffset;
uniform vec4 u_alphaRef4;
uniform vec4 BloomParams1;
uniform vec4 BloomParams2;
uniform vec4 RenderMode;
uniform vec4 ScreenSize;
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
    vec4 position;
    vec2 texcoord0;
};

struct VertexOutput {
    vec4 position;
    vec2 texcoord0;
};

struct FragmentInput {
    vec2 texcoord0;
};

struct FragmentOutput {
    vec4 Color0;
};

uniform lowp sampler2D s_BlurPyramidTexture;
uniform lowp sampler2D s_DepthTexture;
uniform lowp sampler2D s_HDRi;
uniform lowp sampler2D s_RasterColor;
#ifdef BLOOM_HIGH_PASS
float luminance(vec3 clr) {
    return dot(clr, vec3(0.2126, 0.7152, 0.0722));
}
#endif
struct ColorTransform {
    float hue;
    float saturation;
    float luminance;
};

#if defined(BLOOM_BLEND_PASS)|| defined(DF_UP_SAMPLE_PASS)
vec4 DualFilterUpsample(sampler2D srcImg, vec2 uv, vec2 pixelOffsets) {
    vec4 col = vec4(0, 0, 0, 0);
    col += 0.166 * textureSample(srcImg, uv + vec2(0.5 * pixelOffsets.x, 0.5 * pixelOffsets.y));
    col += 0.166 * textureSample(srcImg, uv + vec2(-0.5 * pixelOffsets.x, 0.5 * pixelOffsets.y));
    col += 0.166 * textureSample(srcImg, uv + vec2(0.5 * pixelOffsets.x, - 0.5 * pixelOffsets.y));
    col += 0.166 * textureSample(srcImg, uv + vec2(-0.5 * pixelOffsets.x, - 0.5 * pixelOffsets.y));
    col += 0.083 * textureSample(srcImg, uv + vec2(pixelOffsets.x, pixelOffsets.y));
    col += 0.083 * textureSample(srcImg, uv + vec2(-pixelOffsets.x, pixelOffsets.y));
    col += 0.083 * textureSample(srcImg, uv + vec2(pixelOffsets.x, - pixelOffsets.y));
    col += 0.083 * textureSample(srcImg, uv + vec2(-pixelOffsets.x, - pixelOffsets.y));
    return col;
}
#endif
#ifdef BLOOM_HIGH_PASS
vec4 HighPass(vec4 col) {
    float lum = luminance(col.rgb);
    return vec4(col.rgb, lum);
}
vec4 HighPassDFDownsample(sampler2D srcImg, sampler2D depthImg, vec2 uv, vec2 pixelOffsets) {
    vec4 col = vec4(0, 0, 0, 0);
    col += 0.5 * HighPass(textureSample(srcImg, uv));
    col += 0.125 * HighPass(textureSample(srcImg, uv + vec2(pixelOffsets.x, pixelOffsets.y)));
    col += 0.125 * HighPass(textureSample(srcImg, uv + vec2(-pixelOffsets.x, pixelOffsets.y)));
    col += 0.125 * HighPass(textureSample(srcImg, uv + vec2(pixelOffsets.x, - pixelOffsets.y)));
    col += 0.125 * HighPass(textureSample(srcImg, uv + vec2(-pixelOffsets.x, - pixelOffsets.y)));
    if (bool(BloomParams2.z)) {
        float minRange = BloomParams2.x;
        float maxRange = BloomParams2.y;
        float depth = textureSample(depthImg, uv).r;
        depth = ((depth * maxRange) - minRange) / (maxRange - minRange);
        depth = clamp(depth, BloomParams1.z, 1.0);
        col *= pow(depth, BloomParams1.y);
    }
    return col;
}
#endif
#ifdef DF_DOWN_SAMPLE_PASS
vec4 DualFilterDownsample(sampler2D srcImg, vec2 uv, vec2 pixelOffsets) {
    vec4 col = vec4(0, 0, 0, 0);
    col += 0.5 * textureSample(srcImg, uv);
    col += 0.125 * textureSample(srcImg, uv + vec2(pixelOffsets.x, pixelOffsets.y));
    col += 0.125 * textureSample(srcImg, uv + vec2(-pixelOffsets.x, pixelOffsets.y));
    col += 0.125 * textureSample(srcImg, uv + vec2(pixelOffsets.x, - pixelOffsets.y));
    col += 0.125 * textureSample(srcImg, uv + vec2(-pixelOffsets.x, - pixelOffsets.y));
    return col;
}
#endif
#ifdef DF_DOWN_SAMPLE_WITH_DEPTH_EROSION_PASS
vec4 DualFilterDownsampleWithDepthErosion(sampler2D srcImg, vec2 uv, vec2 pixelOffsets) {
    vec4 col = vec4(0, 0, 0, 0);
    vec4 a = textureSample(srcImg, uv);
    vec4 b = textureSample(srcImg, uv + vec2(pixelOffsets.x, pixelOffsets.y));
    vec4 c = textureSample(srcImg, uv + vec2(-pixelOffsets.x, pixelOffsets.y));
    vec4 d = textureSample(srcImg, uv + vec2(pixelOffsets.x, - pixelOffsets.y));
    vec4 e = textureSample(srcImg, uv + vec2(-pixelOffsets.x, - pixelOffsets.y));
    col.rgb += 0.5 * a.rgb;
    col.rgb += 0.125 * b.rgb;
    col.rgb += 0.125 * c.rgb;
    col.rgb += 0.125 * d.rgb;
    col.rgb += 0.125 * e.rgb;
    col.a = max(a.a, max(b.a, max(c.a, max(d.a, e.a))));
    return col;
}
#endif
void Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    #if defined(BLOOM_BLEND_PASS)|| defined(DF_UP_SAMPLE_PASS)
    float xOffset = 4.0 * abs(dFdx(fragInput.texcoord0.x));
    float yOffset = 4.0 * abs(dFdy(fragInput.texcoord0.y));
    #endif
    #if ! defined(BLOOM_BLEND_PASS)&& ! defined(DF_UP_SAMPLE_PASS)
    float xOffset = 1.5 * abs(dFdx(fragInput.texcoord0.x));
    float yOffset = 1.5 * abs(dFdy(fragInput.texcoord0.y));
    #endif
    vec2 uv = fragInput.texcoord0;
    #ifdef BLOOM_BLEND_PASS
    vec4 bloom = DualFilterUpsample(s_BlurPyramidTexture, uv, vec2(xOffset, yOffset));
    vec3 baseColor = textureSample(s_HDRi, uv).rgb;
    float intensity = BloomParams1.x;
    vec3 bloomedColor = baseColor + (intensity * bloom.rgb);
    fragOutput.Color0 = vec4(bloomedColor, 1.0);
    #endif
    #ifdef BLOOM_HIGH_PASS
    fragOutput.Color0 = HighPassDFDownsample(s_HDRi, s_DepthTexture, uv, vec2(xOffset, yOffset));
    #endif
    #ifdef DF_DOWN_SAMPLE_PASS
    fragOutput.Color0 = DualFilterDownsample(s_BlurPyramidTexture, uv, vec2(xOffset, yOffset));
    #endif
    #ifdef DF_DOWN_SAMPLE_WITH_DEPTH_EROSION_PASS
    fragOutput.Color0 = DualFilterDownsampleWithDepthErosion(s_BlurPyramidTexture, uv, vec2(xOffset, yOffset));
    #endif
    #ifdef DF_UP_SAMPLE_PASS
    fragOutput.Color0 = DualFilterUpsample(s_BlurPyramidTexture, uv, vec2(xOffset, yOffset));
    #endif
}
void main() {
    FragmentInput fragmentInput;
    FragmentOutput fragmentOutput;
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

