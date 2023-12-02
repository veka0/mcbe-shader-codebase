#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_PASS
* - DEPTH_ONLY_OPAQUE_PASS
* - GEOMETRY_PREPASS_PASS
* - GEOMETRY_PREPASS_ALPHA_TEST_PASS
* - TRANSPARENT_PASS
*
* Change_Color:
* - CHANGE_COLOR__MULTI
* - CHANGE_COLOR__OFF
*
* Emissive:
* - EMISSIVE__OFF (not used)
*
* Fancy:
* - FANCY__ON (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON
*
* MaskedMultitexture:
* - MASKED_MULTITEXTURE__OFF (not used)
* - MASKED_MULTITEXTURE__ON
*
* Tinting:
* - TINTING__DISABLED (not used)
* - TINTING__ENABLED
*/

#if GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif
#define attribute in
#define varying in
out vec4 bgfx_FragData[gl_MaxDrawBuffers];
varying vec3 v_bitangent;
varying vec4 v_color0;
varying vec4 v_fog;
varying vec4 v_light;
varying vec3 v_normal;
varying vec3 v_prevWorldPos;
varying vec3 v_tangent;
centroid varying vec2 v_texcoord0;
centroid varying vec4 v_texcoords;
varying vec3 v_worldPos;
struct NoopSampler {
    int noop;
};

#ifndef DEPTH_ONLY_OPAQUE_PASS
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
uniform vec4 UseAlphaRewrite;
uniform mat4 u_view;
uniform vec4 FogControl;
uniform vec4 ChangeColor;
uniform vec4 u_viewTexel;
uniform vec4 PBRTextureFlags;
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
uniform mat4 PrevWorld;
uniform vec4 LightWorldSpaceDirection;
uniform vec4 TileLightIntensity;
uniform vec4 MatColor;
uniform vec4 UVAnimation;
uniform vec4 LightDiffuseColorAndIlluminance;
uniform vec4 ColorBased;
uniform vec4 SubPixelOffset;
uniform vec4 TintedAlphaTestEnabled;
uniform vec4 HudOpacity;
uniform vec4 ActorFPEpsilon;
uniform vec4 FogColor;
uniform vec4 MetalnessUniform;
uniform vec4 MultiplicativeTintColor;
uniform vec4 TileLightColor;
uniform mat4 Bones[8];
uniform vec4 EmissiveUniform;
uniform vec4 RoughnessUniform;
uniform vec4 ViewPositionAndTime;
uniform mat4 PrevBones[8];
uniform vec4 BannerColors[7];
uniform vec4 BannerUVOffsetsAndScales[7];
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
    #if defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(DEPTH_ONLY_PASS)
    vec4 normal;
    #endif
    int boneId;
    #if ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(DEPTH_ONLY_PASS)
    vec4 normal;
    #endif
    vec3 position;
    vec2 texcoord0;
    vec4 color0;
    vec4 tangent;
    #ifdef INSTANCING__ON
    vec4 instanceData0;
    vec4 instanceData1;
    vec4 instanceData2;
    #endif
};

struct VertexOutput {
    vec4 position;
    vec2 texcoord0;
    vec4 color0;
    #if defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(DEPTH_ONLY_PASS)
    vec4 light;
    vec4 fog;
    #endif
    #if ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(DEPTH_ONLY_PASS)
    vec4 texcoords;
    #endif
    vec3 worldPos;
    vec3 prevWorldPos;
    vec3 normal;
    vec3 tangent;
    vec3 bitangent;
    #if defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(DEPTH_ONLY_PASS)
    vec4 texcoords;
    #endif
    #if ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(DEPTH_ONLY_PASS)
    vec4 fog;
    vec4 light;
    #endif
};

struct FragmentInput {
    vec2 texcoord0;
    vec4 color0;
    #if defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(DEPTH_ONLY_PASS)
    vec4 light;
    vec4 fog;
    #endif
    #if ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(DEPTH_ONLY_PASS)
    vec4 texcoords;
    #endif
    vec3 worldPos;
    vec3 prevWorldPos;
    vec3 normal;
    vec3 tangent;
    vec3 bitangent;
    #if defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(DEPTH_ONLY_PASS)
    vec4 texcoords;
    #endif
    #if ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(DEPTH_ONLY_PASS)
    vec4 fog;
    vec4 light;
    #endif
};

struct FragmentOutput {
    vec4 Color0; vec4 Color1; vec4 Color2;
};

uniform lowp sampler2D s_MatTexture;
uniform lowp sampler2D s_MatTexture1;
uniform lowp sampler2D s_NormalTexture;
uniform lowp sampler2D s_MERTexture;
struct StandardSurfaceInput {
    vec2 UV;
    vec3 Color;
    float Alpha;
    #if defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(DEPTH_ONLY_PASS)
    vec2 texcoord0;
    vec4 light;
    vec4 fog;
    #endif
    #if ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(DEPTH_ONLY_PASS)
    vec4 texcoords;
    #endif
    vec3 worldPos;
    vec3 prevWorldPos;
    vec3 normal;
    vec3 tangent;
    vec3 bitangent;
    #if defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(DEPTH_ONLY_PASS)
    vec4 texcoords;
    #endif
    #if ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(DEPTH_ONLY_PASS)
    vec2 texcoord0;
    vec4 fog;
    vec4 light;
    #endif
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
    #if defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(DEPTH_ONLY_PASS)
    result.texcoord0 = fragInput.texcoord0;
    result.light = fragInput.light;
    result.fog = fragInput.fog;
    #endif
    #if ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(DEPTH_ONLY_PASS)
    result.texcoords = fragInput.texcoords;
    #endif
    result.worldPos = fragInput.worldPos;
    result.prevWorldPos = fragInput.prevWorldPos;
    result.normal = fragInput.normal;
    result.tangent = fragInput.tangent;
    result.bitangent = fragInput.bitangent;
    #if defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(DEPTH_ONLY_PASS)
    result.texcoords = fragInput.texcoords;
    #endif
    #if ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(DEPTH_ONLY_PASS)
    result.texcoord0 = fragInput.texcoord0;
    result.fog = fragInput.fog;
    result.light = fragInput.light;
    #endif
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
#ifdef DEPTH_ONLY_PASS
bool shouldDiscard(vec3 diffuse, float alpha, float epsilon) {
    bool result = false;
    #ifdef CHANGE_COLOR__MULTI
    result = alpha < epsilon;
    #endif
    #ifdef CHANGE_COLOR__OFF
    result = alpha < 0.5;
    #endif
    return result;
}
vec4 getActorAlbedoNoColorChange(vec2 uv) {
    vec4 albedo = MatColor;
    albedo *= textureSample(s_MatTexture, uv);
    #ifdef MASKED_MULTITEXTURE__ON
    vec4 tex1 = textureSample(s_MatTexture1, uv);
    float maskedTexture = float((tex1.r + tex1.g + tex1.b) * (1.0f - tex1.a) > 0.0);
    albedo = mix(tex1, albedo, maskedTexture);
    #endif
    return albedo;
}
#endif
#if defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(DEPTH_ONLY_PASS)
vec3 applyFogVanilla(vec3 diffuse, vec3 fogColor, float fogIntensity) {
    return mix(diffuse, fogColor, fogIntensity);
}
void ActorApplyFog(FragmentInput fragInput, StandardSurfaceInput surfaceInput, StandardSurfaceOutput surfaceOutput, inout FragmentOutput fragOutput) {
    fragOutput.Color0.rgb = applyFogVanilla(fragOutput.Color0.rgb, surfaceInput.fog.rgb, surfaceInput.fog.a);
}
#endif
#if ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(DEPTH_ONLY_PASS)
vec4 applyLighting(vec4 diffuse, const vec4 light) {
    diffuse.rgb *= light.rgb;
    return diffuse;
}
vec4 applyEmissiveLighting(vec4 diffuse, vec4 light) {
    diffuse = applyLighting(diffuse, light);
    return diffuse;
}
#endif
#if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(TRANSPARENT_PASS)
vec3 applyFogVanilla(vec3 diffuse, vec3 fogColor, float fogIntensity) {
    return mix(diffuse, fogColor, fogIntensity);
}
void ActorApplyFog(FragmentInput fragInput, StandardSurfaceInput surfaceInput, StandardSurfaceOutput surfaceOutput, inout FragmentOutput fragOutput) {
    fragOutput.Color0.rgb = applyFogVanilla(fragOutput.Color0.rgb, surfaceInput.fog.rgb, surfaceInput.fog.a);
}
#endif
struct ColorTransform {
    float hue;
    float saturation;
    float luminance;
};

#ifdef GEOMETRY_PREPASS_PASS
vec2 octWrap(vec2 v) {
    return (1.0 - abs(v.yx)) * ((2.0 * step(0.0, v)) - 1.0);
}
vec2 ndirToOctSnorm(vec3 n) {
    vec2 p = n.xy * (1.0 / (abs(n.x) + abs(n.y) + abs(n.z)));
    p = (n.z < 0.0) ? octWrap(p) : p;
    return p;
}
void applyPrepassSurfaceToGBuffer(vec3 worldPosition, vec3 prevWorldPosition, float ambientBlockLight, float ambientSkyLight, StandardSurfaceOutput surfaceOutput, inout FragmentOutput fragOutput) {
    fragOutput.Color0.rgb = fragOutput.Color0.rgb;
    fragOutput.Color0.a = surfaceOutput.Metallic;
    vec3 viewNormal = normalize(surfaceOutput.ViewSpaceNormal).xyz;
    fragOutput.Color1.xy = ndirToOctSnorm(viewNormal);
    vec4 screenSpacePos = ((ViewProj) * (vec4(worldPosition, 1.0)));
    screenSpacePos /= screenSpacePos.w;
    screenSpacePos = screenSpacePos * 0.5 + 0.5;
    vec4 prevScreenSpacePos = ((PrevViewProj) * (vec4(prevWorldPosition, 1.0)));
    prevScreenSpacePos /= prevScreenSpacePos.w;
    prevScreenSpacePos = prevScreenSpacePos * 0.5 + 0.5;
    fragOutput.Color1.zw = screenSpacePos.xy - prevScreenSpacePos.xy;
    fragOutput.Color2 = vec4(
        surfaceOutput.Emissive,
        ambientBlockLight,
        ambientSkyLight,
        surfaceOutput.Roughness
    );
}
void ActorSurfGeometryPrepass(FragmentInput fragInput, StandardSurfaceInput surfaceInput, StandardSurfaceOutput surfaceOutput, inout FragmentOutput fragOutput) {
    applyPrepassSurfaceToGBuffer(
        fragInput.worldPos.xyz,
        fragInput.prevWorldPos.xyz - PrevWorldPosOffset.xyz,
        TileLightIntensity.x,
        TileLightIntensity.y,
        surfaceOutput,
        fragOutput
    );
}
#endif
#if ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(DEPTH_ONLY_PASS)
vec4 getBannerAlbedo(vec4 color, vec2 texcoord0, vec2 texcoord1) {
    vec4 base = textureSample(s_MatTexture, texcoord0);
    #ifdef TINTING__ENABLED
    vec4 albedo = textureSample(s_MatTexture, texcoord1);
    base.a = mix(albedo.r * albedo.a, albedo.a, color.a);
    base.rgb *= color.rgb;
    #endif
    return base;
}
vec4 applyHudOpacity(vec4 diffuse, float hudOpacity) {
    diffuse.a *= hudOpacity;
    return diffuse;
}
void ActorSurfBanner(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
    vec4 color = vec4(surfaceInput.Color, surfaceInput.Alpha);
    vec4 albedo = getBannerAlbedo(color, surfaceInput.texcoords.zw, surfaceInput.texcoords.xy);
    vec4 diffuse = applyEmissiveLighting(albedo, surfaceInput.light);
    diffuse = applyHudOpacity(diffuse, HudOpacity.x);
    surfaceOutput.Albedo = diffuse.rgb;
    surfaceOutput.Alpha = diffuse.a;
}
#endif
struct CompositingOutput {
    vec3 mLitColor;
};

vec4 standardComposite(StandardSurfaceOutput stdOutput, CompositingOutput compositingOutput) {
    return vec4(compositingOutput.mLitColor, stdOutput.Alpha);
}
struct DirectionalLight {
    vec3 ViewSpaceDirection;
    vec3 Intensity;
};

vec3 computeLighting_Unlit(FragmentInput fragInput, StandardSurfaceInput stdInput, StandardSurfaceOutput stdOutput, DirectionalLight primaryLight) {
    return stdOutput.Albedo;
}
#ifdef DEPTH_ONLY_PASS
void ActorSurfAlpha(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
    vec4 albedo = getActorAlbedoNoColorChange(surfaceInput.texcoord0);
    float alpha = albedo.a;
    alpha = mix(alpha, alpha * OverlayColor.a, TintedAlphaTestEnabled.x);
    if (shouldDiscard(albedo.rgb, alpha, ActorFPEpsilon.x)) {
        discard;
    }
}
#endif
#ifdef DEPTH_ONLY_OPAQUE_PASS
void ActorSurfOpaque(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
}
#endif
#ifdef GEOMETRY_PREPASS_PASS
void ActorSurfBannerGeometryPrepass(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
    ActorSurfBanner(surfaceInput, surfaceOutput);
    surfaceOutput.Roughness = 0.5;
    surfaceOutput.Metallic = 0.0;
    surfaceOutput.Emissive = 0.0;
    surfaceOutput.ViewSpaceNormal = surfaceInput.normal;
}
#endif
void StandardTemplate_Opaque_Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    StandardSurfaceInput surfaceInput = StandardTemplate_DefaultInput(fragInput);
    StandardSurfaceOutput surfaceOutput = StandardTemplate_DefaultOutput();
    surfaceInput.UV = fragInput.texcoord0;
    surfaceInput.Color = fragInput.color0.xyz;
    surfaceInput.Alpha = fragInput.color0.a;
    #ifdef DEPTH_ONLY_PASS
    ActorSurfAlpha(surfaceInput, surfaceOutput);
    #endif
    #ifdef DEPTH_ONLY_OPAQUE_PASS
    ActorSurfOpaque(surfaceInput, surfaceOutput);
    #endif
    #ifdef GEOMETRY_PREPASS_PASS
    ActorSurfBannerGeometryPrepass(surfaceInput, surfaceOutput);
    #endif
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(TRANSPARENT_PASS)
    ActorSurfBanner(surfaceInput, surfaceOutput);
    #endif
    DirectionalLight primaryLight;
    vec3 worldLightDirection = LightWorldSpaceDirection.xyz;
    primaryLight.ViewSpaceDirection = ((View) * (vec4(worldLightDirection, 0))).xyz;
    primaryLight.Intensity = LightDiffuseColorAndIlluminance.rgb * LightDiffuseColorAndIlluminance.w;
    CompositingOutput compositingOutput;
    compositingOutput.mLitColor = computeLighting_Unlit(fragInput, surfaceInput, surfaceOutput, primaryLight);
    fragOutput.Color0 = standardComposite(surfaceOutput, compositingOutput);
    #ifndef GEOMETRY_PREPASS_PASS
    ActorApplyFog(fragInput, surfaceInput, surfaceOutput, fragOutput);
    #endif
    #ifdef GEOMETRY_PREPASS_PASS
    ActorSurfGeometryPrepass(fragInput, surfaceInput, surfaceOutput, fragOutput);
    #endif
}
void main() {
    FragmentInput fragmentInput;
    FragmentOutput fragmentOutput;
    fragmentInput.texcoord0 = v_texcoord0;
    fragmentInput.color0 = v_color0;
    #if defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(DEPTH_ONLY_PASS)
    fragmentInput.light = v_light;
    fragmentInput.fog = v_fog;
    #endif
    #if ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(DEPTH_ONLY_PASS)
    fragmentInput.texcoords = v_texcoords;
    #endif
    fragmentInput.worldPos = v_worldPos;
    fragmentInput.prevWorldPos = v_prevWorldPos;
    fragmentInput.normal = v_normal;
    fragmentInput.tangent = v_tangent;
    fragmentInput.bitangent = v_bitangent;
    #if defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(DEPTH_ONLY_PASS)
    fragmentInput.texcoords = v_texcoords;
    #endif
    #if ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(DEPTH_ONLY_PASS)
    fragmentInput.fog = v_fog;
    fragmentInput.light = v_light;
    #endif
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

