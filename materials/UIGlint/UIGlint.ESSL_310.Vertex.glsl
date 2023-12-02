#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*/

#define attribute in
#define varying out
attribute vec4 a_color0;
attribute vec3 a_position;
attribute vec2 a_texcoord0;
varying vec4 v_color;
varying vec2 v_layer1UV;
varying vec2 v_layer2UV;
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
uniform mat4 u_invView;
uniform mat4 u_invProj;
uniform mat4 u_viewProj;
uniform mat4 u_invViewProj;
uniform mat4 u_prevViewProj;
uniform mat4 u_model[4];
uniform mat4 u_modelView;
uniform vec4 UVOffset;
uniform mat4 u_modelViewProj;
uniform vec4 u_prevWorldPosOffset;
uniform vec4 u_alphaRef4;
uniform vec4 HudOpacity;
uniform vec4 GlintColor;
uniform vec4 UVRotation;
uniform vec4 UVScale;
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
    vec3 position;
    vec4 color;
    vec2 texcoord0;
};

struct VertexOutput {
    vec4 position;
    vec2 texcoord0;
    vec2 layer1UV;
    vec2 layer2UV;
    vec4 color;
};

struct FragmentInput {
    vec2 texcoord0;
    vec2 layer1UV;
    vec2 layer2UV;
    vec4 color;
};

struct FragmentOutput {
    vec4 Color0;
};

uniform lowp sampler2D s_GlintTexture;
uniform lowp sampler2D s_MatTexture;
vec2 calculateLayerUV(vec2 origUV, float offset, float rotation) {
    vec2 uv = origUV;
    uv -= 0.5;
    float rsin = sin(rotation);
    float rcos = cos(rotation);
    uv = ((uv) * (mat2(rcos, - rsin, rsin, rcos)));
    uv.x += offset;
    uv += 0.5;
    return uv * UVScale.xy;
}
void Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    vertOutput.position = ((WorldViewProj) * (vec4(vertInput.position, 1.0)));
    vertOutput.texcoord0 = vertInput.texcoord0;
    vertOutput.layer1UV = calculateLayerUV(vertInput.texcoord0, UVOffset.x, UVRotation.x);
    vertOutput.layer2UV = calculateLayerUV(vertInput.texcoord0, UVOffset.y, UVRotation.y);
    vertOutput.color = vertInput.color;
}
void main() {
    VertexInput vertexInput;
    VertexOutput vertexOutput;
    vertexInput.position = (a_position);
    vertexInput.color = (a_color0);
    vertexInput.texcoord0 = (a_texcoord0);
    vertexOutput.texcoord0 = vec2(0, 0);
    vertexOutput.layer1UV = vec2(0, 0);
    vertexOutput.layer2UV = vec2(0, 0);
    vertexOutput.color = vec4(0, 0, 0, 0);
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
    v_texcoord0 = vertexOutput.texcoord0;
    v_layer1UV = vertexOutput.layer1UV;
    v_layer2UV = vertexOutput.layer2UV;
    v_color = vertexOutput.color;
    gl_Position = vertexOutput.position;
}

