#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_PASS
* - GEOMETRY_PREPASS_ALPHA_TEST_PASS
* - OPAQUE_PASS
*
* AlphaTest:
* - ALPHA_TEST__OFF (not used)
* - ALPHA_TEST__ON_DISCARD_VALUE_BASED (not used)
* - ALPHA_TEST__ON_VERTEX_TINT_MASK_BASED (not used)
*
* Fancy:
* - FANCY__ON (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON
*
* Lit:
* - LIT__OFF (not used)
* - LIT__ON (not used)
*
* UseTextures:
* - USE_TEXTURES__OFF
* - USE_TEXTURES__ON
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
varying vec4 v_light;
varying vec3 v_normal;
varying vec3 v_prevWorldPos;
varying vec3 v_tangent;
varying vec2 v_texcoord0;
varying vec3 v_worldPos;
struct NoopSampler {
    int noop;
};

#if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)&& defined(USE_TEXTURES__ON)
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
uniform mat4 u_view;
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
uniform mat4 PrevWorld;
uniform vec4 LightDiffuseColorAndIlluminance;
uniform vec4 LightWorldSpaceDirection;
uniform vec4 MatColor;
uniform vec4 SubPixelOffset;
uniform vec4 TileLightColor;
uniform vec4 ZShiftValue;
uniform vec4 merUniforms;
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
    vec4 light;
    vec3 normal;
    vec3 prevWorldPos;
    vec3 tangent;
    vec2 texcoord0;
    vec3 worldPos;
};

struct FragmentInput {
    vec3 bitangent;
    vec4 color0;
    vec4 light;
    vec3 normal;
    vec3 prevWorldPos;
    vec3 tangent;
    vec2 texcoord0;
    vec3 worldPos;
};

struct FragmentOutput {
    vec4 Color0; vec4 Color1; vec4 Color2;
};

uniform lowp sampler2D s_MatTexture;
struct StandardSurfaceInput {
    vec2 UV;
    vec3 Color;
    float Alpha;
    vec3 bitangent;
    vec4 light;
    vec3 normal;
    vec3 prevWorldPos;
    vec3 tangent;
    vec3 worldPos;
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
    result.bitangent = fragInput.bitangent;
    result.light = fragInput.light;
    result.normal = fragInput.normal;
    result.prevWorldPos = fragInput.prevWorldPos;
    result.tangent = fragInput.tangent;
    result.worldPos = fragInput.worldPos;
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
#ifdef GEOMETRY_PREPASS_ALPHA_TEST_PASS
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

#ifdef GEOMETRY_PREPASS_ALPHA_TEST_PASS
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
void SurfGeometryPrepassOverride(FragmentInput fragInput, StandardSurfaceInput surfaceInput, StandardSurfaceOutput surfaceOutput, inout FragmentOutput fragOutput) {
    applyPrepassSurfaceToGBuffer(
        fragInput.worldPos.xyz,
        fragInput.prevWorldPos.xyz,
        TileLightColor.x,
        TileLightColor.y,
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
#ifdef OPAQUE_PASS
void StandardTemplate_FinalColorOverrideIdentity(FragmentInput fragInput, StandardSurfaceInput surfaceInput, StandardSurfaceOutput surfaceOutput, inout FragmentOutput fragOutput) {
}
#endif
struct DirectionalLight {
    vec3 ViewSpaceDirection;
    vec3 Intensity;
};

#ifdef DEPTH_ONLY_PASS
void StandardTemplate_DepthOnly_Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
}
#endif
#ifndef DEPTH_ONLY_PASS
vec3 computeLighting_Unlit(FragmentInput fragInput, StandardSurfaceInput stdInput, StandardSurfaceOutput stdOutput, DirectionalLight primaryLight) {
    return stdOutput.Albedo;
}
void SurfGeometryPrepass(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)&& defined(USE_TEXTURES__OFF)
    vec4 albedo = vec4(1, 1, 1, 1);
    #endif
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)&& defined(USE_TEXTURES__ON)
    vec4 albedo = MatColor;
    albedo *= textureSample(s_MatTexture, surfaceInput.UV);
    #endif
    #ifdef GEOMETRY_PREPASS_ALPHA_TEST_PASS
    vec3 surfaceColor = color_degamma(surfaceInput.Color);
    if (albedo.a < 0.5) {
        discard;
    }
    surfaceOutput.Albedo = albedo.rgb * surfaceInput.Color.rgb;
    surfaceOutput.Alpha = albedo.a * surfaceInput.Alpha;
    surfaceOutput.Metallic = merUniforms.x;
    surfaceOutput.Emissive = merUniforms.y;
    surfaceOutput.Roughness = merUniforms.z;
    surfaceOutput.ViewSpaceNormal = surfaceInput.normal;
    #endif
}
void StandardTemplate_Opaque_Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    StandardSurfaceInput surfaceInput = StandardTemplate_DefaultInput(fragInput);
    StandardSurfaceOutput surfaceOutput = StandardTemplate_DefaultOutput();
    surfaceInput.UV = fragInput.texcoord0;
    surfaceInput.Color = fragInput.color0.xyz;
    surfaceInput.Alpha = fragInput.color0.a;
    SurfGeometryPrepass(surfaceInput, surfaceOutput);
    DirectionalLight primaryLight;
    vec3 worldLightDirection = LightWorldSpaceDirection.xyz;
    primaryLight.ViewSpaceDirection = ((View) * (vec4(worldLightDirection, 0))).xyz;
    primaryLight.Intensity = LightDiffuseColorAndIlluminance.rgb * LightDiffuseColorAndIlluminance.w;
    CompositingOutput compositingOutput;
    compositingOutput.mLitColor = computeLighting_Unlit(fragInput, surfaceInput, surfaceOutput, primaryLight);
    fragOutput.Color0 = standardComposite(surfaceOutput, compositingOutput);
    #ifdef GEOMETRY_PREPASS_ALPHA_TEST_PASS
    SurfGeometryPrepassOverride(fragInput, surfaceInput, surfaceOutput, fragOutput);
    #endif
    #ifdef OPAQUE_PASS
    StandardTemplate_FinalColorOverrideIdentity(fragInput, surfaceInput, surfaceOutput, fragOutput);
    #endif
}
#endif
void main() {
    FragmentInput fragmentInput;
    FragmentOutput fragmentOutput;
    fragmentInput.bitangent = v_bitangent;
    fragmentInput.color0 = v_color0;
    fragmentInput.light = v_light;
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
    #ifdef DEPTH_ONLY_PASS
    StandardTemplate_DepthOnly_Frag(fragmentInput, fragmentOutput);
    #endif
    #ifndef DEPTH_ONLY_PASS
    StandardTemplate_Opaque_Frag(fragmentInput, fragmentOutput);
    #endif
    bgfx_FragData[0] = fragmentOutput.Color0; bgfx_FragData[1] = fragmentOutput.Color1; bgfx_FragData[2] = fragmentOutput.Color2; ;
}

