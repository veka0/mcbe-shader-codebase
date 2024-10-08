/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*/

$input a_color0, a_position, a_texcoord0
$output v_color, v_layer1UV, v_layer2UV, v_texcoord0
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

uniform vec4 UVOffset;
uniform vec4 GlintColor;
uniform vec4 HudOpacity;
uniform vec4 TintColor;
uniform vec4 UVRotation;
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
    vec4 color;
    vec3 position;
    vec2 texcoord0;
};

struct VertexOutput {
    vec4 position;
    vec4 color;
    vec2 layer1UV;
    vec2 layer2UV;
    vec2 texcoord0;
};

struct FragmentInput {
    vec4 color;
    vec2 layer1UV;
    vec2 layer2UV;
    vec2 texcoord0;
};

struct FragmentOutput {
    vec4 Color0;
};

SAMPLER2D_AUTOREG(s_MatTexture);
SAMPLER2D_AUTOREG(s_GlintTexture);
vec2 calculateLayerUV(vec2 origUV, float offset, float rotation) {
    vec2 uv = origUV;
    uv -= 0.5;
    float rsin = sin(rotation);
    float rcos = cos(rotation);
    uv = ((uv) * (mat2(rcos, - rsin, rsin, rcos))); // Attention!
    uv.x += offset;
    uv += 0.5;
    return uv * UVScale.xy;
}
void Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    vertOutput.position = ((WorldViewProj) * (vec4(vertInput.position, 1.0))); // Attention!
    vertOutput.texcoord0 = vertInput.texcoord0;
    vertOutput.layer1UV = calculateLayerUV(vertInput.texcoord0, UVOffset.x, UVRotation.x);
    vertOutput.layer2UV = calculateLayerUV(vertInput.texcoord0, UVOffset.y, UVRotation.y);
    vertOutput.color = vertInput.color;
}
void main() {
    VertexInput vertexInput;
    VertexOutput vertexOutput;
    vertexInput.color = (a_color0);
    vertexInput.position = (a_position);
    vertexInput.texcoord0 = (a_texcoord0);
    vertexOutput.color = vec4(0, 0, 0, 0);
    vertexOutput.layer1UV = vec2(0, 0);
    vertexOutput.layer2UV = vec2(0, 0);
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
    v_color = vertexOutput.color;
    v_layer1UV = vertexOutput.layer1UV;
    v_layer2UV = vertexOutput.layer2UV;
    v_texcoord0 = vertexOutput.texcoord0;
    gl_Position = vertexOutput.position;
}

