/*
* Available Macros:
*
* Passes:
* - COLOR_POST_PROCESS_PASS (not used)
*/

$input a_position, a_texcoord0
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

uniform vec4 GenericTonemapperContrastAndScaleAndOffsetAndCrosstalk;
uniform vec4 ExposureCompensation;
uniform vec4 ColorGrading_Offset_Highlights;
uniform vec4 ColorGrading_Gamma_Highlights;
uniform vec4 ColorGrading_Gamma_PlayerUI;
uniform vec4 ColorGrading_Contrast_Highlights;
uniform vec4 ColorGrading_Saturation_Highlights;
uniform vec4 ColorGrading_Contrast_Midtones;
uniform vec4 ColorGrading_Contrast_Shadows;
uniform vec4 ColorGrading_Gain_Highlights;
uniform vec4 ColorGrading_Gain_Midtones;
uniform vec4 ScreenSize;
uniform vec4 ColorGrading_Gain_Shadows;
uniform vec4 ColorGrading_Offset_Shadows;
uniform vec4 ColorGrading_Offset_Midtones;
uniform vec4 ColorGrading_Gamma_Shadows;
uniform vec4 ColorGrading_Gamma_Midtones;
uniform vec4 TonemapParams0;
uniform vec4 ColorGrading_Saturation_Midtones;
uniform vec4 ColorGrading_Saturation_Shadows;
uniform vec4 GenericTonemapperCrosstalkParams;
uniform vec4 LuminanceMinMaxAndWhitePointAndMinWhitePoint;
uniform vec4 OutputTextureMaxValue;
uniform vec4 RasterizedColorEnabled;
uniform vec4 RenderMode;
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
    vec2 texcoord0;
};

struct VertexOutput {
    vec4 position;
    vec2 texcoord0;
};

struct FragmentInput {
    vec2 texcoord0;
};

struct FragmentOutput {
    vec4 Color0;
};

SAMPLER2D_AUTOREG(s_AverageLuminance);
SAMPLER2D_AUTOREG(s_ColorTexture);
SAMPLER2D_AUTOREG(s_CustomExposureCompensation);
SAMPLER2D_AUTOREG(s_PreExposureLuminance);
SAMPLER2D_AUTOREG(s_RasterColor);
SAMPLER2D_AUTOREG(s_RasterizedColor);
void Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    vertOutput.position = vec4(vertInput.position.xy * 2.0 - 1.0, 0.0, 1.0);
    vertOutput.texcoord0 = vec2(vertInput.texcoord0.x, vertInput.texcoord0.y);
}
struct ColorTransform {
    float hue;
    float saturation;
    float luminance;
};

const int kTonemapperReinhard = 0;
const int kTonemapperReinhardLuma = 1;
const int kTonemapperReinhardLuminance = 2;
const int kTonemapperHable = 3;
const int kTonemapperACES = 4;
const int kTonemapperGeneric = 5;
void main() {
    VertexInput vertexInput;
    VertexOutput vertexOutput;
    vertexInput.position = (a_position);
    vertexInput.texcoord0 = (a_texcoord0);
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
    v_texcoord0 = vertexOutput.texcoord0;
    gl_Position = vertexOutput.position;
}

