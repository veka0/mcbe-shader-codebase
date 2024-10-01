/*
* Available Macros:
*
* Passes:
* - FORCE_FORWARD_PBR_OPAQUE_PASS (not used)
*
* Instancing:
* - INSTANCING__OFF
* - INSTANCING__ON
*/

$input a_color0, a_position, a_texcoord0
#ifdef INSTANCING__ON
$input i_data1, i_data2, i_data3
#endif
$output v_colorUV, v_encodedPlane, v_fog, v_parallaxUV
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

uniform vec4 EndPortalEmissiveMultiplierAndDesaturation;
uniform vec4 FogAndDistanceControl;
uniform vec4 FogColor;
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

struct PBRFragmentInfo {
    vec2 lightClusterUV;
    vec3 worldPosition;
    vec3 viewPosition;
    vec3 ndcPosition;
    vec3 worldNormal;
    vec3 viewNormal;
    vec3 rf0;
    vec3 albedo;
    float metalness;
    float roughness;
    float emissive;
    float subsurface;
    float blockAmbientContribution;
    float skyAmbientContribution;
    vec2 causticsMultiplier;
};

struct PBRLightingContributions {
    vec3 directDiffuse;
    vec3 directSpecular;
    vec3 indirectDiffuse;
    vec3 indirectSpecular;
    vec3 emissive;
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
    vec2 colorUV;
    float encodedPlane;
    vec4 fog;
    vec2 parallaxUV;
};

struct FragmentInput {
    vec2 colorUV;
    float encodedPlane;
    vec4 fog;
    vec2 parallaxUV;
};

struct FragmentOutput {
    vec4 Color0;
};

SAMPLER2D_AUTOREG(s_ParallaxTexture);
SAMPLER2D_AUTOREG(s_ColorTexture);
float calculateFogIntensityVanilla(float cameraDepth, float maxDistance, float fogStart, float fogEnd) {
    float distance = cameraDepth / maxDistance;
    return clamp((distance - fogStart) / (fogEnd - fogStart), 0.0, 1.0);
}
struct ColorTransform {
    float hue;
    float saturation;
    float luminance;
};

void EndPortalVert(VertexInput vertInput, inout VertexOutput vertOutput) {
    #ifdef INSTANCING__OFF
    vec3 worldPosition = ((World) * (vec4(vertInput.position, 1.0))).xyz; // Attention!
    #endif
    #ifdef INSTANCING__ON
    mat4 model;
    model[0] = vec4(vertInput.instanceData0.x, vertInput.instanceData1.x, vertInput.instanceData2.x, 0);
    model[1] = vec4(vertInput.instanceData0.y, vertInput.instanceData1.y, vertInput.instanceData2.y, 0);
    model[2] = vec4(vertInput.instanceData0.z, vertInput.instanceData1.z, vertInput.instanceData2.z, 0);
    model[3] = vec4(vertInput.instanceData0.w, vertInput.instanceData1.w, vertInput.instanceData2.w, 1);
    vec3 worldPosition = instMul(model, vec4(vertInput.position, 1.0)).xyz;
    #endif
    vertOutput.position = ((ViewProj) * (vec4(worldPosition, 1.0))); // Attention!
    vertOutput.encodedPlane = vertInput.color0.a;
    vertOutput.colorUV = vertInput.texcoord0;
    const vec4 PLANE_OFFSET = vec4(0.5, 0.5, 0.5, 0.0);
    const vec4 PLANE_SCALE = vec4(2.0, 2.0, 2.0, 32.0);
    vec4 planeData = (vertInput.color0 - PLANE_OFFSET) * PLANE_SCALE;
    vec3 planeNormal = planeData.xyz;
    float planeDistance = planeData.w;
    vec3 viewRay = worldPosition;
    float t = dot(viewRay - (planeNormal * planeDistance), planeNormal) / dot(viewRay, planeNormal);
    vec3 parallaxPositionInWorld = (t * viewRay) + ViewPositionAndTime.xyz;
    vec3 normalMask = abs(planeNormal);
    vec2 raycastUV = parallaxPositionInWorld.yz * normalMask.x;
    raycastUV += parallaxPositionInWorld.xz * normalMask.y;
    raycastUV += parallaxPositionInWorld.xy * normalMask.z;
    raycastUV = raycastUV / 16.0;
    const float UV_ROTATION = 3.1415926535897 * (5.0 / 7.0);
    float rotS = sin(planeDistance * UV_ROTATION);
    float rotC = cos(planeDistance * UV_ROTATION);
    vec2 parallaxUV = ((mat2(vec2(rotC, rotS), vec2(-rotS, rotC))) * (raycastUV)); // Attention!
    parallaxUV += vec2(rotC, rotS) * planeDistance;
    parallaxUV.y += ViewPositionAndTime.w / 256.0;
    const float PARALLAX_MOD = 64.0;
    parallaxUV = fmod(parallaxUV, vec2(PARALLAX_MOD, PARALLAX_MOD));
    vertOutput.parallaxUV = parallaxUV;
    float cameraDepth = length(worldPosition);
    float fogIntensity = calculateFogIntensityVanilla(cameraDepth, FogAndDistanceControl.z, FogAndDistanceControl.x, FogAndDistanceControl.y);
    vertOutput.fog = vec4(FogColor.rgb, fogIntensity);
}
void Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    EndPortalVert(vertInput, vertOutput);
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
    vertexOutput.colorUV = vec2(0, 0);
    vertexOutput.encodedPlane = 0.0;
    vertexOutput.fog = vec4(0, 0, 0, 0);
    vertexOutput.parallaxUV = vec2(0, 0);
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
    v_colorUV = vertexOutput.colorUV;
    v_encodedPlane = vertexOutput.encodedPlane;
    v_fog = vertexOutput.fog;
    v_parallaxUV = vertexOutput.parallaxUV;
    gl_Position = vertexOutput.position;
}

