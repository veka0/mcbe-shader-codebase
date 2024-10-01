/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_OPAQUE_PASS
* - GEOMETRY_PREPASS_PASS
* - GEOMETRY_PREPASS_ALPHA_TEST_PASS
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

$input v_bitangent, v_color0, v_glintUV, v_mers, v_normal, v_prevWorldPos, v_tangent, v_texcoord0, v_worldPos
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
vec4 textureSample(mediump samplerCubeArray _sampler, vec4 _coord, float _lod) {
    return textureLod(_sampler, _coord, _lod);
}
vec4 textureSample(mediump samplerCubeArray _sampler, vec4 _coord, int _lod) {
    return textureLod(_sampler, _coord, float(_lod));
}
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

uniform vec4 FogControl;
uniform vec4 ChangeColor;
uniform vec4 OverlayColor;
uniform mat4 PrevWorld;
uniform vec4 ColorBased;
uniform vec4 FogColor;
uniform vec4 GlintColor;
uniform vec4 UVScale;
uniform vec4 LightDiffuseColorAndIlluminance;
uniform vec4 LightWorldSpaceDirection;
uniform vec4 MaterialID;
uniform vec4 MultiplicativeTintColor;
uniform vec4 SubPixelOffset;
uniform vec4 TileLightColor;
uniform vec4 TileLightIntensity;
uniform vec4 UVAnimation;
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
    vec4 color0;
    vec4 glintUV;
    vec4 mers;
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
    vec4 glintUV;
    vec4 mers;
    vec3 normal;
    vec3 prevWorldPos;
    vec3 tangent;
    vec2 texcoord0;
    vec3 worldPos;
};

struct FragmentInput {
    vec3 bitangent;
    vec4 color0;
    vec4 glintUV;
    vec4 mers;
    vec3 normal;
    vec3 prevWorldPos;
    vec3 tangent;
    vec2 texcoord0;
    vec3 worldPos;
};

struct FragmentOutput {
    vec4 Color0; vec4 Color1; vec4 Color2;
};

SAMPLER2D_AUTOREG(s_GlintTexture);
struct StandardSurfaceInput {
    vec2 UV;
    vec3 Color;
    float Alpha;
    vec3 bitangent;
    vec4 glintUV;
    vec4 mers;
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
    result.bitangent = fragInput.bitangent;
    result.glintUV = fragInput.glintUV;
    result.mers = fragInput.mers;
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
#ifndef DEPTH_ONLY_OPAQUE_PASS
vec2 calculateMotionVector(vec3 worldPosition, vec3 previousWorldPosition) {
    vec4 screenSpacePos = ((ViewProj) * (vec4(worldPosition, 1.0))); // Attention!
    screenSpacePos /= screenSpacePos.w;
    screenSpacePos = screenSpacePos * 0.5 + 0.5;
    vec4 prevScreenSpacePos = ((PrevViewProj) * (vec4(previousWorldPosition, 1.0))); // Attention!
    prevScreenSpacePos /= prevScreenSpacePos.w;
    prevScreenSpacePos = prevScreenSpacePos * 0.5 + 0.5;
    return screenSpacePos.xy - prevScreenSpacePos.xy;
}
vec4 applyOverlayColor(vec4 diffuse, const vec4 overlayColor) {
    diffuse.rgb = mix(diffuse.rgb, overlayColor.rgb, overlayColor.a);
    return diffuse;
}
#endif
#if defined(MULTI_COLOR_TINT__OFF)&& ! defined(DEPTH_ONLY_OPAQUE_PASS)
vec4 applyColorChange(vec4 originalColor, vec4 changeColor, float alpha) {
    originalColor.rgb = mix(originalColor, originalColor * changeColor, alpha).rgb;
    return originalColor;
}
#endif
#if defined(MULTI_COLOR_TINT__ON)&& ! defined(DEPTH_ONLY_OPAQUE_PASS)
vec4 applyMultiColorChange(vec4 diffuse, vec3 changeColor, vec3 multiplicativeTintColor) {
    vec2 colorMask = diffuse.rg;
    diffuse.rgb = colorMask.rrr * changeColor;
    diffuse.rgb = mix(diffuse.rgb, colorMask.ggg * multiplicativeTintColor.rgb, ceil(colorMask.g));
    return diffuse;
}
#endif
struct ColorTransform {
    float hue;
    float saturation;
    float luminance;
};

#ifndef DEPTH_ONLY_OPAQUE_PASS
vec2 octWrap(vec2 v) {
    return (1.0 - abs(v.yx)) * ((2.0 * step(0.0, v)) - 1.0); // Attention!
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
void ItemInHandSurfGeometryPrepass(FragmentInput fragInput, StandardSurfaceInput surfaceInput, StandardSurfaceOutput surfaceOutput, inout FragmentOutput fragOutput) {
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
#ifdef DEPTH_ONLY_OPAQUE_PASS
void StandardTemplate_FinalColorOverrideIdentity(FragmentInput fragInput, StandardSurfaceInput surfaceInput, StandardSurfaceOutput surfaceOutput, inout FragmentOutput fragOutput) {
}
#endif
void StandardTemplate_CustomSurfaceShaderEntryIdentity(vec2 uv, vec3 worldPosition, inout StandardSurfaceOutput surfaceOutput) {
}
struct DirectionalLight {
    vec3 ViewSpaceDirection;
    vec3 Intensity;
};

vec3 computeLighting_Unlit(FragmentInput fragInput, StandardSurfaceInput stdInput, StandardSurfaceOutput stdOutput, DirectionalLight primaryLight) {
    return stdOutput.Albedo;
}
#ifdef DEPTH_ONLY_OPAQUE_PASS
void ItemInHandSurf(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
}
#endif
#ifndef DEPTH_ONLY_OPAQUE_PASS
vec4 glintBlend(const vec4 dest, const vec4 source) {
    return vec4(source.rgb * source.rgb, abs(source.a)) + vec4(dest.rgb, 0.0);
}
vec4 applyGlint(const vec4 diffuse, const vec4 layerUV, const sampler2D glintTexture, const vec4 glintColor, const vec4 tileLightColor) {
    vec4 tex1 = textureSample(glintTexture, fract(layerUV.xy)).rgbr * glintColor;
    vec4 tex2 = textureSample(glintTexture, fract(layerUV.zw)).rgbr * glintColor;
    vec4 glint = (tex1 + tex2) * tileLightColor;
    glint = glintBlend(diffuse, glint);
    glint.a = diffuse.a;
    return glint;
}
vec4 applyItemInHandDiffusePBR(vec4 albedo, const vec3 color, float colorChangeAlpha) {
    albedo.rgb *= mix(vec3(1.0, 1.0, 1.0), color, ColorBased.x).rgb;
    #ifdef MULTI_COLOR_TINT__OFF
    albedo = applyColorChange(albedo, ChangeColor, colorChangeAlpha);
    #endif
    #ifdef MULTI_COLOR_TINT__ON
    albedo = applyMultiColorChange(albedo, ChangeColor.rgb, MultiplicativeTintColor.rgb);
    #endif
    albedo = applyOverlayColor(albedo, OverlayColor);
    return albedo;
}
vec4 applyItemInHandGlintDiffusePBR(vec4 albedo, const vec3 color, const vec4 glintUV, float colorChangeAlpha) {
    albedo = applyItemInHandDiffusePBR(albedo, color, colorChangeAlpha);
    albedo = applyGlint(albedo, glintUV, s_GlintTexture, GlintColor, TileLightColor);
    return albedo;
}
void ItemInHandGlint_getPBRSurfaceOutputValues(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput, bool isAlphaTest) {
    vec4 diffuse = applyItemInHandGlintDiffusePBR(vec4(1.0, 1.0, 1.0, 1.0), surfaceInput.Color, surfaceInput.glintUV, surfaceInput.Alpha);
    if (isAlphaTest && diffuse.a < 0.5) {
        discard;
    }
    surfaceOutput.Albedo = diffuse.rgb;
    surfaceOutput.Alpha = 1.0;
    surfaceOutput.Roughness = 0.5;
    surfaceOutput.Metallic = 0.0;
    surfaceOutput.Emissive = 0.0;
    surfaceOutput.ViewSpaceNormal = surfaceInput.normal;
}
void ItemInHandGeometryPrepass(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
    #ifdef GEOMETRY_PREPASS_PASS
    ItemInHandGlint_getPBRSurfaceOutputValues(surfaceInput, surfaceOutput, false);
    #endif
    #ifdef GEOMETRY_PREPASS_ALPHA_TEST_PASS
    ItemInHandGlint_getPBRSurfaceOutputValues(surfaceInput, surfaceOutput, true);
    #endif
    surfaceOutput.Metallic = surfaceInput.mers.x;
    surfaceOutput.Emissive = surfaceInput.mers.y;
    surfaceOutput.Roughness = surfaceInput.mers.z;
    surfaceOutput.Subsurface = surfaceInput.mers.w;
}
#endif
void StandardTemplate_Opaque_Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    StandardSurfaceInput surfaceInput = StandardTemplate_DefaultInput(fragInput);
    StandardSurfaceOutput surfaceOutput = StandardTemplate_DefaultOutput();
    surfaceInput.UV = fragInput.texcoord0;
    surfaceInput.Color = fragInput.color0.xyz;
    surfaceInput.Alpha = fragInput.color0.a;
    #ifdef DEPTH_ONLY_OPAQUE_PASS
    ItemInHandSurf(surfaceInput, surfaceOutput);
    #endif
    #ifndef DEPTH_ONLY_OPAQUE_PASS
    ItemInHandGeometryPrepass(surfaceInput, surfaceOutput);
    #endif
    StandardTemplate_CustomSurfaceShaderEntryIdentity(surfaceInput.UV, fragInput.worldPos, surfaceOutput);
    DirectionalLight primaryLight;
    vec3 worldLightDirection = LightWorldSpaceDirection.xyz;
    primaryLight.ViewSpaceDirection = ((View) * (vec4(worldLightDirection, 0))).xyz; // Attention!
    primaryLight.Intensity = LightDiffuseColorAndIlluminance.rgb * LightDiffuseColorAndIlluminance.w;
    CompositingOutput compositingOutput;
    compositingOutput.mLitColor = computeLighting_Unlit(fragInput, surfaceInput, surfaceOutput, primaryLight);
    fragOutput.Color0 = standardComposite(surfaceOutput, compositingOutput);
    #ifdef DEPTH_ONLY_OPAQUE_PASS
    StandardTemplate_FinalColorOverrideIdentity(fragInput, surfaceInput, surfaceOutput, fragOutput);
    #endif
    #ifndef DEPTH_ONLY_OPAQUE_PASS
    ItemInHandSurfGeometryPrepass(fragInput, surfaceInput, surfaceOutput, fragOutput);
    #endif
}
void main() {
    FragmentInput fragmentInput;
    FragmentOutput fragmentOutput;
    fragmentInput.bitangent = v_bitangent;
    fragmentInput.color0 = v_color0;
    fragmentInput.glintUV = v_glintUV;
    fragmentInput.mers = v_mers;
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
    gl_FragData[0] = fragmentOutput.Color0; gl_FragData[1] = fragmentOutput.Color1; gl_FragData[2] = fragmentOutput.Color2; ;
}

