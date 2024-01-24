#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* FlipOcclusion:
* - FLIP_OCCLUSION__OFF
* - FLIP_OCCLUSION__ON
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON
*
* NoOcclusion:
* - NO_OCCLUSION__OFF
* - NO_OCCLUSION__ON
*
* NoVariety:
* - NO_VARIETY__OFF (not used)
* - NO_VARIETY__ON (not used)
*/

#if GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif
#define attribute in
#define varying in
out vec4 bgfx_FragColor;
varying vec4 v_color0;
varying vec4 v_fog;
varying float v_occlusionHeight;
varying vec2 v_occlusionUV;
varying vec2 v_texcoord0;
varying vec3 v_worldPos;
struct NoopSampler {
    int noop;
};

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
uniform vec4 Dimensions;
uniform vec4 u_viewTexel;
uniform mat4 u_invView;
uniform vec4 ViewPosition;
uniform mat4 u_invProj;
uniform mat4 u_viewProj;
uniform mat4 u_invViewProj;
uniform mat4 u_prevViewProj;
uniform mat4 u_model[4];
uniform mat4 u_modelView;
uniform mat4 u_modelViewProj;
uniform vec4 u_prevWorldPosOffset;
uniform vec4 u_alphaRef4;
uniform vec4 UVOffsetAndScale;
uniform vec4 FogAndDistanceControl;
uniform vec4 OcclusionHeightOffset;
uniform vec4 FogColor;
uniform vec4 LightDiffuseColorAndIlluminance;
uniform vec4 Velocity;
uniform vec4 LightWorldSpaceDirection;
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

uniform lowp sampler2D s_LightingTexture;
uniform lowp sampler2D s_OcclusionTexture;
uniform lowp sampler2D s_WeatherTexture;
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

StandardSurfaceInput StandardTemplate_DefaultInput(FragmentInput fragInput) {
    StandardSurfaceInput result;
    result.UV = vec2(0, 0);
    result.Color = vec3(1, 1, 1);
    result.Alpha = 1.0;
    result.fog = fragInput.fog;
    result.occlusionHeight = fragInput.occlusionHeight;
    result.occlusionUV = fragInput.occlusionUV;
    return result;
}
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

StandardSurfaceOutput StandardTemplate_DefaultOutput() {
    StandardSurfaceOutput result;
    result.Albedo = vec3(1, 1, 1);
    result.Alpha = 1.0;
    result.Metallic = 0.0;
    result.Roughness = 1.0;
    result.Occlusion = 0.0;
    result.Emissive = 0.0;
    result.AmbientLight = vec3(0.0, 0.0, 0.0);
    result.ViewSpaceNormal = vec3(0, 1, 0);
    return result;
}
vec3 applyFogVanilla(vec3 diffuse, vec3 fogColor, float fogIntensity) {
    return mix(diffuse, fogColor, fogIntensity);
}
float getOcclusionHeight(const vec4 occlusionTextureSample) {
    float height = occlusionTextureSample.g + (occlusionTextureSample.b * 255.0f) - (OcclusionHeightOffset.x / 255.0f);
    return height;
}
float getOcclusionLuminance(const vec4 occlusionTextureSample) {
    return occlusionTextureSample.r;
}
bool isOccluded(const vec2 occlusionUV, const float occlusionHeight, const float occlusionHeightThreshold) {
    #if defined(FLIP_OCCLUSION__OFF)&& defined(NO_OCCLUSION__OFF)
    return (occlusionUV.x >= 0.0 && occlusionUV.x <= 1.0 && occlusionUV.y >= 0.0 && occlusionUV.y <= 1.0 && occlusionHeight < occlusionHeightThreshold);
    #endif
    #ifdef NO_OCCLUSION__ON
    return false;
    #endif
    #if defined(FLIP_OCCLUSION__ON)&& defined(NO_OCCLUSION__OFF)
    return (occlusionUV.x >= 0.0 && occlusionUV.x <= 1.0 && occlusionUV.y >= 0.0 && occlusionUV.y <= 1.0 && occlusionHeight > occlusionHeightThreshold);
    #endif
}
vec2 calculateOcclusionAndLightingUV(StandardSurfaceInput surfaceInput) {
    vec4 occlusionLuminanceAndHeightThreshold = textureSample(s_OcclusionTexture, surfaceInput.occlusionUV);
    float occlusionLuminance = getOcclusionLuminance(occlusionLuminanceAndHeightThreshold);
    float occlusionHeightThreshold = getOcclusionHeight(occlusionLuminanceAndHeightThreshold);
    if (isOccluded(surfaceInput.occlusionUV, surfaceInput.occlusionHeight, occlusionHeightThreshold)) {
        return vec2(0.0, 0.0);
    }
    else {
        float mixAmount = (surfaceInput.occlusionHeight - occlusionHeightThreshold) * 25.0;
        float uvX = occlusionLuminance - (mixAmount * occlusionLuminance);
        return vec2(uvX, 1.0);
    }
}
void WeatherApplyFog(FragmentInput fragInput, StandardSurfaceInput surfaceInput, StandardSurfaceOutput surfaceOutput, inout FragmentOutput fragOutput) {
    vec3 diffuse = fragOutput.Color0.rgb;
    diffuse = applyFogVanilla(fragOutput.Color0.rgb, surfaceInput.fog.rgb, surfaceInput.fog.a);
    fragOutput.Color0.rgb = diffuse;
}
struct CompositingOutput {
    vec3 mLitColor;
};

vec4 standardComposite(StandardSurfaceOutput stdOutput, CompositingOutput compositingOutput) {
    return vec4(compositingOutput.mLitColor, stdOutput.Alpha);
}
void StandardTemplate_CustomSurfaceShaderEntryIdentity(vec2 uv, vec3 worldPosition, inout StandardSurfaceOutput surfaceOutput) {
}
struct DirectionalLight {
    vec3 ViewSpaceDirection;
    vec3 Intensity;
};

vec3 computeLighting_Unlit(FragmentInput fragInput, StandardSurfaceInput stdInput, StandardSurfaceOutput stdOutput, DirectionalLight primaryLight) {
    return stdOutput.Albedo;
}
void WeatherSurface(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
    vec4 diffuse = textureSample(s_WeatherTexture, surfaceInput.UV);
    vec2 lightingUV = calculateOcclusionAndLightingUV(surfaceInput);
    vec3 light = textureSample(s_LightingTexture, lightingUV).rgb;
    diffuse.rgb *= light;
    surfaceOutput.Albedo = diffuse.rgb;
    surfaceOutput.Alpha = diffuse.a * lightingUV.y;
}
void StandardTemplate_Opaque_Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    StandardSurfaceInput surfaceInput = StandardTemplate_DefaultInput(fragInput);
    StandardSurfaceOutput surfaceOutput = StandardTemplate_DefaultOutput();
    surfaceInput.UV = fragInput.texcoord0;
    surfaceInput.Color = fragInput.color0.xyz;
    surfaceInput.Alpha = fragInput.color0.a;
    WeatherSurface(surfaceInput, surfaceOutput);
    StandardTemplate_CustomSurfaceShaderEntryIdentity(surfaceInput.UV, fragInput.worldPos, surfaceOutput);
    DirectionalLight primaryLight;
    vec3 worldLightDirection = LightWorldSpaceDirection.xyz;
    primaryLight.ViewSpaceDirection = ((View) * (vec4(worldLightDirection, 0))).xyz;
    primaryLight.Intensity = LightDiffuseColorAndIlluminance.rgb * LightDiffuseColorAndIlluminance.w;
    CompositingOutput compositingOutput;
    compositingOutput.mLitColor = computeLighting_Unlit(fragInput, surfaceInput, surfaceOutput, primaryLight);
    fragOutput.Color0 = standardComposite(surfaceOutput, compositingOutput);
    WeatherApplyFog(fragInput, surfaceInput, surfaceOutput, fragOutput);
}
void main() {
    FragmentInput fragmentInput;
    FragmentOutput fragmentOutput;
    fragmentInput.color0 = v_color0;
    fragmentInput.fog = v_fog;
    fragmentInput.occlusionHeight = v_occlusionHeight;
    fragmentInput.occlusionUV = v_occlusionUV;
    fragmentInput.texcoord0 = v_texcoord0;
    fragmentInput.worldPos = v_worldPos;
    fragmentOutput.Color0 = vec4(0, 0, 0, 0);
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
    StandardTemplate_Opaque_Frag(fragmentInput, fragmentOutput);
    bgfx_FragColor = fragmentOutput.Color0;
}

