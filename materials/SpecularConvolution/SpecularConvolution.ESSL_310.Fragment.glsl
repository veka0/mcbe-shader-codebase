#version 310 es

/*
* Available Macros:
*
* Passes:
* - CONVOLVE_PASS
* - GENERATE_BRDF_PASS
*/

#ifdef CONVOLVE_PASS
#extension GL_EXT_shader_texture_lod : enable
#define texture2DLod textureLod
#define texture2DGrad textureGrad
#define texture2DProjLod textureProjLod
#define texture2DProjGrad textureProjGrad
#define textureCubeLod textureLod
#define textureCubeGrad textureGrad
#endif
#if GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif
#define attribute in
#define varying in
out vec4 bgfx_FragColor;
#ifdef CONVOLVE_PASS
varying vec3 v_viewVec;
#endif
#ifdef GENERATE_BRDF_PASS
varying vec2 v_texCoord;
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
uniform vec4 ConvolutionParameters;
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
    vec4 position;
};

struct VertexOutput {
    vec4 position;
    #ifdef CONVOLVE_PASS
    vec3 viewVec;
    #endif
    #ifdef GENERATE_BRDF_PASS
    vec2 texCoord;
    #endif
};

struct FragmentInput {
    #ifdef CONVOLVE_PASS
    vec3 viewVec;
    #endif
    #ifdef GENERATE_BRDF_PASS
    vec2 texCoord;
    #endif
};

struct FragmentOutput {
    vec4 Color0;
};

uniform lowp samplerCube s_CubeMap;
#ifdef CONVOLVE_PASS
float D_GGX_TrowbridgeReitz(vec3 N, vec3 H, float a) {
    float a2 = a * a;
    float nDotH = max(dot(N, H), 0.0);
    float f = max((a2 - 1.0) * nDotH * nDotH + 1.0, 1e - 4);
    return a2 / (f * f * 3.1415926535897932384626433832795);
}
#endif
#ifdef GENERATE_BRDF_PASS
float G_Smith(float nDotL, float nDotV, float a) {
    float k = a / 2.0;
    float viewTerm = nDotV / (nDotV * (1.0 - k) + k + 1e - 4);
    float lightTerm = nDotL / (nDotL * (1.0 - k) + k + 1e - 4);
    return viewTerm * lightTerm;
}
#endif
float VanDerCorpus(uint n, uint base) {
    float invBase = 1.0 / float(base);
    float denom = 1.0;
    float result = 0.0;
    for(int i = 0; i < 32; ++ i)
    {
        if (n > uint(0))
        {
            denom = mod(float(n), 2.0);
            result += denom * invBase;
            invBase = invBase / 2.0;
            n = uint(float(n) / 2.0);
        }
    }
    return result;
}
vec2 Hammersley(int i, int N) {
    float ri = VanDerCorpus(uint(i), uint(2));
    return vec2(float(i) / float(N), ri);
}
vec3 ImportanceSampleGGX(vec2 Xi, vec3 N, float roughness) {
    float a = roughness * roughness;
    float phi = 2.0 * 3.1415926535897932384626433832795 * Xi.x;
    float cosTheta = sqrt((1.0 - Xi.y) / (1.0 + ((a * a) - 1.0) * Xi.y));
    float sinTheta = cosTheta >= 1.0 ? 0.0 : sqrt(1.0 - cosTheta * cosTheta);
    vec3 H;
    H.x = cos(phi) * sinTheta;
    H.y = sin(phi) * sinTheta;
    H.z = cosTheta;
    vec3 up = abs(N.z) < 0.999 ? vec3(0.0, 0.0, 1.0) : vec3(1.0, 0.0, 0.0);
    vec3 tangent = normalize(cross(up, N));
    vec3 bitangent = cross(N, tangent);
    vec3 sampleVec = tangent * H.x + bitangent * H.y + N * H.z;
    return normalize(sampleVec);
}
#ifdef CONVOLVE_PASS
vec4 SampleCubemap(vec3 R, float lod) {
    return textureCubeLod(s_CubeMap, R, lod);
}
vec3 ImportanceSample(vec3 N) {
    vec3 R = N;
    vec3 V = R;
    float edgeLength = float(int(ConvolutionParameters.z));
    float roughness = (ConvolutionParameters.y / (ConvolutionParameters.w - 1.0));
    float totalWeight = 0.0;
    vec3 prefilteredColor = vec3(0.0, 0.0, 0.0);
    for(int i = 0; i < int(ConvolutionParameters.x); ++ i) {
        vec2 Xi = Hammersley(i, int(ConvolutionParameters.x));
        vec3 H = ImportanceSampleGGX(Xi, N, roughness);
        vec3 L = normalize(2.0 * dot(V, H) * H - V);
        float NdL = max(dot(N, L), 0.0);
        if (NdL > 0.0) {
            float NdH = max(dot(N, H), 0.0);
            float HdV = max(dot(H, V), 0.0);
            float pdf = (D_GGX_TrowbridgeReitz(N, H, roughness) * NdH / (4.0 * HdV)) + 0.0001;
            float saTexel = 4.0 * 3.1415926535897932384626433832795 / (6.0 * edgeLength * edgeLength);
            float saSample = 1.0 / (ConvolutionParameters.x * pdf + 0.0001);
            float lod = (roughness == 0.0) ? 0.0 : (0.5 * log2(saSample / saTexel));
            prefilteredColor += SampleCubemap(L, lod).rgb * NdL;
            totalWeight += NdL;
        }
    }
    prefilteredColor = prefilteredColor / totalWeight;
    return prefilteredColor;
}
#endif
#ifdef GENERATE_BRDF_PASS
vec4 IntegrateBrdf(float NdV, float roughness) {
    vec3 V;
    V.x = sqrt(1.0 - NdV * NdV);
    V.y = 0.0;
    V.z = NdV;
    float A = 0.0;
    float B = 0.0;
    vec3 N = vec3(0.0, 0.0, 1.0);
    for(int i = 0; i < int(ConvolutionParameters.x); ++ i) {
        vec2 Xi = Hammersley(i, int(ConvolutionParameters.x));
        vec3 H = ImportanceSampleGGX(Xi, N, roughness);
        vec3 L = normalize(2.0 * dot(V, H) * H - V);
        float NdL = max(L.z, 0.0);
        float NdH = max(H.z, 0.0);
        float VdH = max(dot(V, H), 0.0);
        if (NdL > 0.0) {
            float G = G_Smith(NdL, NdV, roughness * roughness);
            float G_Vis = (G * VdH) / (NdH * NdV);
            float Fc = pow(1.0 - VdH, 5.0);
            A += (1.0 - Fc) * G_Vis;
            B += Fc * G_Vis;
        }
    }
    A /= ConvolutionParameters.x;
    B /= ConvolutionParameters.x;
    return vec4(A, B, 0.0, 1.0);
}
#endif
void Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    #ifdef CONVOLVE_PASS
    vec3 R = normalize(fragInput.viewVec.xyz);
    vec3 importanceSampled;
    if (int(ConvolutionParameters.y) == 0) {
        importanceSampled = SampleCubemap(R, 0.0).rgb;
    }
    else {
        importanceSampled = ImportanceSample(R);
    }
    fragOutput.Color0 = vec4(importanceSampled, 1.0);
    #endif
    #ifdef GENERATE_BRDF_PASS
    vec4 color = IntegrateBrdf(fragInput.texCoord.x, fragInput.texCoord.y);
    fragOutput.Color0 = color;
    #endif
}
void main() {
    FragmentInput fragmentInput;
    FragmentOutput fragmentOutput;
    #ifdef CONVOLVE_PASS
    fragmentInput.viewVec = v_viewVec;
    #endif
    #ifdef GENERATE_BRDF_PASS
    fragmentInput.texCoord = v_texCoord;
    #endif
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
    Frag(fragmentInput, fragmentOutput);
    bgfx_FragColor = fragmentOutput.Color0;
}

