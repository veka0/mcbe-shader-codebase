/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - DEPTH_ONLY_PASS
* - OPAQUE_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* Fancy:
* - FANCY__OFF
* - FANCY__ON
*
* Instancing:
* - INSTANCING__OFF
* - INSTANCING__ON
*
* MultiColorTint:
* - MULTI_COLOR_TINT__OFF (not used)
* - MULTI_COLOR_TINT__ON (not used)
*/

$input a_color0, a_normal, a_position, a_texcoord0
#ifdef INSTANCING__ON
$input i_data1, i_data2, i_data3
#endif
$output v_color0, v_fog, v_light, v_texcoord0, v_worldPos
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

uniform vec4 FogControl;
uniform vec4 ChangeColor;
uniform vec4 OverlayColor;
uniform vec4 ColorBased;
uniform vec4 FogColor;
uniform vec4 LightDiffuseColorAndIlluminance;
uniform vec4 LightWorldSpaceDirection;
uniform vec4 MaterialID;
uniform vec4 MultiplicativeTintColor;
uniform vec4 SubPixelOffset;
uniform vec4 TileLightColor;
uniform vec4 TileLightIntensity;
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
    vec4 color0;
    vec4 normal;
    vec3 position;
    vec2 texcoord0;
    #ifdef INSTANCING__ON
    vec4 instanceData0;
    vec4 instanceData1;
    vec4 instanceData2;
    #endif
};

struct VertexOutput {
    vec4 position;
    vec4 color0;
    vec4 fog;
    vec4 light;
    vec2 texcoord0;
    vec3 worldPos;
};

struct FragmentInput {
    vec4 color0;
    vec4 fog;
    vec4 light;
    vec2 texcoord0;
    vec3 worldPos;
};

struct FragmentOutput {
    vec4 Color0;
};

struct StandardSurfaceInput {
    vec2 UV;
    vec3 Color;
    float Alpha;
    vec4 fog;
    vec4 light;
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

vec4 jitterVertexPosition(vec3 worldPosition) {
    mat4 offsetProj = Proj;
    offsetProj[2][0] += SubPixelOffset.x; // Attention!
    offsetProj[2][1] -= SubPixelOffset.y; // Attention!
    return ((offsetProj) * (((View) * (vec4(worldPosition, 1.0f))))); // Attention!
}
float calculateFogIntensityVanilla(float cameraDepth, float maxDistance, float fogStart, float fogEnd) {
    float distance = cameraDepth / maxDistance;
    return clamp((distance - fogStart) / (fogEnd - fogStart), 0.0, 1.0);
}
float calculateLightIntensity(const mat4 world, const vec4 normal, const vec4 tileLightColor) {
    #ifdef FANCY__OFF
    return 1.0;
    #endif
    #ifdef FANCY__ON
    const float AMBIENT = 0.45;
    const float XFAC = -0.1;
    const float ZFAC = 0.1;
    vec3 N = normalize(((world) * (normal))).xyz; // Attention!
    N.y *= tileLightColor.a;
    float yLight = (1.0 + N.y) * 0.5;
    return yLight * (1.0 - AMBIENT) + N.x * N.x * XFAC + N.z * N.z * ZFAC + AMBIENT;
    #endif
}
void ItemInHandVert(VertexInput vertInput, inout VertexOutput vertOutput) {
    vertOutput.texcoord0 = vertInput.texcoord0;
    float lightIntensity = calculateLightIntensity(World, vec4(vertInput.normal.xyz, 0.0), TileLightColor);
    lightIntensity += OverlayColor.a * 0.35;
    vertOutput.light = vec4(lightIntensity * TileLightColor.rgb, 1.0);
}
void ItemInHandFogVert(StandardVertexInput vertInput, inout VertexOutput vertOutput) {
    vertOutput.position = jitterVertexPosition(vertInput.worldPos);
    float cameraDepth = vertOutput.position.z;
    float fogIntensity = calculateFogIntensityVanilla(cameraDepth, FogControl.z, FogControl.x, FogControl.y);
    vertOutput.fog = vec4(FogColor.rgb, fogIntensity);
}
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
#ifndef DEPTH_ONLY_PASS
void StandardTemplate_LightingVertexFunctionIdentity(VertexInput vertInput, inout VertexOutput vertOutput, vec3 worldPosition) {
}
#endif

void StandardTemplate_InvokeVertexPreprocessFunction(inout VertexInput vertInput, inout VertexOutput vertOutput);
void StandardTemplate_InvokeVertexOverrideFunction(StandardVertexInput vertInput, inout VertexOutput vertOutput);
#ifndef DEPTH_ONLY_PASS
void StandardTemplate_InvokeLightingVertexFunction(VertexInput vertInput, inout VertexOutput vertOutput, vec3 worldPosition);
#endif
struct DirectionalLight {
    vec3 ViewSpaceDirection;
    vec3 Intensity;
};

#ifndef DEPTH_ONLY_PASS
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
#endif
void StandardTemplate_InvokeVertexPreprocessFunction(inout VertexInput vertInput, inout VertexOutput vertOutput) {
    ItemInHandVert(vertInput, vertOutput);
}
void StandardTemplate_InvokeVertexOverrideFunction(StandardVertexInput vertInput, inout VertexOutput vertOutput) {
    ItemInHandFogVert(vertInput, vertOutput);
}
#ifndef DEPTH_ONLY_PASS
void StandardTemplate_InvokeLightingVertexFunction(VertexInput vertInput, inout VertexOutput vertOutput, vec3 worldPosition) {
    StandardTemplate_LightingVertexFunctionIdentity(vertInput, vertOutput, worldPosition);
}
void StandardTemplate_Opaque_Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    StandardTemplate_VertShared(vertInput, vertOutput);
}
#endif
#ifdef DEPTH_ONLY_PASS
void StandardTemplate_DepthOnly_Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    StandardTemplate_InvokeVertexPreprocessFunction(vertInput, vertOutput);
    StandardVertexInput stdInput;
    stdInput.vertInput = vertInput;
    StandardTemplate_VertSharedTransform(stdInput, vertOutput);
    StandardTemplate_InvokeVertexOverrideFunction(stdInput, vertOutput);
}
#endif
void main() {
    VertexInput vertexInput;
    VertexOutput vertexOutput;
    vertexInput.color0 = (a_color0);
    vertexInput.normal = (a_normal);
    vertexInput.position = (a_position);
    vertexInput.texcoord0 = (a_texcoord0);
    #ifdef INSTANCING__ON
    vertexInput.instanceData0 = i_data1;
    vertexInput.instanceData1 = i_data2;
    vertexInput.instanceData2 = i_data3;
    #endif
    vertexOutput.color0 = vec4(0, 0, 0, 0);
    vertexOutput.fog = vec4(0, 0, 0, 0);
    vertexOutput.light = vec4(0, 0, 0, 0);
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
    #ifndef DEPTH_ONLY_PASS
    StandardTemplate_Opaque_Vert(vertexInput, vertexOutput);
    #endif
    #ifdef DEPTH_ONLY_PASS
    StandardTemplate_DepthOnly_Vert(vertexInput, vertexOutput);
    #endif
    v_color0 = vertexOutput.color0;
    v_fog = vertexOutput.fog;
    v_light = vertexOutput.light;
    v_texcoord0 = vertexOutput.texcoord0;
    v_worldPos = vertexOutput.worldPos;
    gl_Position = vertexOutput.position;
}

