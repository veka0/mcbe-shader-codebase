#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS
* - GEOMETRY_PREPASS_ALPHA_TEST_PASS
* - TRANSPARENT_PASS
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON
*/

#ifdef GEOMETRY_PREPASS_ALPHA_TEST_PASS
#extension GL_EXT_texture_cube_map_array : enable
#endif
#if GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif
#define attribute in
#define varying in
out vec4 bgfx_FragData[gl_MaxDrawBuffers];
varying vec2 v_ambientLight;
varying vec3 v_bitangent;
varying vec4 v_color0;
varying vec4 v_fog;
varying vec3 v_normal;
varying vec3 v_prevWorldPos;
varying vec3 v_tangent;
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
#ifdef GEOMETRY_PREPASS_ALPHA_TEST_PASS
vec4 textureSample(mediump samplerCubeArray _sampler, vec4 _coord, float _lod) {
    return textureLod(_sampler, _coord, _lod);
}
#endif
vec4 textureSample(NoopSampler noopsampler, vec2 _coord) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec3 _coord) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec4 _coord) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec2 _coord, float _lod) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec3 _coord, float _lod) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec4 _coord, float _lod) {
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
uniform vec4 u_viewTexel;
uniform vec4 PBRTextureFlags;
uniform mat4 u_invView;
uniform mat4 u_invProj;
uniform mat4 u_viewProj;
uniform mat4 u_invViewProj;
uniform mat4 u_prevViewProj;
uniform mat4 u_model[4];
uniform mat4 u_modelView;
uniform mat4 u_modelViewProj;
uniform vec4 u_prevWorldPosOffset;
uniform vec4 u_alphaRef4;
uniform vec4 FogAndDistanceControl;
uniform vec4 FogColor;
uniform vec4 LightDiffuseColorAndIlluminance;
uniform vec4 LightWorldSpaceDirection;
uniform vec4 MERSUniforms;
uniform vec4 MaterialID;
uniform vec4 SubPixelOffset;
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
    vec2 ambientLight;
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
    vec2 ambientLight;
    vec3 bitangent;
    vec4 color0;
    vec4 fog;
    vec3 normal;
    vec3 prevWorldPos;
    vec3 tangent;
    vec2 texcoord0;
    vec3 worldPos;
};

struct FragmentInput {
    vec2 ambientLight;
    vec3 bitangent;
    vec4 color0;
    vec4 fog;
    vec3 normal;
    vec3 prevWorldPos;
    vec3 tangent;
    vec2 texcoord0;
    vec3 worldPos;
};

struct FragmentOutput {
    vec4 Color0; vec4 Color1; vec4 Color2;
};

uniform lowp sampler2D s_MERTexture;
uniform lowp sampler2D s_NormalTexture;
uniform lowp sampler2D s_ParticleTexture;
struct StandardSurfaceInput {
    vec2 UV;
    vec3 Color;
    float Alpha;
    vec2 ambientLight;
    vec3 bitangent;
    vec4 fog;
    vec3 normal;
    vec3 prevWorldPos;
    vec3 tangent;
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
    result.ambientLight = fragInput.ambientLight;
    result.bitangent = fragInput.bitangent;
    result.fog = fragInput.fog;
    result.normal = fragInput.normal;
    result.prevWorldPos = fragInput.prevWorldPos;
    result.tangent = fragInput.tangent;
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
vec3 applyFogVanilla(vec3 diffuse, vec3 fogColor, float fogIntensity) {
    return mix(diffuse, fogColor, fogIntensity);
}
#ifndef GEOMETRY_PREPASS_ALPHA_TEST_PASS
void ParticleApplyFog(FragmentInput fragInput, StandardSurfaceInput surfaceInput, StandardSurfaceOutput surfaceOutput, inout FragmentOutput fragOutput) {
    vec3 diffuse = fragOutput.Color0.rgb;
    diffuse = applyFogVanilla(fragOutput.Color0.rgb, surfaceInput.fog.rgb, surfaceInput.fog.a);
    fragOutput.Color0.rgb = diffuse;
}
#endif
#ifdef GEOMETRY_PREPASS_ALPHA_TEST_PASS
vec2 calculateMotionVector(vec3 worldPosition, vec3 previousWorldPosition) {
    vec4 screenSpacePos = ((ViewProj) * (vec4(worldPosition, 1.0)));
    screenSpacePos /= screenSpacePos.w;
    screenSpacePos = screenSpacePos * 0.5 + 0.5;
    vec4 prevScreenSpacePos = ((PrevViewProj) * (vec4(previousWorldPosition, 1.0)));
    prevScreenSpacePos /= prevScreenSpacePos.w;
    prevScreenSpacePos = prevScreenSpacePos * 0.5 + 0.5;
    return screenSpacePos.xy - prevScreenSpacePos.xy;
}
#endif
struct ColorTransform {
    float hue;
    float saturation;
    float luminance;
};

#ifdef GEOMETRY_PREPASS_ALPHA_TEST_PASS
vec2 octWrap(vec2 v) {
    return (1.0 - abs(v.yx)) * ((2.0 * step(0.0, v)) - 1.0);
}
vec2 ndirToOctSnorm(vec3 n) {
    vec2 p = n.xy * (1.0 / (abs(n.x) + abs(n.y) + abs(n.z)));
    p = (n.z < 0.0) ? octWrap(p) : p;
    return p;
}
float packMetalnessSubsurface(float metalness, float subsurface) {
    if (metalness > subsurface) {
        return (128.0 / 255.0) + (127.0 / 255.0) * metalness;
    }
    else {
        return (127.0 / 255.0) - (127.0 / 255.0) * subsurface;
    }
}
void applyPrepassSurfaceToGBuffer(vec3 worldPosition, vec3 prevWorldPosition, float ambientBlockLight, float ambientSkyLight, StandardSurfaceOutput surfaceOutput, inout FragmentOutput fragOutput) {
    fragOutput.Color0.rgb = fragOutput.Color0.rgb;
    fragOutput.Color0.a = packMetalnessSubsurface(surfaceOutput.Metallic, surfaceOutput.Subsurface);
    vec3 viewNormal = normalize(surfaceOutput.ViewSpaceNormal).xyz;
    fragOutput.Color1.xy = ndirToOctSnorm(viewNormal);
    fragOutput.Color1.zw = calculateMotionVector(worldPosition, prevWorldPosition);
    fragOutput.Color2 = vec4(
        surfaceOutput.Emissive,
        ambientBlockLight,
        ambientSkyLight,
        surfaceOutput.Roughness
    );
}
vec4 getParticleAlbedo(in StandardSurfaceInput surfaceInput) {
    vec4 albedo = textureSample(s_ParticleTexture, surfaceInput.UV);
    return albedo;
}
vec4 applyParticleDiffuse(vec4 albedo, const vec3 color, float alpha) {
    vec4 diffuse = albedo;
    diffuse = diffuse * vec4(color, alpha);
    return diffuse;
}
bool shouldDiscard(float alpha) {
    const float ALPHA_THRESHOLD = 0.5;
    if (alpha < ALPHA_THRESHOLD) {
        return true;
    }
    return false;
}
void ParticleSurfGeometryPrepass(FragmentInput fragInput, StandardSurfaceInput surfaceInput, StandardSurfaceOutput surfaceOutput, inout FragmentOutput fragOutput) {
    applyPrepassSurfaceToGBuffer(
        fragInput.worldPos.xyz,
        fragInput.worldPos.xyz - PrevWorldPosOffset.xyz,
        fragInput.ambientLight.x,
        fragInput.ambientLight.y,
        surfaceOutput,
        fragOutput
    );
}
#endif
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
#ifdef ALPHA_TEST_PASS
void ParticleAlphaTest(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
    vec4 diffuse = textureSample(s_ParticleTexture, surfaceInput.UV);
    const float ALPHA_THRESHOLD = 0.5;
    if (diffuse.a < ALPHA_THRESHOLD) {
        discard;
    }
    diffuse = diffuse * vec4(surfaceInput.Color, surfaceInput.Alpha);
    diffuse.a = 1.0;
    surfaceOutput.Albedo = diffuse.rgb;
    surfaceOutput.Alpha = diffuse.a;
}
#endif
#ifdef GEOMETRY_PREPASS_ALPHA_TEST_PASS
void Particle_getPBRSurfaceOutputValues(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput, bool isAlphaTest) {
    vec4 albedo = getParticleAlbedo(surfaceInput);
    vec3 surfaceColor = surfaceInput.Color;
    vec4 diffuse = applyParticleDiffuse(albedo, surfaceColor, surfaceInput.Alpha);
    if (isAlphaTest && shouldDiscard(diffuse.a)) {
        discard;
    }
    diffuse.rgb = applyFogVanilla(diffuse.rgb, surfaceInput.fog.rgb, surfaceInput.fog.a);
    surfaceOutput.Albedo = diffuse.rgb;
    surfaceOutput.Alpha = diffuse.a;
    surfaceOutput.ViewSpaceNormal = surfaceInput.normal;
}

const int kInvalidPBRTextureHandle = 0xffff;
const int kPBRTextureDataFlagHasMaterialTexture = (1 << 0);
const int kPBRTextureDataFlagHasSubsurfaceChannel = (1 << 1);
const int kPBRTextureDataFlagHasNormalTexture = (1 << 2);
const int kPBRTextureDataFlagHasHeightMapTexture = (1 << 3);
void ParticleGeometryPrepass(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
    Particle_getPBRSurfaceOutputValues(surfaceInput, surfaceOutput, true);
    float metalness = MERSUniforms.r;
    float emissive = MERSUniforms.g;
    float roughness = MERSUniforms.b;
    float subsurface = MERSUniforms.a;
    int flags = int(PBRTextureFlags.x);
    if ((flags & kPBRTextureDataFlagHasMaterialTexture) == kPBRTextureDataFlagHasMaterialTexture) {
        vec3 merTexture = textureSample(s_MERTexture, surfaceInput.UV).rgb;
        metalness = merTexture.r;
        emissive = merTexture.g;
        roughness = merTexture.b;
    }
    surfaceOutput.Metallic = metalness;
    surfaceOutput.Emissive = emissive;
    surfaceOutput.Roughness = roughness;
    surfaceOutput.Subsurface = subsurface;
    if ((flags & kPBRTextureDataFlagHasNormalTexture) == kPBRTextureDataFlagHasNormalTexture)
    {
        vec3 normalTexture = textureSample(s_NormalTexture, surfaceInput.UV).xyz * 2.f - 1.f;
        surfaceOutput.ViewSpaceNormal = ((World) * (vec4(normalTexture, 0.0))).xyz;
    }
    else
    {
        surfaceOutput.ViewSpaceNormal = surfaceInput.normal;
    }
}
#endif
#ifdef TRANSPARENT_PASS
void ParticleTransparent(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
    vec4 diffuse = textureSample(s_ParticleTexture, surfaceInput.UV);
    diffuse = diffuse * vec4(surfaceInput.Color, surfaceInput.Alpha);
    diffuse.rgb = applyFogVanilla(diffuse.rgb, surfaceInput.fog.rgb, surfaceInput.fog.a);
    surfaceOutput.Albedo = diffuse.rgb;
    surfaceOutput.Alpha = diffuse.a;
}
#endif
void StandardTemplate_Opaque_Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    StandardSurfaceInput surfaceInput = StandardTemplate_DefaultInput(fragInput);
    StandardSurfaceOutput surfaceOutput = StandardTemplate_DefaultOutput();
    surfaceInput.UV = fragInput.texcoord0;
    surfaceInput.Color = fragInput.color0.xyz;
    surfaceInput.Alpha = fragInput.color0.a;
    #ifdef ALPHA_TEST_PASS
    ParticleAlphaTest(surfaceInput, surfaceOutput);
    #endif
    #ifdef GEOMETRY_PREPASS_ALPHA_TEST_PASS
    ParticleGeometryPrepass(surfaceInput, surfaceOutput);
    #endif
    #ifdef TRANSPARENT_PASS
    ParticleTransparent(surfaceInput, surfaceOutput);
    #endif
    StandardTemplate_CustomSurfaceShaderEntryIdentity(surfaceInput.UV, fragInput.worldPos, surfaceOutput);
    DirectionalLight primaryLight;
    vec3 worldLightDirection = LightWorldSpaceDirection.xyz;
    primaryLight.ViewSpaceDirection = ((View) * (vec4(worldLightDirection, 0))).xyz;
    primaryLight.Intensity = LightDiffuseColorAndIlluminance.rgb * LightDiffuseColorAndIlluminance.w;
    CompositingOutput compositingOutput;
    compositingOutput.mLitColor = computeLighting_Unlit(fragInput, surfaceInput, surfaceOutput, primaryLight);
    fragOutput.Color0 = standardComposite(surfaceOutput, compositingOutput);
    #ifndef GEOMETRY_PREPASS_ALPHA_TEST_PASS
    ParticleApplyFog(fragInput, surfaceInput, surfaceOutput, fragOutput);
    #endif
    #ifdef GEOMETRY_PREPASS_ALPHA_TEST_PASS
    ParticleSurfGeometryPrepass(fragInput, surfaceInput, surfaceOutput, fragOutput);
    #endif
}
void main() {
    FragmentInput fragmentInput;
    FragmentOutput fragmentOutput;
    fragmentInput.ambientLight = v_ambientLight;
    fragmentInput.bitangent = v_bitangent;
    fragmentInput.color0 = v_color0;
    fragmentInput.fog = v_fog;
    fragmentInput.normal = v_normal;
    fragmentInput.prevWorldPos = v_prevWorldPos;
    fragmentInput.tangent = v_tangent;
    fragmentInput.texcoord0 = v_texcoord0;
    fragmentInput.worldPos = v_worldPos;
    fragmentOutput.Color0 = vec4(0, 0, 0, 0); fragmentOutput.Color1 = vec4(0, 0, 0, 0); fragmentOutput.Color2 = vec4(0, 0, 0, 0);
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
    bgfx_FragData[0] = fragmentOutput.Color0; bgfx_FragData[1] = fragmentOutput.Color1; bgfx_FragData[2] = fragmentOutput.Color2; ;
}

