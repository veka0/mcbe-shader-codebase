/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*/

$input a_color0, a_position, a_texcoord3
$output v_additional, v_color, v_screenPosition
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

uniform vec4 PrimProps0;
uniform vec4 ShaderType;
uniform vec4 PrimProps1;
uniform vec4 Coefficients[3];
uniform vec4 PixelOffsets[6];
uniform mat4 Transform;
uniform vec4 Viewport;
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
    vec4 additional;
    vec4 color;
    vec4 position;
};

struct VertexOutput {
    vec4 position;
    vec4 additional;
    vec4 color;
    vec4 screenPosition;
};

struct FragmentInput {
    vec4 additional;
    vec4 color;
    vec4 screenPosition;
};

struct FragmentOutput {
    vec4 Color0;
};

SAMPLER2D_AUTOREG(s_Texture0);
SAMPLER2D_AUTOREG(s_Texture1);
SAMPLER2D_AUTOREG(s_Texture2);
SAMPLER2D_AUTOREG(s_Texture3);
void Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    vertOutput.position = ((vertInput.position) * (Transform)); // Attention!
    vertOutput.screenPosition = vertInput.position;
    float w = vertOutput.position.w;
    vertOutput.position.x = vertOutput.position.x * 2.0 - w;
    vertOutput.position.y = (w - vertOutput.position.y) * 2.0 - w;
    vertOutput.color = vertInput.color;
    vertOutput.additional = vertInput.additional;
}
void main() {
    VertexInput vertexInput;
    VertexOutput vertexOutput;
    vertexInput.additional = (a_texcoord3);
    vertexInput.color = (a_color0);
    vertexInput.position = (a_position);
    vertexOutput.additional = vec4(0, 0, 0, 0);
    vertexOutput.color = vec4(0, 0, 0, 0);
    vertexOutput.screenPosition = vec4(0, 0, 0, 0);
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
    v_additional = vertexOutput.additional;
    v_color = vertexOutput.color;
    v_screenPosition = vertexOutput.screenPosition;
    gl_Position = vertexOutput.position;
}

