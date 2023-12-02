#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_PASS
* - DEPTH_ONLY_OPAQUE_PASS
* - GEOMETRY_PREPASS_PASS
* - GEOMETRY_PREPASS_ALPHA_TEST_PASS
*
* Change_Color:
* - CHANGE_COLOR__MULTI
* - CHANGE_COLOR__OFF
* - CHANGE_COLOR__ON
*
* Emissive:
* - EMISSIVE__EMISSIVE
* - EMISSIVE__EMISSIVE_ONLY
* - EMISSIVE__OFF
*
* Fancy:
* - FANCY__ON (not used)
*
* Instancing:
* - INSTANCING__OFF
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
out vec4 bgfx_FragData[gl_MaxDrawBuffers];
varying vec3 v_bitangent;
varying vec4 v_color0;
varying vec4 v_fog;
varying vec4 v_light;
varying vec3 v_normal;
varying vec3 v_prevWorldPos;
varying vec3 v_tangent;
centroid varying vec2 v_texcoord0;
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
    vec4 normal;
    #if defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(DEPTH_ONLY_PASS)
    vec4 tangent;
    #endif
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    int boneId;
    #endif
    vec3 position;
    vec2 texcoord0;
    vec4 color0;
    #if defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(DEPTH_ONLY_PASS)
    int boneId;
    #endif
    #if defined(INSTANCING__ON)&&(defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS))
    vec4 tangent;
    #endif
    #ifdef INSTANCING__ON
    vec4 instanceData0;
    vec4 instanceData1;
    vec4 instanceData2;
    #endif
    #if defined(INSTANCING__OFF)&&(defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS))
    vec4 tangent;
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
    vec3 worldPos;
    vec3 prevWorldPos;
    #if defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(DEPTH_ONLY_PASS)
    vec3 normal;
    #endif
    vec3 tangent;
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    vec3 normal;
    #endif
    vec3 bitangent;
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    vec4 light;
    vec4 fog;
    #endif
};

struct FragmentInput {
    vec2 texcoord0;
    vec4 color0;
    #if defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(DEPTH_ONLY_PASS)
    vec4 light;
    vec4 fog;
    #endif
    vec3 worldPos;
    vec3 prevWorldPos;
    #if defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(DEPTH_ONLY_PASS)
    vec3 normal;
    #endif
    vec3 tangent;
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    vec3 normal;
    #endif
    vec3 bitangent;
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    vec4 light;
    vec4 fog;
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
    vec4 fog;
    vec4 light;
    #endif
    vec3 worldPos;
    vec3 prevWorldPos;
    #if defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(DEPTH_ONLY_PASS)
    vec3 tangent;
    #endif
    vec3 normal;
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    vec3 tangent;
    #endif
    vec3 bitangent;
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    vec2 texcoord0;
    vec4 light;
    vec4 fog;
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
    result.fog = fragInput.fog;
    result.light = fragInput.light;
    #endif
    result.worldPos = fragInput.worldPos;
    result.prevWorldPos = fragInput.prevWorldPos;
    #if defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(DEPTH_ONLY_PASS)
    result.tangent = fragInput.tangent;
    #endif
    result.normal = fragInput.normal;
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    result.tangent = fragInput.tangent;
    #endif
    result.bitangent = fragInput.bitangent;
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    result.texcoord0 = fragInput.texcoord0;
    result.light = fragInput.light;
    result.fog = fragInput.fog;
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
#if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
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
#if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
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
    #ifndef EMISSIVE__OFF
    light = mix(vec4(1.0, 1.0, 1.0, 1.0), light, diffuse.a);
    #endif
    diffuse = applyLighting(diffuse, light);
    return diffuse;
}
#endif
#ifndef DEPTH_ONLY_OPAQUE_PASS
bool shouldDiscard(vec3 diffuse, float alpha, float epsilon) {
    bool result = false;
    #ifdef EMISSIVE__EMISSIVE
    result = dot(vec4(diffuse, alpha), vec4(1.0, 1.0, 1.0, 1.0)) < epsilon;
    #endif
    #ifdef EMISSIVE__EMISSIVE_ONLY
    result = alpha < epsilon || alpha > 1.0 - epsilon;
    #endif
    #if defined(EMISSIVE__OFF)&& ! defined(CHANGE_COLOR__OFF)
    result = alpha < epsilon;
    #endif
    #if defined(CHANGE_COLOR__OFF)&& defined(EMISSIVE__OFF)
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
#if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
vec4 applyActorDiffuse(vec4 albedo, vec3 color, vec4 light) {
    albedo.rgb *= mix(vec3(1, 1, 1), color, ColorBased.x);
    albedo = applyOverlayColor(albedo, OverlayColor);
    albedo = applyEmissiveLighting(albedo, light);
    return albedo;
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
#if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
float saturatedLinearRemapZeroToOne(float value, float zeroValue, float oneValue) {
    return clamp((((value) * (1.f / (oneValue - zeroValue))) + -zeroValue / (oneValue - zeroValue)), 0.0, 1.0);
}
vec3 calculateTangentNormalFromHeightmap(sampler2D heightmapTexture, vec2 heightmapUV, float mipLevel) {
    vec3 tangentNormal = vec3(0.f, 0.f, 1.f);
    const float kHeightMapPixelEdgeWidth = 1.0f / 12.0f;
    const float kHeightMapDepth = 4.0f;
    const float kRecipHeightMapDepth = 1.0f / kHeightMapDepth;
    float fadeForLowerMips = saturatedLinearRemapZeroToOne(mipLevel, 2.f, 1.f);
    if (fadeForLowerMips > 0.f)
    {
        vec2 widthHeight = vec2(textureSize(heightmapTexture, 0));
        vec2 pixelCoord = heightmapUV * widthHeight;
        {
            const float kNudgePixelCentreDistEpsilon = 0.0625f;
            const float kNudgeUvEpsilon = 0.25f / 65536.f;
            vec2 nudgeSampleCoord = fract(pixelCoord);
            if (abs(nudgeSampleCoord.x - 0.5) < kNudgePixelCentreDistEpsilon)
            {
                heightmapUV.x += (nudgeSampleCoord.x > 0.5f) ? kNudgeUvEpsilon : -kNudgeUvEpsilon;
            }
            if (abs(nudgeSampleCoord.y - 0.5) < kNudgePixelCentreDistEpsilon)
            {
                heightmapUV.y += (nudgeSampleCoord.y > 0.5f) ? kNudgeUvEpsilon : -kNudgeUvEpsilon;
            }
        }
        vec4 heightSamples = textureGather(heightmapTexture, heightmapUV, 0);
        vec2 subPixelCoord = fract(pixelCoord + 0.5f);
        const float kBevelMode = 0.0f;
        vec2 axisSamplePair = (subPixelCoord.y > 0.5f) ? heightSamples.xy : heightSamples.wz;
        float axisBevelCentreSampleCoord = subPixelCoord.x;
        axisBevelCentreSampleCoord += ((axisSamplePair.x > axisSamplePair.y) ? kHeightMapPixelEdgeWidth : -kHeightMapPixelEdgeWidth) * kBevelMode;
        ivec2 axisSampleIndices = ivec2(clamp(vec2(axisBevelCentreSampleCoord - kHeightMapPixelEdgeWidth, axisBevelCentreSampleCoord + kHeightMapPixelEdgeWidth) * 2.f, 0.0, 1.0));
        tangentNormal.x = (axisSamplePair[axisSampleIndices.x] - axisSamplePair[axisSampleIndices.y]);
        axisSamplePair = (subPixelCoord.x > 0.5f) ? heightSamples.zy : heightSamples.wx;
        axisBevelCentreSampleCoord = subPixelCoord.y;
        axisBevelCentreSampleCoord += ((axisSamplePair.x > axisSamplePair.y) ? kHeightMapPixelEdgeWidth : -kHeightMapPixelEdgeWidth) * kBevelMode;
        axisSampleIndices = ivec2(clamp(vec2(axisBevelCentreSampleCoord - kHeightMapPixelEdgeWidth, axisBevelCentreSampleCoord + kHeightMapPixelEdgeWidth) * 2.f, 0.0, 1.0));
        tangentNormal.y = (axisSamplePair[axisSampleIndices.x] - axisSamplePair[axisSampleIndices.y]);
        tangentNormal.z = kRecipHeightMapDepth;
        tangentNormal = normalize(tangentNormal);
        tangentNormal.xy *= fadeForLowerMips;
    }
    return tangentNormal;
}
void Actor_getPBRSurfaceOutputValues(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput, bool isAlphaTest) {
    vec4 albedo = getActorAlbedoNoColorChange(surfaceInput.texcoord0);
    float alpha = albedo.a;
    alpha = mix(alpha, alpha * OverlayColor.a, TintedAlphaTestEnabled.x);
    if (isAlphaTest && shouldDiscard(albedo.rgb, alpha, ActorFPEpsilon.x)) {
        discard;
    }
    albedo = applyChangeColor(albedo, ChangeColor, MultiplicativeTintColor.rgb, UseAlphaRewrite.x);
    vec4 diffuse = applyActorDiffuse(albedo, surfaceInput.Color, surfaceInput.light);
    surfaceOutput.Albedo = diffuse.rgb;
    surfaceOutput.Alpha = diffuse.a;
    int flags = int(PBRTextureFlags.x);
    float metalness = MetalnessUniform.x;
    float emissive = EmissiveUniform.x;
    float roughness = RoughnessUniform.x;
    const int kPBRTextureDataFlagHasMaterialTexture = (1 << 0);
    const int kPBRTextureDataFlagHasNormalTexture = (1 << 1);
    const int kPBRTextureDataFlagHasHeightMapTexture = (1 << 2);
    if ((flags & kPBRTextureDataFlagHasMaterialTexture) == kPBRTextureDataFlagHasMaterialTexture)
    {
        vec3 texel = textureSample(s_MERTexture, surfaceInput.UV).rgb;
        metalness = texel.r;
        emissive = texel.g;
        roughness = texel.b;
    }
    surfaceOutput.Metallic = metalness;
    surfaceOutput.Emissive = emissive;
    surfaceOutput.Roughness = roughness;
    if ((flags & kPBRTextureDataFlagHasNormalTexture) == kPBRTextureDataFlagHasNormalTexture)
    {
        vec3 tangentNormal = vec3(0.f, 0.f, 1.f);
        tangentNormal = textureSample(s_NormalTexture, surfaceInput.UV).xyz * 2.f - 1.f;
        mat3 tbn = mat3(
            normalize(surfaceInput.tangent),
            normalize(surfaceInput.bitangent),
            normalize(surfaceInput.normal)
        );
        tbn = transpose(tbn);
        surfaceOutput.ViewSpaceNormal = normalize(((tbn) * (tangentNormal)).xyz);
    }
    else if ((flags & kPBRTextureDataFlagHasHeightMapTexture) == kPBRTextureDataFlagHasHeightMapTexture) {
        vec3 tangentNormal = calculateTangentNormalFromHeightmap(s_NormalTexture, surfaceInput.UV, 1.0f);
        mat3 tbn = mat3(
            normalize(surfaceInput.tangent),
            normalize(surfaceInput.bitangent),
            normalize(surfaceInput.normal)
        );
        tbn = transpose(tbn);
        surfaceOutput.ViewSpaceNormal = normalize(((tbn) * (tangentNormal)).xyz);
    }
    else {
        surfaceOutput.ViewSpaceNormal = surfaceInput.normal;
    }
}
void ActorGeometryPrepass(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
    #ifdef GEOMETRY_PREPASS_PASS
    Actor_getPBRSurfaceOutputValues(surfaceInput, surfaceOutput, false);
    #endif
    #ifdef GEOMETRY_PREPASS_ALPHA_TEST_PASS
    Actor_getPBRSurfaceOutputValues(surfaceInput, surfaceOutput, true);
    #endif
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
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    ActorGeometryPrepass(surfaceInput, surfaceOutput);
    #endif
    DirectionalLight primaryLight;
    vec3 worldLightDirection = LightWorldSpaceDirection.xyz;
    primaryLight.ViewSpaceDirection = ((View) * (vec4(worldLightDirection, 0))).xyz;
    primaryLight.Intensity = LightDiffuseColorAndIlluminance.rgb * LightDiffuseColorAndIlluminance.w;
    CompositingOutput compositingOutput;
    compositingOutput.mLitColor = computeLighting_Unlit(fragInput, surfaceInput, surfaceOutput, primaryLight);
    fragOutput.Color0 = standardComposite(surfaceOutput, compositingOutput);
    #if defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(DEPTH_ONLY_PASS)
    ActorApplyFog(fragInput, surfaceInput, surfaceOutput, fragOutput);
    #endif
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
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
    fragmentInput.worldPos = v_worldPos;
    fragmentInput.prevWorldPos = v_prevWorldPos;
    #if defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(DEPTH_ONLY_PASS)
    fragmentInput.normal = v_normal;
    #endif
    fragmentInput.tangent = v_tangent;
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    fragmentInput.normal = v_normal;
    #endif
    fragmentInput.bitangent = v_bitangent;
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
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
    StandardTemplate_Opaque_Frag(fragmentInput, fragmentOutput);
    bgfx_FragData[0] = fragmentOutput.Color0; bgfx_FragData[1] = fragmentOutput.Color1; bgfx_FragData[2] = fragmentOutput.Color2; ;
}

