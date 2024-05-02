/*
* Available Macros:
*
* Passes:
* - OPAQUE_PASS (not used)
*/

$input a_position
$output v_texcoord0
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

uniform mat4 CubemapRotation;
uniform vec4 SubPixelOffset;
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
};

struct VertexOutput {
    vec4 position;
    vec3 texcoord0;
};

struct FragmentInput {
    vec3 texcoord0;
};

struct FragmentOutput {
    vec4 Color0;
};

SAMPLERCUBE_AUTOREG(s_MatTexture);
vec4 jitterVertexPosition(vec3 worldPosition) {
    mat4 offsetProj = Proj;
    offsetProj[2][0] += SubPixelOffset.x; // Attention!
    offsetProj[2][1] -= SubPixelOffset.y; // Attention!
    return ((offsetProj) * (((View) * (vec4(worldPosition, 1.0f))))); // Attention!
}
void Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    vec3 worldPosition = ((World) * (vec4(vertInput.position, 1.0))).xyz; // Attention!
    vertOutput.position = jitterVertexPosition(worldPosition);
    vertOutput.texcoord0 = ((CubemapRotation) * (vec4(worldPosition, 0.0))).xyz; // Attention!
}
struct ColorTransform {
    float hue;
    float saturation;
    float luminance;
};

void main() {
    VertexInput vertexInput;
    VertexOutput vertexOutput;
    vertexInput.position = (a_position);
    vertexOutput.texcoord0 = vec3(0, 0, 0);
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
    gl_Position = vertexOutput.position;
}

