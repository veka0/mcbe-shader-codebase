#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* ALPHA_TEST:
* - ALPHA_TEST__OFF (not used)
* - ALPHA_TEST__ON
*
* FONT_TYPE:
* - FONT_TYPE__BITMAP (not used)
* - FONT_TYPE__BITMAP_SMOOTH
* - FONT_TYPE__MSDF
* - FONT_TYPE__TRUE_TYPE
*/

#extension GL_EXT_texture_cube_map_array : enable
#if GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif
#define attribute in
#define varying in
out vec4 bgfx_FragColor;
varying vec4 v_color0;
varying vec4 v_linearClampBounds;
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
vec4 textureSample(mediump samplerCubeArray _sampler, vec4 _coord, float _lod) {
    return textureLod(_sampler, _coord, _lod);
}
vec4 textureSample(NoopSampler noopsampler, vec2 _coord) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec3 _coord) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec4 _coord) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec2 _coord, float _lod) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec3 _coord, float _lod) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec4 _coord, float _lod) {
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
uniform vec4 ShadowSmoothRadius;
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
uniform vec4 GlyphCutoff;
uniform vec4 GlyphSmoothRadius;
uniform vec4 HalfTexelOffset;
uniform vec4 HudOpacity;
uniform vec4 OutlineColor;
uniform vec4 OutlineCutoff;
uniform vec4 ShadowColor;
uniform vec4 ShadowOffset;
uniform vec4 TintColor;
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
    vec4 color0;
    vec3 position;
    vec2 texcoord0;
};

struct VertexOutput {
    vec4 position;
    vec4 color0;
    vec4 linearClampBounds;
    vec2 texcoord0;
};

struct FragmentInput {
    vec4 color0;
    vec4 linearClampBounds;
    vec2 texcoord0;
};

struct FragmentOutput {
    vec4 Color0;
};

uniform lowp sampler2D s_GlyphTexture;
#ifndef FONT_TYPE__TRUE_TYPE
bool NeedsLinearClamp() {
    #ifndef FONT_TYPE__MSDF
    return true;
    #endif
    #ifdef FONT_TYPE__MSDF
    return GlyphSmoothRadius.x > 0.00095f;
    #endif
}
#endif
#ifdef FONT_TYPE__MSDF
float median(float a, float b, float c) {
    return max(min(a, b), min(max(a, b), c));
}
#endif
void Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    vec2 texCoord = fragInput.texcoord0;
    #ifndef FONT_TYPE__TRUE_TYPE
    if (NeedsLinearClamp()) {
        texCoord = min(max(fragInput.texcoord0, fragInput.linearClampBounds.xy), fragInput.linearClampBounds.zw);
    }
    #endif
    vec4 glyphColor = textureSample(s_GlyphTexture, texCoord);
    #ifdef FONT_TYPE__BITMAP_SMOOTH
    const float center = 0.4;
    const float radius = 0.1;
    glyphColor = smoothstep(center - radius, center + radius, glyphColor);
    #endif
    #ifdef ALPHA_TEST__ON
    if (glyphColor.a < 0.5) {
        discard;
    }
    #endif
    #ifndef FONT_TYPE__MSDF
    vec4 diffuse = fragInput.color0 * glyphColor * TintColor;
    #endif
    #ifdef FONT_TYPE__MSDF
    vec4 resultColor = fragInput.color0;
    vec2 uv = fragInput.texcoord0;
    float sampleDistance = median(glyphColor.r, glyphColor.g, glyphColor.b);
    float innerEdgeAlpha = smoothstep(max(0.0, GlyphCutoff.x - GlyphSmoothRadius.x), min(1.0, GlyphCutoff.x + GlyphSmoothRadius.x), sampleDistance);
    resultColor = mix(OutlineColor, resultColor, innerEdgeAlpha);
    float outerEdgeAlpha = smoothstep(max(0.0, OutlineCutoff.x - GlyphSmoothRadius.x), min(1.0, OutlineCutoff.x + GlyphSmoothRadius.x), sampleDistance);
    resultColor = vec4(resultColor.rgb, resultColor.a * outerEdgeAlpha);
    const float GlyphUvSize = 1.0 / 16.0;
    vec2 topLeft = floor(uv / GlyphUvSize) * GlyphUvSize;
    vec2 bottomRight = topLeft + vec2(GlyphUvSize, GlyphUvSize);
    vec4 shadowSample = textureSample(s_GlyphTexture, clamp(uv - ShadowOffset.xy, topLeft, bottomRight));
    float shadowAlpha = smoothstep(max(0.0, OutlineCutoff.x - ShadowSmoothRadius.x), min(1.0, OutlineCutoff.x + ShadowSmoothRadius.x), shadowSample.a);
    vec4 diffuse = mix(vec4(ShadowColor.rgb, ShadowColor.a * shadowAlpha), resultColor, outerEdgeAlpha) * TintColor;
    #endif
    diffuse.a = diffuse.a * HudOpacity.x;
    fragOutput.Color0 = diffuse;
}
void main() {
    FragmentInput fragmentInput;
    FragmentOutput fragmentOutput;
    fragmentInput.color0 = v_color0;
    fragmentInput.linearClampBounds = v_linearClampBounds;
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

