#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* ALPHA_TEST:
* - ALPHA_TEST__OFF (not used)
* - ALPHA_TEST__ON (not used)
*
* FONT_TYPE:
* - FONT_TYPE__BITMAP (not used)
* - FONT_TYPE__BITMAP_SMOOTH (not used)
* - FONT_TYPE__MSDF
* - FONT_TYPE__TRUE_TYPE
*/

#define attribute in
#define varying out
attribute vec4 a_color0;
attribute vec3 a_position;
attribute vec2 a_texcoord0;
varying vec4 v_color0;
varying vec4 v_linearClampBounds;
varying vec2 v_texcoord0;
struct NoopSampler {
    int noop;
};

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
void Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    const float GLYPH_SIZE = 1.0 / 16.0;
    vec2 texCoord = vertInput.texcoord0;
    #ifndef FONT_TYPE__TRUE_TYPE
    int corner = int(vertInput.position.z);
    bool isRight = corner == 1 || corner == 2;
    bool isBottom = corner == 0 || corner == 1;
    texCoord.x += isRight ? GLYPH_SIZE : 0.0;
    texCoord.y += isBottom ? GLYPH_SIZE : 0.0;
    #endif
    vec4 linearClampBounds = vec4(0.0, 0.0, 1.0, 1.0);
    #ifndef FONT_TYPE__TRUE_TYPE
    if (NeedsLinearClamp()) {
        linearClampBounds.xy = vertInput.texcoord0 + HalfTexelOffset.x;
        linearClampBounds.zw = vertInput.texcoord0 + GLYPH_SIZE - HalfTexelOffset.x;
    }
    #endif
    vertOutput.position = ((WorldViewProj) * (vec4(vertInput.position.xy, 0.0, 1.0)));
    vertOutput.texcoord0 = texCoord;
    vertOutput.linearClampBounds = linearClampBounds;
    vertOutput.color0 = vertInput.color0;
}
void main() {
    VertexInput vertexInput;
    VertexOutput vertexOutput;
    vertexInput.color0 = (a_color0);
    vertexInput.position = (a_position);
    vertexInput.texcoord0 = (a_texcoord0);
    vertexOutput.color0 = vec4(0, 0, 0, 0);
    vertexOutput.linearClampBounds = vec4(0, 0, 0, 0);
    vertexOutput.texcoord0 = vec2(0, 0);
    vertexOutput.position = vec4(0, 0, 0, 0);
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
    Vert(vertexInput, vertexOutput);
    v_color0 = vertexOutput.color0;
    v_linearClampBounds = vertexOutput.linearClampBounds;
    v_texcoord0 = vertexOutput.texcoord0;
    gl_Position = vertexOutput.position;
}

