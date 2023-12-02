#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*/

#if GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif
#define attribute in
#define varying in
out vec4 bgfx_FragColor;
varying vec2 v_extraParams;
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
uniform vec4 PrimProps0;
uniform mat4 u_modelView;
uniform mat4 u_modelViewProj;
uniform vec4 u_prevWorldPosOffset;
uniform vec4 PrimProps1;
uniform vec4 ShaderType;
uniform vec4 u_alphaRef4;
uniform mat4 Transform;
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
    vec4 color;
    vec4 additional;
};

struct VertexOutput {
    vec4 position;
    vec2 extraParams;
};

struct FragmentInput {
    vec2 extraParams;
};

struct FragmentOutput {
    vec4 Color0;
};

void Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    if (int(ShaderType.x) == 14) {
        vec2 px = dFdx(fragInput.extraParams);
        vec2 py = dFdy(fragInput.extraParams);
        float fx = (2.0 * fragInput.extraParams.x) * px.x - px.y;
        float fy = (2.0 * fragInput.extraParams.x) * py.x - py.y;
        float edgeAlpha = (fragInput.extraParams.x * fragInput.extraParams.x - fragInput.extraParams.y);
        float sd = sqrt((edgeAlpha * edgeAlpha) / (fx * fx + fy * fy));
        float alpha = 1.0 - sd;
        fragOutput.Color0 = PrimProps0 * PrimProps1.x * alpha;
    } else if (int(ShaderType.x) == 11) {
        fragOutput.Color0 = PrimProps0 * min(1.0, (1.0 - abs(fragInput.extraParams.y * PrimProps1.y - PrimProps1.z)) * PrimProps1.x);
    } else {
        fragOutput.Color0 = PrimProps0 * fragInput.extraParams.y;
    }
}
void main() {
    FragmentInput fragmentInput;
    FragmentOutput fragmentOutput;
    fragmentInput.extraParams = v_extraParams;
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

