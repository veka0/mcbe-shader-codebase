/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_PASS
* - DEPTH_ONLY_OPAQUE_PASS
* - GEOMETRY_PREPASS_PASS
* - GEOMETRY_PREPASS_ALPHA_TEST_PASS
*
* Instancing:
* - INSTANCING__OFF
* - INSTANCING__ON
*
* RenderAsBillboards:
* - RENDER_AS_BILLBOARDS__OFF (not used)
* - RENDER_AS_BILLBOARDS__ON
*
* Seasons:
* - SEASONS__OFF (not used)
* - SEASONS__ON (not used)
*/

$input a_color0, a_normal, a_position, a_tangent, a_texcoord0, a_texcoord1
#if defined(INSTANCING__ON)&&(defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS))
$input a_texcoord4
#endif
#ifdef INSTANCING__ON
$input i_data1, i_data2, i_data3
#endif
#if defined(INSTANCING__OFF)&&(defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS))
$input a_texcoord4
#endif
$output v_bitangent, v_color0
#if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
$output v_frontFacing
#endif
$output v_lightmapUV, v_normal
#if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
$output v_pbrTextureId
#endif
$output v_tangent, v_texcoord0, v_worldPos
struct NoopSampler {
    int noop;
};

#ifdef INSTANCING__ON
vec3 instMul(vec3 _vec, mat3 _mtx) {
    return ((_vec) * (_mtx)); // Attention!
}
vec3 instMul(mat3 _mtx, vec3 _vec) {
    return ((_mtx) * (_vec)); // Attention!
}
vec4 instMul(vec4 _vec, mat4 _mtx) {
    return ((_vec) * (_mtx)); // Attention!
}
vec4 instMul(mat4 _mtx, vec4 _vec) {
    return ((_mtx) * (_vec)); // Attention!
}
#endif
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

uniform vec4 GlobalRoughness;
uniform vec4 LightDiffuseColorAndIlluminance;
uniform vec4 LightWorldSpaceDirection;
uniform vec4 MaterialID;
uniform vec4 SubPixelOffset;
uniform vec4 ViewPositionAndTime;
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
struct DiscreteLightingContributions {
    vec3 diffuse;
    vec3 specular;
    vec4 ambientTint;
};

struct LightData {
    float lookup;
};

struct Light {
    vec4 position;
    vec4 color;
    int shadowProbeIndex;
    int pad0;
    int pad1;
    int pad2;
};

struct PBRTextureData {
    float colourToMaterialUvScale0;
    float colourToMaterialUvScale1;
    float colourToMaterialUvBias0;
    float colourToMaterialUvBias1;
    float colourToNormalUvScale0;
    float colourToNormalUvScale1;
    float colourToNormalUvBias0;
    float colourToNormalUvBias1;
    int flags;
    float uniformRoughness;
    float uniformEmissive;
    float uniformMetalness;
    float uniformSubsurface;
    float maxMipColour;
    float maxMipMer;
    float maxMipNormal;
};

struct LightSourceWorldInfo {
    vec4 worldSpaceDirection;
    vec4 diffuseColorAndIlluminance;
    vec4 shadowDirection;
    mat4 shadowProj0;
    mat4 shadowProj1;
    mat4 shadowProj2;
    mat4 shadowProj3;
    mat4 waterSurfaceViewProj;
    mat4 invWaterSurfaceViewProj;
    int isSun;
    int shadowCascadeNumber;
    int pad0;
    int pad1;
};

struct PBRFragmentInfo {
    vec2 lightClusterUV;
    vec3 worldPosition;
    vec3 viewPosition;
    vec3 ndcPosition;
    vec3 worldNormal;
    vec3 viewNormal;
    vec3 albedo;
    float metalness;
    float roughness;
    float emissive;
    float subsurface;
    float blockAmbientContribution;
    float skyAmbientContribution;
};

struct PBRLightingContributions {
    vec3 directDiffuse;
    vec3 directSpecular;
    vec3 indirectDiffuse;
    vec3 indirectSpecular;
    vec3 emissive;
};

struct VertexInput {
    vec4 color0;
    vec2 lightmapUV;
    vec4 normal;
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    int pbrTextureId;
    #endif
    vec3 position;
    vec4 tangent;
    vec2 texcoord0;
    #ifdef INSTANCING__ON
    vec4 instanceData0;
    vec4 instanceData1;
    vec4 instanceData2;
    #endif
};

struct VertexOutput {
    vec4 position;
    vec3 bitangent;
    vec4 color0;
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    int frontFacing;
    #endif
    vec2 lightmapUV;
    vec3 normal;
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    int pbrTextureId;
    #endif
    vec3 tangent;
    vec2 texcoord0;
    vec3 worldPos;
};

struct FragmentInput {
    vec3 bitangent;
    vec4 color0;
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    int frontFacing;
    #endif
    vec2 lightmapUV;
    vec3 normal;
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    int pbrTextureId;
    #endif
    vec3 tangent;
    vec2 texcoord0;
    vec3 worldPos;
};

struct FragmentOutput {
    vec4 Color0; vec4 Color1; vec4 Color2;
};

SAMPLER2D_AUTOREG(s_LightMapTexture);
SAMPLER2D_AUTOREG(s_MatTexture);
SAMPLER2D_AUTOREG(s_SeasonsTexture);
struct StandardSurfaceInput {
    vec2 UV;
    vec3 Color;
    float Alpha;
    vec2 lightmapUV;
    vec3 bitangent;
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    int frontFacing;
    #endif
    vec3 normal;
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    int pbrTextureId;
    #endif
    vec3 tangent;
    vec3 worldPos;
};

struct StandardVertexInput {
    VertexInput vertInput;
    vec3 worldPos;
};

struct StandardSurfaceOutput {
    vec3 Albedo;
    float Alpha;
    float Metallic;
    float Roughness;
    float Occlusion;
    float Emissive;
    float Subsurface;
    vec3 AmbientLight;
    vec3 ViewSpaceNormal;
};

#if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
vec4 jitterVertexPosition(vec3 worldPosition) {
    mat4 offsetProj = Proj;
    offsetProj[2][0] += SubPixelOffset.x; // Attention!
    offsetProj[2][1] -= SubPixelOffset.y; // Attention!
    return ((offsetProj) * (((View) * (vec4(worldPosition, 1.0f))))); // Attention!
}
#endif
struct ColorTransform {
    float hue;
    float saturation;
    float luminance;
};

#ifdef RENDER_AS_BILLBOARDS__ON
void transformAsBillboardVertex(inout StandardVertexInput stdInput, inout VertexOutput vertOutput) {
    stdInput.worldPos += vec3(0.5, 0.5, 0.5);
    vec3 forward = normalize(stdInput.worldPos - ViewPositionAndTime.xyz);
    vec3 right = normalize(cross(vec3(0.0, 1.0, 0.0), forward));
    vec3 up = cross(forward, right);
    vec3 offsets = stdInput.vertInput.color0.xyz;
    stdInput.worldPos -= up * (offsets.z - 0.5) + right * (offsets.x - 0.5);
    vertOutput.position = ((ViewProj) * (vec4(stdInput.worldPos, 1.0))); // Attention!
}
#endif
#if defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(DEPTH_ONLY_PASS)
float RenderChunkVert(StandardVertexInput stdInput, inout VertexOutput vertOutput) {
    #ifdef RENDER_AS_BILLBOARDS__ON
    vertOutput.color0 = vec4(1.0, 1.0, 1.0, 1.0);
    transformAsBillboardVertex(stdInput, vertOutput);
    #endif
    float cameraDepth = length(ViewPositionAndTime.xyz - stdInput.worldPos);
    return cameraDepth;
}
#endif
#if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
void calculateVertexPosition(inout StandardVertexInput stdInput, inout VertexOutput vertOutput) {
    #ifdef RENDER_AS_BILLBOARDS__ON
    vertOutput.color0 = vec4(1.0, 1.0, 1.0, 1.0);
    transformAsBillboardVertex(stdInput, vertOutput);
    #endif
    vertOutput.position = jitterVertexPosition(stdInput.worldPos);
}
#endif
struct CompositingOutput {
    vec3 mLitColor;
};

void StandardTemplate_VertSharedTransform(inout StandardVertexInput stdInput, inout VertexOutput vertOutput) {
    VertexInput vertInput = stdInput.vertInput;
    #ifdef INSTANCING__OFF
    vec3 wpos = ((World) * (vec4(vertInput.position, 1.0))).xyz; // Attention!
    #endif
    #ifdef INSTANCING__ON
    mat4 model;
    model[0] = vec4(vertInput.instanceData0.x, vertInput.instanceData1.x, vertInput.instanceData2.x, 0);
    model[1] = vec4(vertInput.instanceData0.y, vertInput.instanceData1.y, vertInput.instanceData2.y, 0);
    model[2] = vec4(vertInput.instanceData0.z, vertInput.instanceData1.z, vertInput.instanceData2.z, 0);
    model[3] = vec4(vertInput.instanceData0.w, vertInput.instanceData1.w, vertInput.instanceData2.w, 1);
    vec3 wpos = instMul(model, vec4(vertInput.position, 1.0)).xyz;
    #endif
    vertOutput.position = ((ViewProj) * (vec4(wpos, 1.0))); // Attention!
    stdInput.worldPos = wpos;
    vertOutput.worldPos = wpos;
}
void StandardTemplate_VertexPreprocessIdentity(VertexInput vertInput, inout VertexOutput vertOutput) {
}

void StandardTemplate_InvokeVertexPreprocessFunction(inout VertexInput vertInput, inout VertexOutput vertOutput);
void StandardTemplate_InvokeVertexOverrideFunction(StandardVertexInput vertInput, inout VertexOutput vertOutput);
void StandardTemplate_InvokeLightingVertexFunction(VertexInput vertInput, inout VertexOutput vertOutput, vec3 worldPosition);
struct DirectionalLight {
    vec3 ViewSpaceDirection;
    vec3 Intensity;
};

void computeLighting_RenderChunk_Vertex(VertexInput vInput, inout VertexOutput vOutput, vec3 worldPosition) {
    vOutput.lightmapUV = vInput.lightmapUV;
}
#if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)

const int kInvalidPBRTextureHandle = 0xffff;
const int kPBRTextureDataFlagHasMaterialTexture = (1 << 0);
const int kPBRTextureDataFlagHasSubsurfaceChannel = (1 << 1);
const int kPBRTextureDataFlagHasNormalTexture = (1 << 2);
const int kPBRTextureDataFlagHasHeightMapTexture = (1 << 3);
float applyPBRValuesToVertexOutput(StandardVertexInput stdInput, inout VertexOutput vertOutput) {
    float cameraDepth = length(ViewPositionAndTime.xyz - stdInput.worldPos);
    vertOutput.pbrTextureId = stdInput.vertInput.pbrTextureId & 0xffff;
    vec3 n = stdInput.vertInput.normal.xyz;
    vec3 t = stdInput.vertInput.tangent.xyz;
    vec3 b = cross(n, t) * stdInput.vertInput.tangent.w;
    vertOutput.normal = ((World) * (vec4(n, 0.0))).xyz; // Attention!
    vertOutput.tangent = ((World) * (vec4(t, 0.0))).xyz; // Attention!
    vertOutput.bitangent = ((World) * (vec4(b, 0.0))).xyz; // Attention!
    vertOutput.worldPos = stdInput.worldPos;
    return cameraDepth;
}
float RenderChunkPrepassVert(StandardVertexInput stdInput, inout VertexOutput vertOutput) {
    calculateVertexPosition(stdInput, vertOutput);
    return applyPBRValuesToVertexOutput(stdInput, vertOutput);
}
#endif
void StandardTemplate_VertShared(VertexInput vertInput, inout VertexOutput vertOutput) {
    StandardTemplate_InvokeVertexPreprocessFunction(vertInput, vertOutput);
    StandardVertexInput stdInput;
    stdInput.vertInput = vertInput;
    StandardTemplate_VertSharedTransform(stdInput, vertOutput);
    vertOutput.texcoord0 = vertInput.texcoord0;
    vertOutput.color0 = vertInput.color0;
    StandardTemplate_InvokeVertexOverrideFunction(stdInput, vertOutput);
    StandardTemplate_InvokeLightingVertexFunction(vertInput, vertOutput, stdInput.worldPos);
}
void StandardTemplate_InvokeVertexPreprocessFunction(inout VertexInput vertInput, inout VertexOutput vertOutput) {
    StandardTemplate_VertexPreprocessIdentity(vertInput, vertOutput);
}
void StandardTemplate_InvokeVertexOverrideFunction(StandardVertexInput vertInput, inout VertexOutput vertOutput) {
    #if defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(DEPTH_ONLY_PASS)
    RenderChunkVert(vertInput, vertOutput);
    #endif
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    RenderChunkPrepassVert(vertInput, vertOutput);
    #endif
}
void StandardTemplate_InvokeLightingVertexFunction(VertexInput vertInput, inout VertexOutput vertOutput, vec3 worldPosition) {
    computeLighting_RenderChunk_Vertex(vertInput, vertOutput, worldPosition);
}
void StandardTemplate_Opaque_Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    StandardTemplate_VertShared(vertInput, vertOutput);
}
void main() {
    VertexInput vertexInput;
    VertexOutput vertexOutput;
    vertexInput.color0 = (a_color0);
    vertexInput.lightmapUV = (a_texcoord1);
    vertexInput.normal = (a_normal);
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    vertexInput.pbrTextureId = int(a_texcoord4);
    #endif
    vertexInput.position = (a_position);
    vertexInput.tangent = (a_tangent);
    vertexInput.texcoord0 = (a_texcoord0);
    #ifdef INSTANCING__ON
    vertexInput.instanceData0 = i_data1;
    vertexInput.instanceData1 = i_data2;
    vertexInput.instanceData2 = i_data3;
    #endif
    vertexOutput.bitangent = vec3(0, 0, 0);
    vertexOutput.color0 = vec4(0, 0, 0, 0);
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    vertexOutput.frontFacing = 0;
    #endif
    vertexOutput.lightmapUV = vec2(0, 0);
    vertexOutput.normal = vec3(0, 0, 0);
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    vertexOutput.pbrTextureId = 0;
    #endif
    vertexOutput.tangent = vec3(0, 0, 0);
    vertexOutput.texcoord0 = vec2(0, 0);
    vertexOutput.worldPos = vec3(0, 0, 0);
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
    StandardTemplate_Opaque_Vert(vertexInput, vertexOutput);
    v_bitangent = vertexOutput.bitangent;
    v_color0 = vertexOutput.color0;
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    v_frontFacing = vertexOutput.frontFacing;
    #endif
    v_lightmapUV = vertexOutput.lightmapUV;
    v_normal = vertexOutput.normal;
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    v_pbrTextureId = vertexOutput.pbrTextureId;
    #endif
    v_tangent = vertexOutput.tangent;
    v_texcoord0 = vertexOutput.texcoord0;
    v_worldPos = vertexOutput.worldPos;
    gl_Position = vertexOutput.position;
}

