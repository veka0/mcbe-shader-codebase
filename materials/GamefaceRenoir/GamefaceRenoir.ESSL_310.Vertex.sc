/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*/

$input a_color0, a_position, a_texcoord3
$output v_additional, v_color, v_screenPosition, v_varyingParam0, v_varyingParam1
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

uniform vec4 GradientMidColor;
uniform vec4 GradientYCoord;
uniform vec4 ShaderType;
uniform mat4 CoordTransformVS;
uniform vec4 GradientEndColor;
uniform vec4 GradientStartColor;
uniform vec4 MaskScaleAndOffset;
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
    vec4 additional;
    vec4 color;
    vec4 position;
};

struct VertexOutput {
    vec4 position;
    vec4 additional;
    vec4 color;
    vec4 screenPosition;
    vec4 varyingParam0;
    vec4 varyingParam1;
};

struct FragmentInput {
    vec4 additional;
    vec4 color;
    vec4 screenPosition;
    vec4 varyingParam0;
    vec4 varyingParam1;
};

struct FragmentOutput {
    vec4 Color0;
};

SAMPLER2D_AUTOREG(s_Texture0);
SAMPLER2D_AUTOREG(s_Texture1);
SAMPLER2D_AUTOREG(s_Texture2);
void Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    vertOutput.position = ((vertInput.position) * (Transform)); // Attention!
    vertOutput.screenPosition = vertInput.position;
    vec4 coords = vertInput.position;
    if (vertInput.additional.w == 2.0) {
        coords = vec4(vertInput.additional.xy, 0.0, 1.0);
    }
    vertOutput.varyingParam0 = ((coords) * (CoordTransformVS)); // Attention!
    vertOutput.varyingParam1.x = vertInput.position.x * MaskScaleAndOffset.x + MaskScaleAndOffset.z;
    vertOutput.varyingParam1.y = vertInput.position.y * MaskScaleAndOffset.y + MaskScaleAndOffset.w;
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
    vertexOutput.varyingParam0 = vec4(0, 0, 0, 0);
    vertexOutput.varyingParam1 = vec4(0, 0, 0, 0);
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
    v_varyingParam0 = vertexOutput.varyingParam0;
    v_varyingParam1 = vertexOutput.varyingParam1;
    gl_Position = vertexOutput.position;
}

