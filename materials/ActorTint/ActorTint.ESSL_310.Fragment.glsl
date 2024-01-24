#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS
* - DEPTH_ONLY_PASS
* - DEPTH_ONLY_OPAQUE_PASS
* - OPAQUE_PASS
* - TRANSPARENT_PASS
*
* Change_Color:
* - CHANGE_COLOR__MULTI
* - CHANGE_COLOR__OFF (not used)
* - CHANGE_COLOR__ON
*
* Emissive:
* - EMISSIVE__OFF (not used)
*
* Fancy:
* - FANCY__OFF (not used)
* - FANCY__ON (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON
*
* MaskedMultitexture:
* - MASKED_MULTITEXTURE__OFF (not used)
* - MASKED_MULTITEXTURE__ON
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
varying vec4 v_light;
centroid varying vec2 v_texcoord0;
varying vec3 v_worldPos;
struct NoopSampler {
    int noop;
};

#if ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(DEPTH_ONLY_PASS)
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
uniform vec4 FogColor;
uniform vec4 ActorFPEpsilon;
uniform mat4 Bones[8];
uniform vec4 ColorBased;
uniform vec4 HudOpacity;
uniform vec4 LightDiffuseColorAndIlluminance;
uniform vec4 LightWorldSpaceDirection;
uniform vec4 TileLightIntensity;
uniform vec4 MatColor;
uniform vec4 MultiplicativeTintColor;
uniform vec4 TintedAlphaTestEnabled;
uniform vec4 SubPixelOffset;
uniform vec4 TileLightColor;
uniform vec4 UVAnimation;
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
    int boneId;
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

uniform lowp sampler2D s_MatTexture;
uniform lowp sampler2D s_MatTexture1;
struct StandardSurfaceInput {
    vec2 UV;
    vec3 Color;
    float Alpha;
    vec4 fog;
    vec4 light;
    vec2 texcoord0;
};

struct StandardVertexInput {
    VertexInput vertInput;
    vec3 worldPos;
};

#ifndef DEPTH_ONLY_PASS
StandardSurfaceInput StandardTemplate_DefaultInput(FragmentInput fragInput) {
    StandardSurfaceInput result;
    result.UV = vec2(0, 0);
    result.Color = vec3(1, 1, 1);
    result.Alpha = 1.0;
    result.fog = fragInput.fog;
    result.light = fragInput.light;
    result.texcoord0 = fragInput.texcoord0;
    return result;
}
#endif
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

#ifndef DEPTH_ONLY_PASS
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
#endif
#if ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(DEPTH_ONLY_PASS)
vec4 applyOverlayColor(vec4 diffuse, const vec4 overlayColor) {
    diffuse.rgb = mix(diffuse.rgb, overlayColor.rgb, overlayColor.a);
    return diffuse;
}
#endif
#if defined(CHANGE_COLOR__MULTI)&& ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(DEPTH_ONLY_PASS)
vec4 applyMultiColorChange(vec4 diffuse, vec3 changeColor, vec3 multiplicativeTintColor) {
    vec2 colorMask = diffuse.rg;
    diffuse.rgb = colorMask.rrr * changeColor;
    diffuse.rgb = mix(diffuse.rgb, colorMask.ggg * multiplicativeTintColor.rgb, ceil(colorMask.g));
    return diffuse;
}
#endif
#if ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(DEPTH_ONLY_PASS)
vec4 applyLighting(vec4 diffuse, const vec4 light) {
    diffuse.rgb *= light.rgb;
    return diffuse;
}
vec4 applyChangeColor(vec4 diffuse, vec4 changeColor, vec3 multiplicativeTintColor, float shouldChangeAlpha) {
    #ifdef CHANGE_COLOR__MULTI
    diffuse = applyMultiColorChange(diffuse, changeColor.rgb, multiplicativeTintColor);
    #endif
    #ifdef CHANGE_COLOR__ON
    diffuse.rgb = mix(diffuse.rgb, diffuse.rgb * changeColor.rgb, diffuse.a);
    diffuse.a *= changeColor.a;
    #endif
    diffuse.a = max(shouldChangeAlpha, diffuse.a);
    return diffuse;
}
vec4 applyEmissiveLighting(vec4 diffuse, vec4 light) {
    diffuse = applyLighting(diffuse, light);
    return diffuse;
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
vec4 applyActorDiffuse(vec4 albedo, vec3 color, vec4 light) {
    albedo.rgb *= mix(vec3(1, 1, 1), color, ColorBased.x);
    albedo = applyOverlayColor(albedo, OverlayColor);
    albedo = applyEmissiveLighting(albedo, light);
    return albedo;
}
vec4 getActorAlbedo(vec2 uv) {
    vec4 albedo = getActorAlbedoNoColorChange(uv);
    albedo = applyChangeColor(albedo, ChangeColor, MultiplicativeTintColor.rgb, 0.0);
    return albedo;
}
vec3 applyFogVanilla(vec3 diffuse, vec3 fogColor, float fogIntensity) {
    return mix(diffuse, fogColor, fogIntensity);
}
void ActorApplyFog(FragmentInput fragInput, StandardSurfaceInput surfaceInput, StandardSurfaceOutput surfaceOutput, inout FragmentOutput fragOutput) {
    fragOutput.Color0.rgb = applyFogVanilla(fragOutput.Color0.rgb, surfaceInput.fog.rgb, surfaceInput.fog.a);
}
#endif
#ifdef ALPHA_TEST_PASS
bool shouldDiscardTinted(float albedoAlpha, float tintAlpha) {
    return albedoAlpha + tintAlpha < ActorFPEpsilon.x;
}
#endif
#if defined(ALPHA_TEST_PASS)|| defined(OPAQUE_PASS)
vec4 applySecondColorTint(vec4 albedo, vec2 uv, out float tintAlpha) {
    vec4 tintTex = textureSample(s_MatTexture1, uv);
    tintAlpha = tintTex.a;
    tintTex.rgb *= MultiplicativeTintColor.rgb;
    albedo.rgb = mix(albedo.rgb, tintTex.rgb, tintTex.a);
    return albedo;
}
#endif
#ifdef DEPTH_ONLY_OPAQUE_PASS
void SurfaceFinalColorOverrideBase(FragmentInput fragInput, StandardSurfaceInput surfaceInput, StandardSurfaceOutput surfaceOutput, inout FragmentOutput fragOutput) {
}
#endif
struct CompositingOutput {
    vec3 mLitColor;
};

#ifndef DEPTH_ONLY_PASS
vec4 standardComposite(StandardSurfaceOutput stdOutput, CompositingOutput compositingOutput) {
    return vec4(compositingOutput.mLitColor, stdOutput.Alpha);
}
void StandardTemplate_CustomSurfaceShaderEntryIdentity(vec2 uv, vec3 worldPosition, inout StandardSurfaceOutput surfaceOutput) {
}
#endif
struct DirectionalLight {
    vec3 ViewSpaceDirection;
    vec3 Intensity;
};

#ifndef DEPTH_ONLY_PASS
vec3 computeLighting_Unlit(FragmentInput fragInput, StandardSurfaceInput stdInput, StandardSurfaceOutput stdOutput, DirectionalLight primaryLight) {
    return stdOutput.Albedo;
}
#endif
#if defined(ALPHA_TEST_PASS)|| defined(OPAQUE_PASS)
void ActorSurfTint(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
    vec4 albedo = getActorAlbedo(surfaceInput.UV);
    float tintAlpha = 0.0;
    albedo = applySecondColorTint(albedo, surfaceInput.UV, tintAlpha);
    #ifdef ALPHA_TEST_PASS
    if (shouldDiscardTinted(albedo.a, tintAlpha)) {
        discard;
    }
    #endif
    vec4 diffuse = applyActorDiffuse(albedo, surfaceInput.Color, surfaceInput.light);
    surfaceOutput.Albedo = diffuse.rgb;
    surfaceOutput.Alpha = diffuse.a;
}
#endif
#ifdef DEPTH_ONLY_OPAQUE_PASS
void ActorSurfOpaque(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
}
#endif
#ifdef TRANSPARENT_PASS
void ActorSurfTransparent(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
    vec4 albedo = getActorAlbedo(surfaceInput.texcoord0);
    vec4 diffuse = applyActorDiffuse(albedo, surfaceInput.Color, surfaceInput.light);
    surfaceOutput.Albedo = diffuse.rgb;
    surfaceOutput.Alpha = diffuse.a * HudOpacity.x;
}
#endif
#ifndef DEPTH_ONLY_PASS
void StandardTemplate_Opaque_Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    StandardSurfaceInput surfaceInput = StandardTemplate_DefaultInput(fragInput);
    StandardSurfaceOutput surfaceOutput = StandardTemplate_DefaultOutput();
    surfaceInput.UV = fragInput.texcoord0;
    surfaceInput.Color = fragInput.color0.xyz;
    surfaceInput.Alpha = fragInput.color0.a;
    #if defined(ALPHA_TEST_PASS)|| defined(OPAQUE_PASS)
    ActorSurfTint(surfaceInput, surfaceOutput);
    #endif
    #ifdef DEPTH_ONLY_OPAQUE_PASS
    ActorSurfOpaque(surfaceInput, surfaceOutput);
    #endif
    #ifdef TRANSPARENT_PASS
    ActorSurfTransparent(surfaceInput, surfaceOutput);
    #endif
    StandardTemplate_CustomSurfaceShaderEntryIdentity(surfaceInput.UV, fragInput.worldPos, surfaceOutput);
    DirectionalLight primaryLight;
    vec3 worldLightDirection = LightWorldSpaceDirection.xyz;
    primaryLight.ViewSpaceDirection = ((View) * (vec4(worldLightDirection, 0))).xyz;
    primaryLight.Intensity = LightDiffuseColorAndIlluminance.rgb * LightDiffuseColorAndIlluminance.w;
    CompositingOutput compositingOutput;
    compositingOutput.mLitColor = computeLighting_Unlit(fragInput, surfaceInput, surfaceOutput, primaryLight);
    fragOutput.Color0 = standardComposite(surfaceOutput, compositingOutput);
    #ifndef DEPTH_ONLY_OPAQUE_PASS
    ActorApplyFog(fragInput, surfaceInput, surfaceOutput, fragOutput);
    #endif
    #ifdef DEPTH_ONLY_OPAQUE_PASS
    SurfaceFinalColorOverrideBase(fragInput, surfaceInput, surfaceOutput, fragOutput);
    #endif
}
#endif
#ifdef DEPTH_ONLY_PASS
void StandardTemplate_DepthOnly_Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
}
#endif
void main() {
    FragmentInput fragmentInput;
    FragmentOutput fragmentOutput;
    fragmentInput.color0 = v_color0;
    fragmentInput.fog = v_fog;
    fragmentInput.light = v_light;
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
    #ifndef DEPTH_ONLY_PASS
    StandardTemplate_Opaque_Frag(fragmentInput, fragmentOutput);
    #endif
    #ifdef DEPTH_ONLY_PASS
    StandardTemplate_DepthOnly_Frag(fragmentInput, fragmentOutput);
    #endif
    bgfx_FragColor = fragmentOutput.Color0;
}

