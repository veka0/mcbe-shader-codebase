#version 310 es

/*
* Available Macros:
*
* Passes:
* - FALLBACK_PASS
* - GEOMETRY_PREPASS_PASS
* - OPAQUE_PASS
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON
*/

#if GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif
#define attribute in
#define varying in
#ifndef GEOMETRY_PREPASS_PASS
out vec4 bgfx_FragColor;
#endif
#ifdef GEOMETRY_PREPASS_PASS
out vec4 bgfx_FragData[gl_MaxDrawBuffers];
#endif
varying vec4 v_color0;
#ifdef GEOMETRY_PREPASS_PASS
varying vec3 v_normal;
varying vec3 v_prevWorldPos;
varying vec2 v_texcoord0;
varying vec3 v_worldPos;
#endif
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
uniform vec4 u_viewTexel;
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
uniform vec4 FogColor;
uniform vec4 LightDiffuseColorAndIlluminance;
uniform vec4 LightWorldSpaceDirection;
uniform vec4 SkyColor;
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
    #ifdef GEOMETRY_PREPASS_PASS
    vec2 texcoord0;
    #endif
    #ifdef INSTANCING__ON
    vec4 instanceData0;
    vec4 instanceData1;
    vec4 instanceData2;
    #endif
};

struct VertexOutput {
    vec4 position;
    vec4 color0;
    #ifdef GEOMETRY_PREPASS_PASS
    vec3 normal;
    vec3 prevWorldPos;
    vec2 texcoord0;
    vec3 worldPos;
    #endif
};

struct FragmentInput {
    vec4 color0;
    #ifdef GEOMETRY_PREPASS_PASS
    vec3 normal;
    vec3 prevWorldPos;
    vec2 texcoord0;
    vec3 worldPos;
    #endif
};

struct FragmentOutput {
    #ifndef GEOMETRY_PREPASS_PASS
    vec4 Color0;
    #endif
    #ifdef GEOMETRY_PREPASS_PASS
    vec4 Color0; vec4 Color1; vec4 Color2;
    #endif
};

#ifdef FALLBACK_PASS
void FallbackFrag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    fragOutput.Color0 = vec4(0.0, 0.0, 0.0, 0.0);
}
#endif
#ifdef GEOMETRY_PREPASS_PASS
struct StandardSurfaceInput {
    vec2 UV;
    vec3 Color;
    float Alpha;
    vec4 color0;
    vec3 normal;
    vec3 prevWorldPos;
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
    result.color0 = fragInput.color0;
    result.normal = fragInput.normal;
    result.prevWorldPos = fragInput.prevWorldPos;
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
struct ColorTransform {
    float hue;
    float saturation;
    float luminance;
};

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
void SkyGeometryPrepass(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
    surfaceOutput.Albedo = surfaceInput.Color.rgb;
    surfaceOutput.Alpha = surfaceInput.Alpha;
    surfaceOutput.Roughness = 0.5;
    surfaceOutput.Metallic = 0.0;
    surfaceOutput.Emissive = 1.0;
}
void SkySurfacePrepassOverride(FragmentInput fragInput, StandardSurfaceInput surfaceInput, StandardSurfaceOutput surfaceOutput, inout FragmentOutput fragOutput) {
    fragOutput.Color0.rgb = fragInput.color0.rgb;
    applyPrepassSurfaceToGBuffer(
        fragInput.worldPos.xyz,
        fragInput.worldPos.xyz - PrevWorldPosOffset.xyz,
        0.0f,
        0.0f,
        surfaceOutput,
        fragOutput
    );
}
void StandardTemplate_Opaque_Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    StandardSurfaceInput surfaceInput = StandardTemplate_DefaultInput(fragInput);
    StandardSurfaceOutput surfaceOutput = StandardTemplate_DefaultOutput();
    surfaceInput.UV = fragInput.texcoord0;
    surfaceInput.Color = fragInput.color0.xyz;
    surfaceInput.Alpha = fragInput.color0.a;
    SkyGeometryPrepass(surfaceInput, surfaceOutput);
    StandardTemplate_CustomSurfaceShaderEntryIdentity(surfaceInput.UV, fragInput.worldPos, surfaceOutput);
    DirectionalLight primaryLight;
    vec3 worldLightDirection = LightWorldSpaceDirection.xyz;
    primaryLight.ViewSpaceDirection = ((View) * (vec4(worldLightDirection, 0))).xyz;
    primaryLight.Intensity = LightDiffuseColorAndIlluminance.rgb * LightDiffuseColorAndIlluminance.w;
    CompositingOutput compositingOutput;
    compositingOutput.mLitColor = computeLighting_Unlit(fragInput, surfaceInput, surfaceOutput, primaryLight);
    fragOutput.Color0 = standardComposite(surfaceOutput, compositingOutput);
    SkySurfacePrepassOverride(fragInput, surfaceInput, surfaceOutput, fragOutput);
}
#endif
#ifdef OPAQUE_PASS
void Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    fragOutput.Color0 = fragInput.color0;
}
#endif
void main() {
    FragmentInput fragmentInput;
    FragmentOutput fragmentOutput;
    fragmentInput.color0 = v_color0;
    #ifndef GEOMETRY_PREPASS_PASS
    fragmentOutput.Color0 = vec4(0, 0, 0, 0);
    #endif
    #ifdef GEOMETRY_PREPASS_PASS
    fragmentInput.normal = v_normal;
    fragmentInput.prevWorldPos = v_prevWorldPos;
    fragmentInput.texcoord0 = v_texcoord0;
    fragmentInput.worldPos = v_worldPos;
    fragmentOutput.Color0 = vec4(0, 0, 0, 0); fragmentOutput.Color1 = vec4(0, 0, 0, 0); fragmentOutput.Color2 = vec4(0, 0, 0, 0);
    #endif
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
    #ifdef FALLBACK_PASS
    FallbackFrag(fragmentInput, fragmentOutput);
    #endif
    #ifdef OPAQUE_PASS
    Frag(fragmentInput, fragmentOutput);
    #endif
    #ifndef GEOMETRY_PREPASS_PASS
    bgfx_FragColor = fragmentOutput.Color0;
    #endif
    #ifdef GEOMETRY_PREPASS_PASS
    StandardTemplate_Opaque_Frag(fragmentInput, fragmentOutput);
    bgfx_FragData[0] = fragmentOutput.Color0; bgfx_FragData[1] = fragmentOutput.Color1; bgfx_FragData[2] = fragmentOutput.Color2; ;
    #endif
}

