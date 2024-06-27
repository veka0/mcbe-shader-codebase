/*
* Available Macros:
*
* Passes:
* - CUSTOM_PASS_BASED_ON_OPAQUE_PASS
* - DEPTH_ONLY_PASS
* - OPAQUE_PASS
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON
*/

$input v_color0, v_texcoord0, v_viewSpaceNormal
#ifndef CUSTOM_PASS_BASED_ON_OPAQUE_PASS
$input v_viewSpacePosition
#endif
$input v_worldPos
struct NoopSampler {
    int noop;
};

#ifndef DEPTH_ONLY_PASS
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
#ifdef OPAQUE_PASS
vec2 vec2_splat(float _x) {
    return vec2(_x, _x);
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

uniform vec4 Ambient;
uniform vec4 LightAmbientColorAndIntensity;
uniform vec4 LightDiffuseColorAndIlluminance;
uniform vec4 ShadowFilterSize;
uniform vec4 LightWorldSpaceDirection;
uniform vec4 MaterialID;
uniform vec4 ShadowTexel;
uniform mat4 ShadowTransform;
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
    vec2 texcoord0;
    vec3 viewSpaceNormal;
    #ifndef CUSTOM_PASS_BASED_ON_OPAQUE_PASS
    vec4 viewSpacePosition;
    #endif
    vec3 worldPos;
};

struct FragmentInput {
    vec4 color0;
    vec2 texcoord0;
    vec3 viewSpaceNormal;
    #ifndef CUSTOM_PASS_BASED_ON_OPAQUE_PASS
    vec4 viewSpacePosition;
    #endif
    vec3 worldPos;
};

struct FragmentOutput {
    vec4 Color0;
};

SAMPLER2D_AUTOREG(s_MatTexture);
SAMPLER2D_AUTOREG(s_ShadowTexture);
struct StandardSurfaceInput {
    vec2 UV;
    vec3 Color;
    float Alpha;
    vec3 viewSpaceNormal;
    #ifndef CUSTOM_PASS_BASED_ON_OPAQUE_PASS
    vec4 viewSpacePosition;
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
    result.viewSpaceNormal = fragInput.viewSpaceNormal;
    #ifdef OPAQUE_PASS
    result.viewSpacePosition = fragInput.viewSpacePosition;
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
    float Subsurface;
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
    result.Subsurface = 0.0;
    result.AmbientLight = vec3(0.0, 0.0, 0.0);
    result.ViewSpaceNormal = vec3(0, 1, 0);
    return result;
}
#endif
struct CompositingOutput {
    vec3 mLitColor;
};

#ifndef DEPTH_ONLY_PASS
vec4 standardComposite(StandardSurfaceOutput stdOutput, CompositingOutput compositingOutput) {
    return vec4(compositingOutput.mLitColor, stdOutput.Alpha);
}
void StandardTemplate_FinalColorOverrideIdentity(FragmentInput fragInput, StandardSurfaceInput surfaceInput, StandardSurfaceOutput surfaceOutput, inout FragmentOutput fragOutput) {
}
void StandardTemplate_CustomSurfaceShaderEntryIdentity(vec2 uv, vec3 worldPosition, inout StandardSurfaceOutput surfaceOutput) {
}
#endif
struct DirectionalLight {
    vec3 ViewSpaceDirection;
    vec3 Intensity;
};

#ifdef CUSTOM_PASS_BASED_ON_OPAQUE_PASS
vec3 computeLighting_NdotL(FragmentInput fragInput, StandardSurfaceInput stdInput, StandardSurfaceOutput stdOutput, DirectionalLight primaryLight) {
    float l = clamp(dot(fragInput.viewSpaceNormal, - primaryLight.ViewSpaceDirection), 0.0, 1.0);
    return vec3(0.2, 0.2, 0.2) + (vec3(0.8, 0.8, 0.8) * l * stdOutput.Albedo);
}
#endif
#ifdef OPAQUE_PASS
vec3 computeLighting_BlinnPhong(FragmentInput fragInput, StandardSurfaceInput stdInput, StandardSurfaceOutput stdOutput, DirectionalLight primaryLight) {
    vec3 N = normalize(fragInput.viewSpaceNormal);
    vec3 L = normalize(-primaryLight.ViewSpaceDirection);
    vec3 ambientIntensity = LightAmbientColorAndIntensity.rgb * LightAmbientColorAndIntensity.w;
    float NdotL = dot(N, L);
    vec3 diffuseIntensity = clamp(NdotL, 0.0, 1.0) * primaryLight.Intensity;
    vec3 V = normalize(-fragInput.viewSpacePosition.xyz);
    vec3 H = normalize(L + V);
    float roughness = max(0.05, min(0.95, stdOutput.Roughness));
    float specularExponent = 2.0 / pow(roughness, 4.0) - 2.0;
    float normalizationFactor = (specularExponent + 2.0) / (4.0 * 3.1415926535897932384626433832795 * (2.0 - pow(2.0, - specularExponent / 2.0)));
    vec3 specularIntensity = clamp(normalizationFactor * pow(clamp(dot(N, H), 0.0, 1.0), specularExponent), 0.0, 1.0) * primaryLight.Intensity;
    vec4 worldSpacePosition = vec4(fragInput.worldPos.xyz, 1.0);
    vec4 shadowPos = ((ShadowTransform) * (worldSpacePosition)); // Attention!
    shadowPos.z = shadowPos.z * 0.5 + 0.5;
    float projectedDepth = shadowPos.z / shadowPos.w - 0.00025;
    vec2 shadowCoord = (shadowPos.xy / shadowPos.w) * 0.5 + vec2_splat(0.5);
    shadowCoord.y = 1.0 - shadowCoord.y;
    shadowCoord = (vec2((shadowCoord).x, 1.0 - (shadowCoord).y));
    float shadowOcclusion = 0.0;
    int filterSize = min(2, int(ShadowFilterSize.x));
    for(int y = -filterSize; y <= filterSize; y ++ ) {
        for(int x = -filterSize; x <= filterSize; x ++ ) {
            vec2 offset = vec2(x, y) * ShadowTexel.xy;
            float offsetDepth = textureSample(s_ShadowTexture, shadowCoord + offset).r;
            shadowOcclusion += projectedDepth - offsetDepth > 0.0 ? 1.0 : 0.0;
        }
    }
    float dimension = float(filterSize) * 2.0 + 1.0;
    shadowOcclusion /= dimension * dimension;
    vec2 texelFadeAmount = ShadowTexel.xy * 16.0;
    const vec2 uvOne = vec2(1.0, 1.0);
    vec2 fade = smoothstep(vec2(0.0, 0.0), texelFadeAmount, shadowCoord) * (uvOne - smoothstep(uvOne - texelFadeAmount, uvOne, shadowCoord)); // Attention!
    shadowOcclusion = shadowOcclusion * fade.x * fade.y;
    return
    ambientIntensity * stdOutput.Albedo + diffuseIntensity * stdOutput.Albedo * (1.0 - shadowOcclusion)
    + specularIntensity * (1.0 - shadowOcclusion);
}
#endif
#ifndef DEPTH_ONLY_PASS
void Surf(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
    surfaceOutput.Albedo = textureSample(s_MatTexture, surfaceInput.UV).xyz;
    #ifdef CUSTOM_PASS_BASED_ON_OPAQUE_PASS
    surfaceOutput.ViewSpaceNormal = ((WorldView) * (vec4(textureSample(s_MatTexture, surfaceInput.UV).xyz, 0))).xyz; // Attention!
    #endif
}
void StandardTemplate_Opaque_Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    StandardSurfaceInput surfaceInput = StandardTemplate_DefaultInput(fragInput);
    StandardSurfaceOutput surfaceOutput = StandardTemplate_DefaultOutput();
    surfaceInput.UV = fragInput.texcoord0;
    surfaceInput.Color = fragInput.color0.xyz;
    surfaceInput.Alpha = fragInput.color0.a;
    Surf(surfaceInput, surfaceOutput);
    StandardTemplate_CustomSurfaceShaderEntryIdentity(surfaceInput.UV, fragInput.worldPos, surfaceOutput);
    DirectionalLight primaryLight;
    vec3 worldLightDirection = LightWorldSpaceDirection.xyz;
    primaryLight.ViewSpaceDirection = ((View) * (vec4(worldLightDirection, 0))).xyz; // Attention!
    primaryLight.Intensity = LightDiffuseColorAndIlluminance.rgb * LightDiffuseColorAndIlluminance.w;
    CompositingOutput compositingOutput;
    #ifdef CUSTOM_PASS_BASED_ON_OPAQUE_PASS
    compositingOutput.mLitColor = computeLighting_NdotL(fragInput, surfaceInput, surfaceOutput, primaryLight);
    #endif
    #ifdef OPAQUE_PASS
    compositingOutput.mLitColor = computeLighting_BlinnPhong(fragInput, surfaceInput, surfaceOutput, primaryLight);
    #endif
    fragOutput.Color0 = standardComposite(surfaceOutput, compositingOutput);
    StandardTemplate_FinalColorOverrideIdentity(fragInput, surfaceInput, surfaceOutput, fragOutput);
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
    fragmentInput.texcoord0 = v_texcoord0;
    fragmentInput.viewSpaceNormal = v_viewSpaceNormal;
    #ifndef CUSTOM_PASS_BASED_ON_OPAQUE_PASS
    fragmentInput.viewSpacePosition = v_viewSpacePosition;
    #endif
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
    gl_FragColor = fragmentOutput.Color0;
}

