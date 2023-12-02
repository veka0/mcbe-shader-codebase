#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS
* - DEPTH_ONLY_PASS
* - DEPTH_ONLY_OPAQUE_PASS
* - GEOMETRY_PREPASS_PASS
* - GEOMETRY_PREPASS_ALPHA_TEST_PASS
* - OPAQUE_PASS
* - TRANSPARENT_PASS
*
* Fancy:
* - FANCY__OFF (not used)
* - FANCY__ON (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON
*
* MultiColorTint:
* - MULTI_COLOR_TINT__OFF
* - MULTI_COLOR_TINT__ON
*/

#if GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif
#define attribute in
#define varying in
out vec4 bgfx_FragData[gl_MaxDrawBuffers];
varying vec4 v_color0;
varying vec4 v_fog;
varying vec4 v_light;
varying vec3 v_normal;
varying vec3 v_prevWorldPos;
varying vec2 v_texcoord0;
varying vec3 v_worldPos;
struct NoopSampler {
    int noop;
};

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
uniform vec4 LightDiffuseColorAndIlluminance;
uniform vec4 ColorBased;
uniform vec4 SubPixelOffset;
uniform vec4 FogColor;
uniform vec4 MultiplicativeTintColor;
uniform vec4 TileLightColor;
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
struct VertexInput {
    #if ! defined(DEPTH_ONLY_PASS)&& ! defined(OPAQUE_PASS)
    vec4 normal;
    #endif
    vec3 position;
    #if defined(DEPTH_ONLY_PASS)|| defined(OPAQUE_PASS)
    vec4 normal;
    #endif
    vec2 texcoord0;
    vec4 color0;
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
    #if ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)&& ! defined(GEOMETRY_PREPASS_PASS)
    vec4 fog;
    vec4 light;
    #endif
    vec3 worldPos;
    vec3 prevWorldPos;
    vec3 normal;
    #if defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    vec4 light;
    vec4 fog;
    #endif
};

struct FragmentInput {
    vec2 texcoord0;
    vec4 color0;
    #if ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)&& ! defined(GEOMETRY_PREPASS_PASS)
    vec4 fog;
    vec4 light;
    #endif
    vec3 worldPos;
    vec3 prevWorldPos;
    vec3 normal;
    #if defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    vec4 light;
    vec4 fog;
    #endif
};

struct FragmentOutput {
    vec4 Color0; vec4 Color1; vec4 Color2;
};

struct StandardSurfaceInput {
    vec2 UV;
    vec3 Color;
    float Alpha;
    #if defined(ALPHA_TEST_PASS)|| defined(TRANSPARENT_PASS)
    vec4 light;
    #endif
    #if ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)&& ! defined(GEOMETRY_PREPASS_PASS)
    vec4 fog;
    #endif
    #if defined(DEPTH_ONLY_PASS)|| defined(OPAQUE_PASS)
    vec4 light;
    #endif
    vec3 worldPos;
    vec3 prevWorldPos;
    vec3 normal;
    #if defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    vec4 fog;
    vec4 light;
    #endif
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
    #if defined(ALPHA_TEST_PASS)|| defined(TRANSPARENT_PASS)
    result.light = fragInput.light;
    #endif
    #if defined(ALPHA_TEST_PASS)|| defined(OPAQUE_PASS)|| defined(TRANSPARENT_PASS)
    result.fog = fragInput.fog;
    #endif
    #ifdef OPAQUE_PASS
    result.light = fragInput.light;
    #endif
    result.worldPos = fragInput.worldPos;
    result.prevWorldPos = fragInput.prevWorldPos;
    result.normal = fragInput.normal;
    #if defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    result.fog = fragInput.fog;
    result.light = fragInput.light;
    #endif
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
#if defined(ALPHA_TEST_PASS)|| defined(OPAQUE_PASS)|| defined(TRANSPARENT_PASS)
vec3 applyFogVanilla(vec3 diffuse, vec3 fogColor, float fogIntensity) {
    return mix(diffuse, fogColor, fogIntensity);
}
#endif
#if ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(DEPTH_ONLY_PASS)
vec4 applyOverlayColor(vec4 diffuse, const vec4 overlayColor) {
    diffuse.rgb = mix(diffuse.rgb, overlayColor.rgb, overlayColor.a);
    return diffuse;
}
#endif
#if defined(MULTI_COLOR_TINT__OFF)&& ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(DEPTH_ONLY_PASS)
vec4 applyColorChange(vec4 originalColor, vec4 changeColor, float alpha) {
    originalColor.rgb = mix(originalColor, originalColor * changeColor, alpha).rgb;
    return originalColor;
}
#endif
#if defined(MULTI_COLOR_TINT__ON)&& ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(DEPTH_ONLY_PASS)
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
#endif
#if defined(ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
bool shouldDiscard(const float alpha) {
    return alpha < 0.5;
}
#endif
#if ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(DEPTH_ONLY_PASS)
vec4 applyItemInHandDiffuse(vec4 albedo, const vec3 color, const vec4 light, float colorChangeAlpha) {
    albedo.rgb *= mix(vec3(1.0, 1.0, 1.0), color, ColorBased.x).rgb;
    #ifdef MULTI_COLOR_TINT__OFF
    albedo = applyColorChange(albedo, ChangeColor, colorChangeAlpha);
    #endif
    #ifdef MULTI_COLOR_TINT__ON
    albedo = applyMultiColorChange(albedo, ChangeColor.rgb, MultiplicativeTintColor.rgb);
    #endif
    albedo = applyOverlayColor(albedo, OverlayColor);
    albedo = applyLighting(albedo, light);
    return albedo;
}
#endif
#if defined(ALPHA_TEST_PASS)|| defined(OPAQUE_PASS)|| defined(TRANSPARENT_PASS)
void ItemInHandApplyFog(FragmentInput fragInput, StandardSurfaceInput surfaceInput, StandardSurfaceOutput surfaceOutput, inout FragmentOutput fragOutput) {
    fragOutput.Color0.rgb = applyFogVanilla(fragOutput.Color0.rgb, surfaceInput.fog.rgb, surfaceInput.fog.a);
}
#endif
#if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
vec3 color_degamma(vec3 clr) {
    float e = 2.2;
    return pow(max(clr, vec3(0.0, 0.0, 0.0)), vec3(e, e, e));
}
vec4 color_degamma(vec4 clr) {
    return vec4(color_degamma(clr.rgb), clr.a);
}
#endif
struct ColorTransform {
    float hue;
    float saturation;
    float luminance;
};

#if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
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
void ItemInHandSurfGeometryPrepass(FragmentInput fragInput, StandardSurfaceInput surfaceInput, StandardSurfaceOutput surfaceOutput, inout FragmentOutput fragOutput) {
    applyPrepassSurfaceToGBuffer(
        fragInput.worldPos.xyz,
        fragInput.worldPos.xyz - PrevWorldPosOffset.xyz,
        TileLightIntensity.x,
        TileLightIntensity.y,
        surfaceOutput,
        fragOutput
    );
}
#endif
struct CompositingOutput {
    vec3 mLitColor;
};

#ifndef DEPTH_ONLY_PASS
vec4 standardComposite(StandardSurfaceOutput stdOutput, CompositingOutput compositingOutput) {
    return vec4(compositingOutput.mLitColor, stdOutput.Alpha);
}
#endif
#ifdef DEPTH_ONLY_OPAQUE_PASS
void StandardTemplate_FinalColorOverrideIdentity(FragmentInput fragInput, StandardSurfaceInput surfaceInput, StandardSurfaceOutput surfaceOutput, inout FragmentOutput fragOutput) {
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
#ifdef ALPHA_TEST_PASS
void ItemInHandAlpha(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
    vec4 diffuse = applyItemInHandDiffuse(vec4(1.0, 1.0, 1.0, 1.0), surfaceInput.Color, surfaceInput.light, surfaceInput.Alpha);
    if (shouldDiscard(diffuse.a)) {
        discard;
    }
    surfaceOutput.Albedo = diffuse.rgb;
    surfaceOutput.Alpha = diffuse.a;
}
#endif
#ifdef DEPTH_ONLY_OPAQUE_PASS
void ItemInHandSurf(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
}
#endif
#if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
void ItemInHand_getPBRSurfaceOutputValues(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput, bool isAlphaTest) {
    vec3 surfaceColor = color_degamma(surfaceInput.Color);
    vec4 diffuse = applyItemInHandDiffuse(vec4(1.0, 1.0, 1.0, 1.0), surfaceColor, surfaceInput.light, surfaceInput.Alpha);
    if (isAlphaTest && shouldDiscard(diffuse.a)) {
        discard;
    }
    surfaceOutput.Albedo = diffuse.rgb;
    surfaceOutput.Alpha = diffuse.a;
    surfaceOutput.Roughness = 0.5;
    surfaceOutput.Metallic = 0.0;
    surfaceOutput.Emissive = 0.0;
    surfaceOutput.ViewSpaceNormal = surfaceInput.normal;
}
void ItemInHandGeometryPrepass(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
    #ifdef GEOMETRY_PREPASS_PASS
    ItemInHand_getPBRSurfaceOutputValues(surfaceInput, surfaceOutput, false);
    #endif
    #ifdef GEOMETRY_PREPASS_ALPHA_TEST_PASS
    ItemInHand_getPBRSurfaceOutputValues(surfaceInput, surfaceOutput, true);
    #endif
}
#endif
#ifdef OPAQUE_PASS
void ItemInHandOpaque(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
    vec4 diffuse = applyItemInHandDiffuse(vec4(1.0, 1.0, 1.0, 1.0), surfaceInput.Color, surfaceInput.light, surfaceInput.Alpha);
    surfaceOutput.Albedo = diffuse.rgb;
    surfaceOutput.Alpha = diffuse.a;
}
#endif
#ifdef TRANSPARENT_PASS
void ItemInHandTransparent(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
    vec4 diffuse = applyItemInHandDiffuse(vec4(1.0, 1.0, 1.0, 1.0), surfaceInput.Color, surfaceInput.light, surfaceInput.Alpha);
    surfaceOutput.Albedo = diffuse.rgb;
    surfaceOutput.Alpha = diffuse.a;
}
#endif
#ifndef DEPTH_ONLY_PASS
void StandardTemplate_Opaque_Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    StandardSurfaceInput surfaceInput = StandardTemplate_DefaultInput(fragInput);
    StandardSurfaceOutput surfaceOutput = StandardTemplate_DefaultOutput();
    surfaceInput.UV = fragInput.texcoord0;
    surfaceInput.Color = fragInput.color0.xyz;
    surfaceInput.Alpha = fragInput.color0.a;
    #ifdef ALPHA_TEST_PASS
    ItemInHandAlpha(surfaceInput, surfaceOutput);
    #endif
    #ifdef DEPTH_ONLY_OPAQUE_PASS
    ItemInHandSurf(surfaceInput, surfaceOutput);
    #endif
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    ItemInHandGeometryPrepass(surfaceInput, surfaceOutput);
    #endif
    #ifdef OPAQUE_PASS
    ItemInHandOpaque(surfaceInput, surfaceOutput);
    #endif
    #ifdef TRANSPARENT_PASS
    ItemInHandTransparent(surfaceInput, surfaceOutput);
    #endif
    DirectionalLight primaryLight;
    vec3 worldLightDirection = LightWorldSpaceDirection.xyz;
    primaryLight.ViewSpaceDirection = ((View) * (vec4(worldLightDirection, 0))).xyz;
    primaryLight.Intensity = LightDiffuseColorAndIlluminance.rgb * LightDiffuseColorAndIlluminance.w;
    CompositingOutput compositingOutput;
    compositingOutput.mLitColor = computeLighting_Unlit(fragInput, surfaceInput, surfaceOutput, primaryLight);
    fragOutput.Color0 = standardComposite(surfaceOutput, compositingOutput);
    #if defined(ALPHA_TEST_PASS)|| defined(OPAQUE_PASS)|| defined(TRANSPARENT_PASS)
    ItemInHandApplyFog(fragInput, surfaceInput, surfaceOutput, fragOutput);
    #endif
    #ifdef DEPTH_ONLY_OPAQUE_PASS
    StandardTemplate_FinalColorOverrideIdentity(fragInput, surfaceInput, surfaceOutput, fragOutput);
    #endif
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    ItemInHandSurfGeometryPrepass(fragInput, surfaceInput, surfaceOutput, fragOutput);
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
    fragmentInput.texcoord0 = v_texcoord0;
    fragmentInput.color0 = v_color0;
    #if ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)&& ! defined(GEOMETRY_PREPASS_PASS)
    fragmentInput.fog = v_fog;
    fragmentInput.light = v_light;
    #endif
    fragmentInput.worldPos = v_worldPos;
    fragmentInput.prevWorldPos = v_prevWorldPos;
    fragmentInput.normal = v_normal;
    #if defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    fragmentInput.light = v_light;
    fragmentInput.fog = v_fog;
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
    #ifndef DEPTH_ONLY_PASS
    StandardTemplate_Opaque_Frag(fragmentInput, fragmentOutput);
    #endif
    #ifdef DEPTH_ONLY_PASS
    StandardTemplate_DepthOnly_Frag(fragmentInput, fragmentOutput);
    #endif
    bgfx_FragData[0] = fragmentOutput.Color0; bgfx_FragData[1] = fragmentOutput.Color1; bgfx_FragData[2] = fragmentOutput.Color2; ;
}

