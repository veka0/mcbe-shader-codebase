/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* FlipOcclusion:
* - FLIP_OCCLUSION__OFF (not used)
* - FLIP_OCCLUSION__ON (not used)
*
* Instancing:
* - INSTANCING__OFF
* - INSTANCING__ON
*
* NoOcclusion:
* - NO_OCCLUSION__OFF (not used)
* - NO_OCCLUSION__ON (not used)
*
* NoVariety:
* - NO_VARIETY__OFF
* - NO_VARIETY__ON (not used)
*/

$input a_color0, a_position, a_texcoord0
#ifdef INSTANCING__ON
$input i_data1, i_data2, i_data3
#endif
$output v_color0, v_fog, v_occlusionHeight, v_occlusionUV, v_texcoord0, v_worldPos
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
float fmod(float _a, float _b) {
    return _a - _b * trunc(_a / _b);
}
vec2 fmod(vec2 _a, vec2 _b) {
    return vec2(fmod(_a.x, _b.x), fmod(_a.y, _b.y));
}
vec3 fmod(vec3 _a, vec3 _b) {
    return vec3(fmod(_a.x, _b.x), fmod(_a.y, _b.y), fmod(_a.z, _b.z));
}
vec4 fmod(vec4 _a, vec4 _b) {
    return vec4(fmod(_a.x, _b.x), fmod(_a.y, _b.y), fmod(_a.z, _b.z), fmod(_a.w, _b.w));
}
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

uniform vec4 Dimensions;
uniform vec4 ViewPosition;
uniform vec4 UVOffsetAndScale;
uniform vec4 FogAndDistanceControl;
uniform vec4 OcclusionHeightOffset;
uniform vec4 FogColor;
uniform vec4 LightDiffuseColorAndIlluminance;
uniform vec4 Velocity;
uniform vec4 LightWorldSpaceDirection;
uniform vec4 MaterialID;
uniform vec4 PositionBaseOffset;
uniform vec4 PositionForwardOffset;
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
    float occlusionHeight;
    vec2 occlusionUV;
    vec2 texcoord0;
    vec3 worldPos;
};

struct FragmentInput {
    vec4 color0;
    vec4 fog;
    float occlusionHeight;
    vec2 occlusionUV;
    vec2 texcoord0;
    vec3 worldPos;
};

struct FragmentOutput {
    vec4 Color0;
};

SAMPLER2D_AUTOREG(s_LightingTexture);
SAMPLER2D_AUTOREG(s_OcclusionTexture);
SAMPLER2D_AUTOREG(s_WeatherTexture);
struct StandardSurfaceInput {
    vec2 UV;
    vec3 Color;
    float Alpha;
    vec4 fog;
    float occlusionHeight;
    vec2 occlusionUV;
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

float calculateFogIntensityVanilla(float cameraDepth, float maxDistance, float fogStart, float fogEnd) {
    float distance = cameraDepth / maxDistance;
    return clamp((distance - fogStart) / (fogEnd - fogStart), 0.0, 1.0);
}
vec3 calculateWorldSpacePosition(StandardVertexInput vertInput) {
    const float PARTICLE_BOX_DIMENSIONS = 30.0;
    const vec3 PARTICLE_BOX = vec3(PARTICLE_BOX_DIMENSIONS, PARTICLE_BOX_DIMENSIONS, PARTICLE_BOX_DIMENSIONS);
    vec3 worldSpacePosition = fmod(vertInput.vertInput.position + PositionBaseOffset.xyz, PARTICLE_BOX);
    worldSpacePosition -= PARTICLE_BOX * 0.5f;
    worldSpacePosition += PositionForwardOffset.xyz;
    return worldSpacePosition;
}
void WeatherVert(StandardVertexInput vertInput, inout VertexOutput vertOutput) {
    vertOutput.texcoord0 = UVOffsetAndScale.xy + (vertInput.vertInput.texcoord0 * UVOffsetAndScale.zw);
    #ifdef NO_VARIETY__OFF
    float spriteSelector = vertInput.vertInput.color0.x * 255.0;
    vertOutput.texcoord0.x += spriteSelector * UVOffsetAndScale.z;
    #endif
    vec3 worldSpacePosition = calculateWorldSpacePosition(vertInput);
    vec3 worldSpacePositionBottom = worldSpacePosition;
    vec3 worldSpacePositionTop = worldSpacePositionBottom + (Velocity.xyz * Dimensions.y);
    vec4 screenSpacePositionBottom = ((WorldViewProj) * (vec4(worldSpacePositionBottom, 1.0))); // Attention!
    vec4 screenSpacePositionTop = ((WorldViewProj) * (vec4(worldSpacePositionTop, 1.0))); // Attention!
    vec2 screenSpaceUpDirection = (screenSpacePositionTop.xy / screenSpacePositionTop.w) - (screenSpacePositionBottom.xy / screenSpacePositionBottom.w);
    vec2 screenSpaceRightDirection = normalize(vec2(-screenSpaceUpDirection.y, screenSpaceUpDirection.x));
    vertOutput.position = mix(screenSpacePositionTop, screenSpacePositionBottom, vertInput.vertInput.texcoord0.y);
    vertOutput.position.xy += (0.5 - vertInput.vertInput.texcoord0.x) * screenSpaceRightDirection * Dimensions.x;
    vec2 occlusionUV = worldSpacePosition.xz;
    occlusionUV += ViewPosition.xz;
    occlusionUV *= 1.0 / 64.0;
    occlusionUV += 0.5;
    vertOutput.occlusionUV = occlusionUV;
    float occlusionHeight = worldSpacePosition.y;
    occlusionHeight += ViewPosition.y - 0.5;
    occlusionHeight *= 1.0 / 255.0;
    vertOutput.occlusionHeight = occlusionHeight;
    float fogIntensity = calculateFogIntensityVanilla(vertOutput.position.z, FogAndDistanceControl.z, FogAndDistanceControl.x, FogAndDistanceControl.y);
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
void StandardTemplate_VertexPreprocessIdentity(VertexInput vertInput, inout VertexOutput vertOutput) {
}
void StandardTemplate_LightingVertexFunctionIdentity(VertexInput vertInput, inout VertexOutput vertOutput, vec3 worldPosition) {
}

void StandardTemplate_InvokeVertexPreprocessFunction(inout VertexInput vertInput, inout VertexOutput vertOutput);
void StandardTemplate_InvokeVertexOverrideFunction(StandardVertexInput vertInput, inout VertexOutput vertOutput);
void StandardTemplate_InvokeLightingVertexFunction(VertexInput vertInput, inout VertexOutput vertOutput, vec3 worldPosition);
struct DirectionalLight {
    vec3 ViewSpaceDirection;
    vec3 Intensity;
};

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
    WeatherVert(vertInput, vertOutput);
}
void StandardTemplate_InvokeLightingVertexFunction(VertexInput vertInput, inout VertexOutput vertOutput, vec3 worldPosition) {
    StandardTemplate_LightingVertexFunctionIdentity(vertInput, vertOutput, worldPosition);
}
void StandardTemplate_Opaque_Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    StandardTemplate_VertShared(vertInput, vertOutput);
}
void main() {
    VertexInput vertexInput;
    VertexOutput vertexOutput;
    vertexInput.color0 = (a_color0);
    vertexInput.position = (a_position);
    vertexInput.texcoord0 = (a_texcoord0);
    #ifdef INSTANCING__ON
    vertexInput.instanceData0 = i_data1;
    vertexInput.instanceData1 = i_data2;
    vertexInput.instanceData2 = i_data3;
    #endif
    vertexOutput.color0 = vec4(0, 0, 0, 0);
    vertexOutput.fog = vec4(0, 0, 0, 0);
    vertexOutput.occlusionHeight = 0.0;
    vertexOutput.occlusionUV = vec2(0, 0);
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
    v_color0 = vertexOutput.color0;
    v_fog = vertexOutput.fog;
    v_occlusionHeight = vertexOutput.occlusionHeight;
    v_occlusionUV = vertexOutput.occlusionUV;
    v_texcoord0 = vertexOutput.texcoord0;
    v_worldPos = vertexOutput.worldPos;
    gl_Position = vertexOutput.position;
}

