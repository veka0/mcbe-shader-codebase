#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS
* - DEPTH_ONLY_PASS
* - OPAQUE_PASS
* - TRANSPARENT_PASS
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

#define attribute in
#define varying out
attribute vec4 a_color0;
attribute vec4 a_normal;
attribute vec3 a_position;
attribute vec2 a_texcoord0;
attribute vec4 a_texcoord1;
#ifdef INSTANCING__ON
attribute vec4 i_data1;
attribute vec4 i_data2;
attribute vec4 i_data3;
#endif
varying vec4 v_color0;
varying vec4 v_fog;
varying vec4 v_glintUV;
varying vec4 v_light;
varying vec2 v_texcoord0;
struct NoopSampler {
    int noop;
};

#ifdef INSTANCING__ON
vec3 instMul(vec3 _vec, mat3 _mtx) {
    return ((_vec) * (_mtx));
}
vec3 instMul(mat3 _mtx, vec3 _vec) {
    return ((_mtx) * (_vec));
}
vec4 instMul(vec4 _vec, mat4 _mtx) {
    return ((_vec) * (_mtx));
}
vec4 instMul(mat4 _mtx, vec4 _vec) {
    return ((_mtx) * (_vec));
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

uniform vec4 u_viewRect;
uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 FogControl;
uniform vec4 ChangeColor;
uniform vec4 u_viewTexel;
uniform mat4 u_invView;
uniform mat4 u_invProj;
uniform mat4 u_viewProj;
uniform vec4 OverlayColor;
uniform mat4 u_invViewProj;
uniform mat4 u_prevViewProj;
uniform mat4 u_model[4];
uniform mat4 u_modelView;
uniform mat4 u_modelViewProj;
uniform vec4 u_prevWorldPosOffset;
uniform vec4 u_alphaRef4;
uniform vec4 LightWorldSpaceDirection;
uniform vec4 TileLightIntensity;
uniform vec4 UVScale;
uniform vec4 LightDiffuseColorAndIlluminance;
uniform vec4 ColorBased;
uniform vec4 SubPixelOffset;
uniform vec4 FogColor;
uniform vec4 MultiplicativeTintColor;
uniform vec4 TileLightColor;
uniform vec4 UVAnimation;
uniform vec4 GlintColor;
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
    #if defined(ALPHA_TEST_PASS)|| defined(TRANSPARENT_PASS)
    vec4 normal;
    #endif
    vec3 position;
    #if defined(DEPTH_ONLY_PASS)|| defined(OPAQUE_PASS)
    vec4 normal;
    #endif
    vec2 texcoord0;
    #if defined(ALPHA_TEST_PASS)|| defined(TRANSPARENT_PASS)
    vec4 glintUV;
    #endif
    vec4 color0;
    #if defined(INSTANCING__ON)&&(defined(DEPTH_ONLY_PASS)|| defined(OPAQUE_PASS))
    vec4 glintUV;
    #endif
    #ifdef INSTANCING__ON
    vec4 instanceData0;
    vec4 instanceData1;
    vec4 instanceData2;
    #endif
    #if defined(INSTANCING__OFF)&&(defined(DEPTH_ONLY_PASS)|| defined(OPAQUE_PASS))
    vec4 glintUV;
    #endif
};

struct VertexOutput {
    vec4 position;
    vec2 texcoord0;
    #if defined(ALPHA_TEST_PASS)|| defined(TRANSPARENT_PASS)
    vec4 glintUV;
    #endif
    vec4 color0;
    #if defined(DEPTH_ONLY_PASS)|| defined(OPAQUE_PASS)
    vec4 glintUV;
    #endif
    vec4 light;
    vec4 fog;
};

struct FragmentInput {
    vec2 texcoord0;
    #if defined(ALPHA_TEST_PASS)|| defined(TRANSPARENT_PASS)
    vec4 glintUV;
    #endif
    vec4 color0;
    #if defined(DEPTH_ONLY_PASS)|| defined(OPAQUE_PASS)
    vec4 glintUV;
    #endif
    vec4 light;
    vec4 fog;
};

struct FragmentOutput {
    vec4 Color0;
};

uniform lowp sampler2D s_GlintTexture;
struct StandardSurfaceInput {
    vec2 UV;
    vec3 Color;
    float Alpha;
    vec4 glintUV;
    #if defined(ALPHA_TEST_PASS)|| defined(TRANSPARENT_PASS)
    vec4 fog;
    #endif
    vec4 light;
    #if defined(DEPTH_ONLY_PASS)|| defined(OPAQUE_PASS)
    vec4 fog;
    #endif
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
    vec3 AmbientLight;
    vec3 ViewSpaceNormal;
};

vec4 jitterVertexPosition(vec3 worldPosition) {
    mat4 offsetProj = Proj;
    offsetProj[2][0] += SubPixelOffset.x;
    offsetProj[2][1] -= SubPixelOffset.y;
    return ((offsetProj) * (((View) * (vec4(worldPosition, 1.0f)))));
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
    vec3 N = normalize(((world) * (normal))).xyz;
    N.y *= tileLightColor.a;
    float yLight = (1.0 + N.y) * 0.5;
    return yLight * (1.0 - AMBIENT) + N.x * N.x * XFAC + N.z * N.z * ZFAC + AMBIENT;
    #endif
}
void ItemInHandFogVert(StandardVertexInput vertInput, inout VertexOutput vertOutput) {
    vertOutput.position = jitterVertexPosition(vertInput.worldPos);
    float cameraDepth = vertOutput.position.z;
    float fogIntensity = calculateFogIntensityVanilla(cameraDepth, FogControl.z, FogControl.x, FogControl.y);
    vertOutput.fog = vec4(FogColor.rgb, fogIntensity);
}
vec2 calculateLayerUV(const vec2 origUV, const float offset, const float rotation, const vec2 scale) {
    vec2 uv = origUV;
    uv -= 0.5;
    float rsin = sin(rotation);
    float rcos = cos(rotation);
    uv = ((uv) * (mat2(rcos, - rsin, rsin, rcos)));
    uv.x += offset;
    uv += 0.5;
    return uv * scale;
}
void ItemInHandColorGlintVert(VertexInput vertInput, inout VertexOutput vertOutput) {
    vertOutput.texcoord0 = vertInput.texcoord0;
    vertOutput.glintUV.xy = calculateLayerUV(vertInput.texcoord0, UVAnimation.x, UVAnimation.z, UVScale.xy);
    vertOutput.glintUV.zw = calculateLayerUV(vertInput.texcoord0, UVAnimation.y, UVAnimation.w, UVScale.xy);
    float lightIntensity = calculateLightIntensity(World, vec4(vertInput.normal.xyz, 0.0), TileLightColor);
    lightIntensity += OverlayColor.a * 0.35;
    vertOutput.light = vec4(lightIntensity * TileLightColor.rgb, 1.0);
}
struct CompositingOutput {
    vec3 mLitColor;
};

void StandardTemplate_VertSharedTransform(VertexInput vertInput, inout VertexOutput vertOutput, out vec3 worldPosition) {
    #ifdef INSTANCING__OFF
    vec3 wpos = ((World) * (vec4(vertInput.position, 1.0))).xyz;
    #endif
    #ifdef INSTANCING__ON
    mat4 model;
    model[0] = vec4(vertInput.instanceData0.x, vertInput.instanceData1.x, vertInput.instanceData2.x, 0);
    model[1] = vec4(vertInput.instanceData0.y, vertInput.instanceData1.y, vertInput.instanceData2.y, 0);
    model[2] = vec4(vertInput.instanceData0.z, vertInput.instanceData1.z, vertInput.instanceData2.z, 0);
    model[3] = vec4(vertInput.instanceData0.w, vertInput.instanceData1.w, vertInput.instanceData2.w, 1);
    vec3 wpos = instMul(model, vec4(vertInput.position, 1.0)).xyz;
    #endif
    vertOutput.position = ((ViewProj) * (vec4(wpos, 1.0)));
    worldPosition = wpos;
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
    StandardTemplate_VertSharedTransform(vertInput, vertOutput, stdInput.worldPos);
    vertOutput.texcoord0 = vertInput.texcoord0;
    vertOutput.color0 = vertInput.color0;
    StandardTemplate_InvokeVertexOverrideFunction(stdInput, vertOutput);
    StandardTemplate_InvokeLightingVertexFunction(vertInput, vertOutput, stdInput.worldPos);
}
#endif
void StandardTemplate_InvokeVertexPreprocessFunction(inout VertexInput vertInput, inout VertexOutput vertOutput) {
    ItemInHandColorGlintVert(vertInput, vertOutput);
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
    StandardTemplate_VertSharedTransform(vertInput, vertOutput, stdInput.worldPos);
    StandardTemplate_InvokeVertexOverrideFunction(stdInput, vertOutput);
}
#endif
void main() {
    VertexInput vertexInput;
    VertexOutput vertexOutput;
    #if defined(ALPHA_TEST_PASS)|| defined(TRANSPARENT_PASS)
    vertexInput.normal = (a_normal);
    #endif
    vertexInput.position = (a_position);
    #if defined(DEPTH_ONLY_PASS)|| defined(OPAQUE_PASS)
    vertexInput.normal = (a_normal);
    #endif
    vertexInput.texcoord0 = (a_texcoord0);
    #if defined(ALPHA_TEST_PASS)|| defined(TRANSPARENT_PASS)
    vertexInput.glintUV = (a_texcoord1);
    #endif
    vertexInput.color0 = (a_color0);
    #if defined(OPAQUE_PASS)||(defined(DEPTH_ONLY_PASS)&& defined(INSTANCING__ON))
    vertexInput.glintUV = (a_texcoord1);
    #endif
    #ifdef INSTANCING__ON
    vertexInput.instanceData0 = i_data1;
    vertexInput.instanceData1 = i_data2;
    vertexInput.instanceData2 = i_data3;
    #endif
    #if defined(DEPTH_ONLY_PASS)&& defined(INSTANCING__OFF)
    vertexInput.glintUV = (a_texcoord1);
    #endif
    vertexOutput.texcoord0 = vec2(0, 0);
    #if defined(ALPHA_TEST_PASS)|| defined(TRANSPARENT_PASS)
    vertexOutput.glintUV = vec4(0, 0, 0, 0);
    #endif
    vertexOutput.color0 = vec4(0, 0, 0, 0);
    #if defined(DEPTH_ONLY_PASS)|| defined(OPAQUE_PASS)
    vertexOutput.glintUV = vec4(0, 0, 0, 0);
    #endif
    vertexOutput.light = vec4(0, 0, 0, 0);
    vertexOutput.fog = vec4(0, 0, 0, 0);
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
    v_texcoord0 = vertexOutput.texcoord0;
    #if defined(ALPHA_TEST_PASS)|| defined(TRANSPARENT_PASS)
    v_glintUV = vertexOutput.glintUV;
    #endif
    v_color0 = vertexOutput.color0;
    #if defined(DEPTH_ONLY_PASS)|| defined(OPAQUE_PASS)
    v_glintUV = vertexOutput.glintUV;
    #endif
    v_light = vertexOutput.light;
    v_fog = vertexOutput.fog;
    gl_Position = vertexOutput.position;
}

