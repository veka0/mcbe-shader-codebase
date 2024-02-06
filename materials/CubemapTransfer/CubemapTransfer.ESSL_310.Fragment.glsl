#version 310 es

/*
* Available Macros:
*
* Passes:
* - CUBEMAP_TO_OFFSCREEN_PASS
* - FALLBACK_PASS
*/

#ifdef CUBEMAP_TO_OFFSCREEN_PASS
#extension GL_EXT_shader_texture_lod : enable
#define texture2DLod textureLod
#define texture2DGrad textureGrad
#define texture2DProjLod textureProjLod
#define texture2DProjGrad textureProjGrad
#define textureCubeLod textureLod
#define textureCubeGrad textureGrad
#endif
#if GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif
#define attribute in
#define varying in
out vec4 bgfx_FragColor;
#ifdef CUBEMAP_TO_OFFSCREEN_PASS
varying vec2 v_texCoord;
#endif
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
uniform vec4 CurrentFace;
uniform vec4 CurrentMip;
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
    #ifdef CUBEMAP_TO_OFFSCREEN_PASS
    vec4 position;
    vec2 texcoord0;
    #endif
    #ifdef FALLBACK_PASS
    float dummy;
    #endif
};

struct VertexOutput {
    vec4 position;
    #ifdef CUBEMAP_TO_OFFSCREEN_PASS
    vec2 texCoord;
    #endif
};

struct FragmentInput {
    #ifdef CUBEMAP_TO_OFFSCREEN_PASS
    vec2 texCoord;
    #endif
    #ifdef FALLBACK_PASS
    float dummy;
    #endif
};

struct FragmentOutput {
    vec4 Color0;
};

uniform lowp samplerCube s_SrcTextureCube;
#ifdef CUBEMAP_TO_OFFSCREEN_PASS
void Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    vec2 inCoords = fragInput.texCoord * 2.0 - 1.0;
    vec3 uv = vec3(0.0, inCoords.xy);
    switch(int(CurrentFace.x)) {
        case 0 :
        uv = vec3(1.0, - inCoords.y, - inCoords.x);
        break;
        case 1 :
        uv = vec3(-1.0, - inCoords.y, inCoords.x);
        break;
        case 2 :
        uv = vec3(inCoords.x, 1.0, inCoords.y);
        break;
        case 3 :
        uv = vec3(inCoords.x, - 1.0, - inCoords.y);
        break;
        case 4 :
        uv = vec3(inCoords.x, - inCoords.y, 1.0);
        break;
        case 5 :
        uv = vec3(-inCoords.x, - inCoords.y, - 1.0);
        break;
        default :
        break;
    }
    vec4 color = textureCubeLod(s_SrcTextureCube, uv, CurrentMip.x - 1.0);
    fragOutput.Color0 = color;
}
#endif
#ifdef FALLBACK_PASS
void FallbackFrag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    fragOutput.Color0 = vec4(0.0, 0.0, 0.0, 0.0);
}
#endif
void main() {
    FragmentInput fragmentInput;
    FragmentOutput fragmentOutput;
    #ifdef CUBEMAP_TO_OFFSCREEN_PASS
    fragmentInput.texCoord = v_texCoord;
    #endif
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
    #ifdef CUBEMAP_TO_OFFSCREEN_PASS
    Frag(fragmentInput, fragmentOutput);
    #endif
    #ifdef FALLBACK_PASS
    FallbackFrag(fragmentInput, fragmentOutput);
    #endif
    bgfx_FragColor = fragmentOutput.Color0;
}

