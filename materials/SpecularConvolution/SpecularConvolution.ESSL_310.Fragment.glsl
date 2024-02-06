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
float RadicalInverse_VdC(highp uint bits) {
    bits = (bits << 16u)|(bits >> 16u);
    bits = ((bits & 0x55555555u) << 1u)|((bits & 0xAAAAAAAAu) >> 1u);
    bits = ((bits & 0x33333333u) << 2u)|((bits & 0xCCCCCCCCu) >> 2u);
    bits = ((bits & 0x0F0F0F0Fu) << 4u)|((bits & 0xF0F0F0F0u) >> 4u);
    bits = ((bits & 0x00FF00FFu) << 8u)|((bits & 0xFF00FF00u) >> 8u);
    return float(bits) * 2.3283064365386963e - 10;
}
vec2 Hammersley(highp uint i, uint N) {
    float ri = RadicalInverse_VdC(i);
    return vec2(float(i) / float(N), ri);
}
vec3 ImportanceSampleGGX(vec2 Xi, vec3 N, float roughness) {
    float a = roughness * roughness;
    float phi = 2.0f * 3.1415926535897932384626433832795 * Xi.x;
    float cosTheta = sqrt((1.0f - Xi.y) / (1.0f + ((a * a) - 1.0f) * Xi.y));
    float sinTheta = sqrt(1.0f - cosTheta * cosTheta);
    vec3 H;
    H.x = cos(phi) * sinTheta;
    H.y = sin(phi) * sinTheta;
    H.z = cosTheta;
    vec3 tangentUp = abs(N.z) < 0.999f ? vec3(0, 0, 1) : vec3(1, 0, 0);
    vec3 tangentX = normalize(cross(tangentUp, N));
    vec3 tangentY = cross(N, tangentX);
    return tangentX * H.x + tangentY * H.y + N * H.z;
}
#ifdef CONVOLVE_PASS
vec4 SampleCubemap(vec3 R, float lod) {
    if (abs(R.y) > abs(R.x)&& abs(R.y) > abs(R.z)) {
        R.z *= -1.0;
    }
    else {
        R.y *= -1.0;
    }
    return textureCubeLod(s_CubeMap, R, lod);
}
vec3 ImportanceSample(vec3 V, vec3 N, float roughness, uint sampleCount, float edgeLength) {
    float totalWeight = 0.0;
    vec3 prefilteredColor = vec3(0.0, 0.0, 0.0);
    for(highp int i = 0; i < int(sampleCount); ++ i) {
        vec2 Xi = Hammersley(uint(i), sampleCount);
        vec3 H = ImportanceSampleGGX(Xi, N, roughness);
        vec3 L = 2.0f * dot(V, H) * H - V;
        float NdotL = clamp(dot(N, L), 0.0, 1.0);
        if (NdotL > 0.0f) {
            float NdotH = clamp(dot(N, H), 0.0, 1.0);
            float LdotH = clamp(dot(L, H), 0.0, 1.0);
            float pdf = D_GGX_TrowbridgeReitz(N, H, roughness * roughness) * NdotH / ((4.0f * LdotH) + 0.0001f);
            float omegaS = 1.0f / (float(sampleCount) * (pdf + 0.0001f));
            float omegaP = 4.0f * 3.1415926535897932384626433832795 / (6.0f * edgeLength * edgeLength);
            float mipLevel = max(0.5f * log2(omegaS / omegaP), 0.0f);
            prefilteredColor += SampleCubemap(L, mipLevel).rgb * NdotL;
            totalWeight += NdotL;
        }
    }
    totalWeight = max(0.001f, totalWeight);
    return prefilteredColor / totalWeight;
}
#endif
#ifdef GENERATE_BRDF_PASS
vec2 IntegrateBrdf(vec3 N, float NdotV, float roughness) {
    vec3 V;
    V.x = sqrt(1.0f - NdotV * NdotV);
    V.y = 0.0f;
    V.z = NdotV;
    float A = 0.0f;
    float B = 0.0f;
    for(highp int i = 0; i < int(ConvolutionParameters.x); ++ i) {
        vec2 Xi = Hammersley(uint(i), uint(ConvolutionParameters.x));
        vec3 H = ImportanceSampleGGX(Xi, N, roughness);
        vec3 L = 2.0f * dot(V, H) * H - V;
        float NdotL = clamp(L.z, 0.0, 1.0);
        float NdotH = clamp(H.z, 0.0, 1.0);
        float VdotH = clamp(dot(V, H), 0.0, 1.0);
        if (NdotL > 0.0f) {
            float G = G_Smith(NdotL, NdotV, roughness * roughness);
            float G_Vis = (G * VdotH) / (NdotH * NdotV);
            float Fc = pow(1.0f - VdotH, 5.0f);
            A += (1.0f - Fc) * G_Vis;
            B += Fc * G_Vis;
        }
    }
    A /= ConvolutionParameters.x;
    B /= ConvolutionParameters.x;
    return vec2(A, B);
}
#endif
void Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    #ifdef CONVOLVE_PASS
    vec3 importanceSampled;
    vec3 V = normalize(fragInput.viewVec.xyz);
    if (int(ConvolutionParameters.y) == 0) {
        if (abs(V.x) > abs(V.y)&& abs(V.x) > abs(V.z)) {
            V.z *= -1.0f;
            V.y *= -1.0f;
        }
        else if (abs(V.z) > abs(V.x)&& abs(V.z) > abs(V.y)) {
            V.x *= -1.0f;
            V.y *= -1.0f;
        }
        else {
            V.x *= -1.0f;
            V.z *= -1.0f;
        }
        importanceSampled = SampleCubemap(V, 0.0).rgb;
    }
    else {
        #endif
        vec3 N = vec3(0, 0, 1);
        #ifdef CONVOLVE_PASS
        if (abs(V.x) > abs(V.y)&& abs(V.x) > abs(V.z)) {
            N = vec3(sign(V.x), 0, 0);
        }
        else if (abs(V.z) > abs(V.x)&& abs(V.z) > abs(V.y)) {
            N = vec3(0, 0, sign(V.z));
        }
        else {
            N = vec3(0, sign(V.y), 0);
        }
        importanceSampled = ImportanceSample(V, N, (ConvolutionParameters.y / (ConvolutionParameters.w - 1.0)), uint(ConvolutionParameters.x), float(int(ConvolutionParameters.z)));
    }
    fragOutput.Color0 = vec4(importanceSampled, 1.0);
    #endif
    #ifdef GENERATE_BRDF_PASS
    float NdotV = fragInput.texCoord.x;
    float roughness = fragInput.texCoord.y;
    vec2 brdf = IntegrateBrdf(N, NdotV, roughness);
    fragOutput.Color0 = vec4(brdf.x, brdf.y, 0, 1);
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

