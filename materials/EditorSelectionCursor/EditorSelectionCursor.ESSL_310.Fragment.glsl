#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS
* - RASTERIZED_ALPHA_TEST_PASS
* - RASTERIZED_TRANSPARENT_PASS
* - TRANSPARENT_PASS
*/

#if GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif
#define attribute in
#define varying in
out vec4 bgfx_FragColor;
varying float v_w;
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
uniform vec4 FrameTime;
uniform vec4 MatColor;
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
};

struct VertexOutput {
    vec4 position;
    float w;
};

struct FragmentInput {
    float w;
};

struct FragmentOutput {
    vec4 Color0;
};

#if defined(ALPHA_TEST_PASS)|| defined(RASTERIZED_ALPHA_TEST_PASS)
void FragOutline(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    if (mod(fragInput.w, 0.5) > 0.375) {
        discard;
    }
    fragOutput.Color0 = MatColor;
}
#endif
#if defined(RASTERIZED_TRANSPARENT_PASS)|| defined(TRANSPARENT_PASS)
void FragHull(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    float pi = 3.14159;
    fragOutput.Color0 = MatColor;
    fragOutput.Color0.a += sin(FrameTime.x * pi * 2.0) * (1.0 / 64.0);
}
#endif
void main() {
    FragmentInput fragmentInput;
    FragmentOutput fragmentOutput;
    fragmentInput.w = v_w;
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
    #if defined(ALPHA_TEST_PASS)|| defined(RASTERIZED_ALPHA_TEST_PASS)
    FragOutline(fragmentInput, fragmentOutput);
    #endif
    #if defined(RASTERIZED_TRANSPARENT_PASS)|| defined(TRANSPARENT_PASS)
    FragHull(fragmentInput, fragmentOutput);
    #endif
    bgfx_FragColor = fragmentOutput.Color0;
}

