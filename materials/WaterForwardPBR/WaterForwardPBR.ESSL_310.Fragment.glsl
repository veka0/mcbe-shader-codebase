#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_PASS
* - DO_WATER_SHADING_PASS
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON
*
* RenderAsBillboards:
* - RENDER_AS_BILLBOARDS__OFF (not used)
* - RENDER_AS_BILLBOARDS__ON (not used)
*
* Seasons:
* - SEASONS__OFF (not used)
* - SEASONS__ON (not used)
*/

#define shadow2D(_sampler, _coord)texture(_sampler, _coord)
#define shadow2DArray(_sampler, _coord)texture(_sampler, _coord)
#define shadow2DProj(_sampler, _coord)textureProj(_sampler, _coord)
#if GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif
#define attribute in
#define varying in
#ifdef DEPTH_ONLY_PASS
out vec4 bgfx_FragColor;
#endif
#ifdef DO_WATER_SHADING_PASS
out vec4 bgfx_FragData[gl_MaxDrawBuffers];
#endif
varying vec3 v_bitangent;
varying vec4 v_color0;
varying vec2 v_lightmapUV;
varying vec3 v_normal;
varying vec3 v_tangent;
centroid varying vec2 v_texcoord0;
varying vec3 v_worldPos;
struct NoopSampler {
    int noop;
};

#ifdef DEPTH_ONLY_PASS
vec4 textureSample(mediump sampler2D _sampler, vec2 _coord) {
    return texture(_sampler, _coord);
}
vec4 textureSample(mediump sampler3D _sampler, vec3 _coord) {
    return texture(_sampler, _coord);
}
vec4 textureSample(mediump samplerCube _sampler, vec3 _coord) {
    return texture(_sampler, _coord);
}
vec4 textureSample(mediump sampler2D _sampler, vec2 _coord, float _lod) {
    return textureLod(_sampler, _coord, _lod);
}
vec4 textureSample(mediump sampler3D _sampler, vec3 _coord, float _lod) {
    return textureLod(_sampler, _coord, _lod);
}
vec4 textureSample(mediump sampler2DArray _sampler, vec3 _coord) {
    return texture(_sampler, _coord);
}
vec4 textureSample(mediump sampler2DArray _sampler, vec3 _coord, float _lod) {
    return textureLod(_sampler, _coord, _lod);
}
vec4 textureSample(NoopSampler noopsampler, vec2 _coord) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec3 _coord) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec2 _coord, float _lod) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec3 _coord, float _lod) {
    return vec4(0, 0, 0, 0);
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
uniform mat4 PointLightProj;
uniform mat4 u_view;
uniform vec4 PointLightShadowParams1;
uniform vec4 SunDir;
uniform vec4 u_viewTexel;
uniform vec4 ShadowBias;
uniform vec4 ShadowSlopeBias;
uniform mat4 u_invView;
uniform mat4 u_viewProj;
uniform mat4 u_invProj;
uniform mat4 u_invViewProj;
uniform mat4 u_prevViewProj;
uniform mat4 u_model[4];
uniform vec4 BlockBaseAmbientLightColorIntensity;
uniform vec4 PointLightAttenuationWindowEnabled;
uniform vec4 ManhattanDistAttenuationEnabled;
uniform vec4 DefaultWaterCoefficient;
uniform mat4 u_modelView;
uniform mat4 u_modelViewProj;
uniform vec4 RedCentralWaterCoefficient;
uniform vec4 u_prevWorldPosOffset;
uniform vec4 CascadeShadowResolutions;
uniform vec4 u_alphaRef4;
uniform vec4 FogAndDistanceControl;
uniform vec4 AtmosphericScattering;
uniform vec4 ClusterSize;
uniform vec4 SkyZenithColor;
uniform vec4 AtmosphericScatteringToggles;
uniform vec4 RenderChunkFogAlpha;
uniform vec4 BlueCentralWaterCoefficient;
uniform vec4 ClusterNearFarWidthHeight;
uniform vec4 CameraLightIntensity;
uniform vec4 ViewPositionAndTime;
uniform vec4 WorldOrigin;
uniform mat4 CloudShadowProj;
uniform vec4 ClusterDimensions;
uniform vec4 PreExposureEnabled;
uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform vec4 SubsurfaceScatteringContribution;
uniform vec4 DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight;
uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
uniform vec4 ShadowParams;
uniform vec4 MoonColor;
uniform vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidth;
uniform vec4 ShadowPCFWidth;
uniform vec4 FogColor;
uniform vec4 FogSkyBlend;
uniform vec4 GlobalRoughness;
uniform vec4 SkyHorizonColor;
uniform vec4 GreenCentralWaterCoefficient;
uniform vec4 LightDiffuseColorAndIlluminance;
uniform vec4 LightWorldSpaceDirection;
uniform vec4 PointLightDiffuseFadeOutParameters;
uniform vec4 MoonDir;
uniform mat4 PlayerShadowProj;
uniform vec4 PointLightAttenuationWindow;
uniform vec4 SunColor;
uniform vec4 PointLightSpecularFadeOutParameters;
uniform vec4 SkyAmbientLightColorIntensity;
uniform vec4 SubPixelOffset;
uniform vec4 VolumeDimensions;
uniform vec4 VolumeNearFar;
uniform vec4 VolumeScatteringEnabled;
vec4 ViewRect;
mat4 Proj;
mat4 View;
vec4 ViewTexel;
mat4 InvView;
mat4 ViewProj;
mat4 InvProj;
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
    vec2 lightmapUV;
    vec3 normal;
    vec3 tangent;
    vec2 texcoord0;
    vec3 worldPos;
};

struct FragmentInput {
    vec3 bitangent;
    vec4 color0;
    vec2 lightmapUV;
    vec3 normal;
    vec3 tangent;
    vec2 texcoord0;
    vec3 worldPos;
};

struct FragmentOutput {
    vec4 Color0;
};

uniform lowp sampler2D s_LightMapTexture;
uniform lowp sampler2D s_MatTexture;
uniform highp sampler2DShadow s_PlayerShadowMap;
uniform highp sampler2DArrayShadow s_PointLightShadowTextureArray;
uniform lowp sampler2D s_PreviousFrameAverageLuminance;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform lowp sampler2D s_SceneColor;
uniform lowp sampler2D s_SceneDepth;
uniform lowp sampler2D s_SeasonsTexture;
uniform highp sampler2DArrayShadow s_ShadowCascades;
uniform lowp sampler2DArrayShadow s_WaterSurfaceDepthTextures;
layout(std430, binding = 0)buffer s_DirectionalLightSources { LightSourceWorldInfo DirectionalLightSources[]; };
layout(std430, binding = 1)buffer s_LightLookupArray { LightData LightLookupArray[]; };
layout(std430, binding = 3)buffer s_Lights { Light Lights[]; };
layout(std430, binding = 5)buffer s_PBRData { PBRTextureData PBRData[]; };
struct StandardSurfaceInput {
    vec2 UV;
    vec3 Color;
    float Alpha;
    vec2 lightmapUV;
    vec3 bitangent;
    vec3 normal;
    vec3 tangent;
    vec2 texcoord0;
    vec3 worldPos;
};

struct StandardVertexInput {
    VertexInput vertInput;
    vec3 worldPos;
};

StandardSurfaceInput StandardTemplate_DefaultInput(FragmentInput fragInput) {
    StandardSurfaceInput result;
    result.UV = vec2(0, 0);
    result.Color = vec3(1, 1, 1);
    result.Alpha = 1.0;
    result.lightmapUV = fragInput.lightmapUV;
    result.bitangent = fragInput.bitangent;
    result.normal = fragInput.normal;
    result.tangent = fragInput.tangent;
    result.texcoord0 = fragInput.texcoord0;
    result.worldPos = fragInput.worldPos;
    return result;
}
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

StandardSurfaceOutput StandardTemplate_DefaultOutput() {
    StandardSurfaceOutput result;
    result.Albedo = vec3(1, 1, 1);
    result.Alpha = 1.0;
    result.Metallic = 0.0;
    result.Roughness = 1.0;
    result.Occlusion = 0.0;
    result.Emissive = 0.0;
    result.Subsurface = 0.0;
    result.AmbientLight = vec3(0.0, 0.0, 0.0);
    result.ViewSpaceNormal = vec3(0, 1, 0);
    return result;
}
struct ColorTransform {
    float hue;
    float saturation;
    float luminance;
};

#ifdef DO_WATER_SHADING_PASS
mat3 getCIEXYZToRGBTransform() {
    return mat3(
        3.2404542, - 1.5371385, - 0.4985314,
        - 0.9692660, 1.8760108, 0.0415560,
        0.0556434, - 0.2040259, 1.0572252
    );
}
#endif
struct AtmosphereParams {
    vec3 sunDir;
    vec3 moonDir;
    vec4 sunColor;
    vec4 moonColor;
    vec3 skyZenithColor;
    vec3 skyHorizonColor;
    vec4 fogColor;
    float horizonBlendMin;
    float horizonBlendStart;
    float mieStart;
    float horizonBlendMax;
    float rayleighStrength;
    float sunMieStrength;
    float moonMieStrength;
    float sunGlareShape;
};

#ifdef DO_WATER_SHADING_PASS
vec3 worldSpaceViewDir(vec3 worldPosition) {
    vec3 cameraPosition = ((InvView) * (vec4(0.f, 0.f, 0.f, 1.f))).xyz;
    return normalize(worldPosition - cameraPosition);
}
float calculateCosRefractedAngle(float cosIncidentAngle, float index1, float index2) {
    float ratioSqr = (index1 / index2) * (index1 / index2);
    float cosRefractedAngleSqr = 1.0 - ratioSqr + ratioSqr * cosIncidentAngle * cosIncidentAngle;
    return sqrt(cosRefractedAngleSqr);
}
vec3 getRefractedDir(vec3 incidentDir, vec3 surfaceNormal, float index1, float index2) {
    float ratio = index2 / index1;
    float cosIncidentAngle = dot(-incidentDir, surfaceNormal);
    float cosRefractedAngle = calculateCosRefractedAngle(cosIncidentAngle, index1, index2);
    return incidentDir * ratio + surfaceNormal * (cosIncidentAngle * ratio - cosRefractedAngle);
}
float phaseWater(float cosIntersection) {
    return 3.0 / (16.0 * 3.1415926535897) * (1.0 + cosIntersection * cosIntersection);
}
float phaseParticles(float cosIntersection) {
    return (1.0f / (4.0f * 3.1415926535897)) * ((1.0 - (0.924 * 0.924))) / pow((1.0 + (0.924 * 0.924)) - 2.0f * 0.924 * cosIntersection, 1.5f);
}
float getPhaseFunctionResult(vec3 incidentDirection, vec3 scatteringDirection) {
    float cosIntersection = dot(normalize(-incidentDirection), normalize(scatteringDirection));
    return phaseWater(cosIntersection) + phaseParticles(cosIntersection);
}
float getScatteringContribution(vec3 viewUnderWaterDir, vec3 lightUnderWaterDir, vec3 surfaceNormal, float depth, float stepLengthDivisor, float scattering, float absorption) {
    float totalCoefficient = absorption + scattering;
    if (stepLengthDivisor < 1.0f) {
        stepLengthDivisor = 1.0f;
    }
    float stepDepth = depth;
    float stepDepthLength = depth / stepLengthDivisor;
    float cosIncidentAngle = dot(-lightUnderWaterDir, surfaceNormal);
    float cosScatteringAngle = dot(viewUnderWaterDir, surfaceNormal);
    float viewUnderWaterLength = depth / cosScatteringAngle;
    float totalIntensity = 0.0f;
    for(int i = 0; i < int(stepLengthDivisor); i ++ ) {
        float lightUnderWaterLength = stepDepth / cosIncidentAngle;
        float viewUnderWaterLength = stepDepth / cosScatteringAngle;
        totalIntensity += scattering * getPhaseFunctionResult(lightUnderWaterDir, viewUnderWaterDir) * exp((lightUnderWaterLength * totalCoefficient) * (viewUnderWaterLength * totalCoefficient));
        stepDepth -= stepDepthLength;
    }
    return totalIntensity;
}
#endif
struct CompositingOutput {
    vec3 mLitColor;
};

vec4 standardComposite(StandardSurfaceOutput stdOutput, CompositingOutput compositingOutput) {
    return vec4(compositingOutput.mLitColor, stdOutput.Alpha);
}
#ifdef DEPTH_ONLY_PASS
void StandardTemplate_FinalColorOverrideIdentity(FragmentInput fragInput, StandardSurfaceInput surfaceInput, StandardSurfaceOutput surfaceOutput, inout FragmentOutput fragOutput) {
}
#endif
void StandardTemplate_CustomSurfaceShaderEntryIdentity(vec2 uv, vec3 worldPosition, inout StandardSurfaceOutput surfaceOutput) {
}
struct DirectionalLight {
    vec3 ViewSpaceDirection;
    vec3 Intensity;
};

#ifdef DEPTH_ONLY_PASS
vec3 computeLighting_RenderChunk(FragmentInput fragInput, StandardSurfaceInput stdInput, StandardSurfaceOutput stdOutput, DirectionalLight primaryLight) {
    return textureSample(s_LightMapTexture, stdInput.lightmapUV).rgb * stdOutput.Albedo;
}
void WaterSurfDepthOnly(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
}
#endif
#ifdef DO_WATER_SHADING_PASS
vec3 computeLighting_Unlit(FragmentInput fragInput, StandardSurfaceInput stdInput, StandardSurfaceOutput stdOutput, DirectionalLight primaryLight) {
    return stdOutput.Albedo;
}
void WaterSurf(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
    vec3 viewDirWorld = normalize(-worldSpaceViewDir(surfaceInput.worldPos));
    float rIntensity = 0.0;
    float gIntensity = 0.0;
    float bIntensity = 0.0;
    vec3 waterSurfaceNormal = surfaceOutput.ViewSpaceNormal;
    vec3 viewUnderWaterDir = -getRefractedDir(-viewDirWorld, waterSurfaceNormal, 1.000, 1.333);
    int lightCount = int(DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.y);
    for(int i = 0; i < lightCount; i ++ ) {
        vec4 colorAndIlluminance = DirectionalLightSources[i].diffuseColorAndIlluminance;
        vec3 lightDirWorld = normalize(-DirectionalLightSources[i].worldSpaceDirection.xyz);
        vec3 lightUnderWaterDir = getRefractedDir(lightDirWorld, waterSurfaceNormal, 1.000, 1.333);
        rIntensity += colorAndIlluminance.r * colorAndIlluminance.a * getScatteringContribution(viewUnderWaterDir, lightUnderWaterDir, waterSurfaceNormal, 1.0f, 1.0f, RedCentralWaterCoefficient.x, RedCentralWaterCoefficient.y);
        gIntensity += colorAndIlluminance.g * colorAndIlluminance.a * getScatteringContribution(viewUnderWaterDir, lightUnderWaterDir, waterSurfaceNormal, 1.0f, 1.0f, GreenCentralWaterCoefficient.x, GreenCentralWaterCoefficient.y);
        bIntensity += colorAndIlluminance.b * colorAndIlluminance.a * getScatteringContribution(viewUnderWaterDir, lightUnderWaterDir, waterSurfaceNormal, 1.0f, 1.0f, BlueCentralWaterCoefficient.x, BlueCentralWaterCoefficient.y);
    }
    vec3 cieXYZ = vec3(
        rIntensity * vec3(0.286, 0.106, 0.0).x + gIntensity * vec3(0.048, 0.5, 0.066).x + bIntensity * vec3(0.112, 0.135, 1.0).x,
        rIntensity * vec3(0.286, 0.106, 0.0).y + gIntensity * vec3(0.048, 0.5, 0.066).y + bIntensity * vec3(0.112, 0.135, 1.0).y,
        rIntensity * vec3(0.286, 0.106, 0.0).z + gIntensity * vec3(0.048, 0.5, 0.066).z + bIntensity * vec3(0.112, 0.135, 1.0).z
    );
    surfaceOutput.Albedo.xyz = ((getCIEXYZToRGBTransform()) * (cieXYZ));
}
void WaterFinal(FragmentInput fragInput, StandardSurfaceInput surfaceInput, StandardSurfaceOutput surfaceOutput, inout FragmentOutput fragOutput) {
    fragOutput.Color0.rgb = surfaceOutput.Albedo;
}
#endif
void StandardTemplate_Opaque_Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    StandardSurfaceInput surfaceInput = StandardTemplate_DefaultInput(fragInput);
    StandardSurfaceOutput surfaceOutput = StandardTemplate_DefaultOutput();
    surfaceInput.UV = fragInput.texcoord0;
    surfaceInput.Color = fragInput.color0.xyz;
    surfaceInput.Alpha = fragInput.color0.a;
    #ifdef DEPTH_ONLY_PASS
    WaterSurfDepthOnly(surfaceInput, surfaceOutput);
    #endif
    #ifdef DO_WATER_SHADING_PASS
    WaterSurf(surfaceInput, surfaceOutput);
    #endif
    StandardTemplate_CustomSurfaceShaderEntryIdentity(surfaceInput.UV, fragInput.worldPos, surfaceOutput);
    DirectionalLight primaryLight;
    vec3 worldLightDirection = LightWorldSpaceDirection.xyz;
    primaryLight.ViewSpaceDirection = ((View) * (vec4(worldLightDirection, 0))).xyz;
    primaryLight.Intensity = LightDiffuseColorAndIlluminance.rgb * LightDiffuseColorAndIlluminance.w;
    CompositingOutput compositingOutput;
    #ifdef DEPTH_ONLY_PASS
    compositingOutput.mLitColor = computeLighting_RenderChunk(fragInput, surfaceInput, surfaceOutput, primaryLight);
    #endif
    #ifdef DO_WATER_SHADING_PASS
    compositingOutput.mLitColor = computeLighting_Unlit(fragInput, surfaceInput, surfaceOutput, primaryLight);
    #endif
    fragOutput.Color0 = standardComposite(surfaceOutput, compositingOutput);
    #ifdef DEPTH_ONLY_PASS
    StandardTemplate_FinalColorOverrideIdentity(fragInput, surfaceInput, surfaceOutput, fragOutput);
    #endif
    #ifdef DO_WATER_SHADING_PASS
    WaterFinal(fragInput, surfaceInput, surfaceOutput, fragOutput);
    #endif
}
void main() {
    FragmentInput fragmentInput;
    FragmentOutput fragmentOutput;
    fragmentInput.bitangent = v_bitangent;
    fragmentInput.color0 = v_color0;
    fragmentInput.lightmapUV = v_lightmapUV;
    fragmentInput.normal = v_normal;
    fragmentInput.tangent = v_tangent;
    fragmentInput.texcoord0 = v_texcoord0;
    fragmentInput.worldPos = v_worldPos;
    fragmentOutput.Color0 = vec4(0, 0, 0, 0);
    ViewRect = u_viewRect;
    Proj = u_proj;
    View = u_view;
    ViewTexel = u_viewTexel;
    InvView = u_invView;
    ViewProj = u_viewProj;
    InvProj = u_invProj;
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
    StandardTemplate_Opaque_Frag(fragmentInput, fragmentOutput);
    #ifdef DEPTH_ONLY_PASS
    bgfx_FragColor = fragmentOutput.Color0;
    #endif
    #ifdef DO_WATER_SHADING_PASS
    bgfx_FragData[0] = fragmentOutput.Color0; ;
    #endif
}

