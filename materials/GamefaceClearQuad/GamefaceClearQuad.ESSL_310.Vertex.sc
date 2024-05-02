/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*/

$input a_color0, a_position
$output v_color
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
    vec4 position;
};

struct VertexOutput {
    vec4 position;
    vec4 color;
};

struct FragmentInput {
    vec4 color;
};

struct FragmentOutput {
    vec4 Color0;
};

void Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    vertOutput.position = vertInput.position;
    vertOutput.color = vertInput.color;
}
void main() {
    VertexInput vertexInput;
    VertexOutput vertexOutput;
    vertexInput.color = (a_color0);
    vertexInput.position = (a_position);
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
    v_color = vertexOutput.color;
    gl_Position = vertexOutput.position;
}

