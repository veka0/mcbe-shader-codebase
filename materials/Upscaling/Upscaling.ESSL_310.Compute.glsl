#version 310 es

/*
* Available Macros:
*
* Passes:
* - FALLBACK_PASS (not used)
* - TAAU_PASS (not used)
*/

#define shadow2D(_sampler, _coord)texture(_sampler, _coord)
#define shadow2DArray(_sampler, _coord)texture(_sampler, _coord)
#define shadow2DProj(_sampler, _coord)textureProj(_sampler, _coord)
struct NoopSampler {
    int noop;
};

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

uniform mat4 PreviousViewProjectionMatrixUniform;
uniform vec4 RenderResolutionDivDisplayResolution;
uniform vec4 DisplayResolutionDivRenderResolution;
uniform vec4 RecipDisplayResolution;
uniform vec4 SubPixelJitter;
uniform mat4 CurrentViewProjectionMatrixUniform;
uniform vec4 DisplayResolution;
uniform vec4 RenderResolution;
uniform vec4 CurrentWorldOrigin;
uniform vec4 PreviousWorldOrigin;
uvec3 LocalInvocationID;
uint LocalInvocationIndex;
uvec3 GlobalInvocationID;
uvec3 WorkGroupID;
struct VertexInput {
    float dummy;
};

struct VertexOutput {
    vec4 position;
};

struct FragmentInput {
    float dummy;
};

struct FragmentOutput {
    vec4 Color0;
};

uniform lowp sampler2D s_InputFinalColor;
uniform lowp sampler2D s_InputTAAHistory;
uniform lowp sampler2D s_InputBufferMotionVectors;
layout(rgba16f, binding = 3)writeonly uniform highp image2D s_OutputBuffer;
vec3 bicubicSampleCatmullRom(sampler2D tex, vec2 samplePos, vec2 recipTextureResolution) {
    vec2 tc = floor(samplePos - 0.5) + 0.5;
    vec2 f = clamp(samplePos - tc, 0.0, 1.0);
    vec2 f2 = f * f;
    vec2 f3 = f2 * f;
    vec2 w0 = f2 - 0.5 * (f3 + f);
    vec2 w1 = 1.5 * f3 - 2.5 * f2 + 1.0;
    vec2 w3 = 0.5 * (f3 - f2);
    vec2 w2 = 1.0 - w0 - w1 - w3;
    vec2 w12 = w1 + w2;
    vec2 tc0 = (tc - 1.0) * recipTextureResolution;
    vec2 tc12 = (tc + w2 / w12) * recipTextureResolution;
    vec2 tc3 = (tc + 2.0) * recipTextureResolution;
    vec3 result =
    textureSample(tex, vec2(tc0.x, tc0.y), 0.0).rgb * (w0.x * w0.y) +
    textureSample(tex, vec2(tc0.x, tc12.y), 0.0).rgb * (w0.x * w12.y) +
    textureSample(tex, vec2(tc0.x, tc3.y), 0.0).rgb * (w0.x * w3.y) +
    textureSample(tex, vec2(tc12.x, tc0.y), 0.0).rgb * (w12.x * w0.y) +
    textureSample(tex, vec2(tc12.x, tc12.y), 0.0).rgb * (w12.x * w12.y) +
    textureSample(tex, vec2(tc12.x, tc3.y), 0.0).rgb * (w12.x * w3.y) +
    textureSample(tex, vec2(tc3.x, tc0.y), 0.0).rgb * (w3.x * w0.y) +
    textureSample(tex, vec2(tc3.x, tc12.y), 0.0).rgb * (w3.x * w12.y) +
    textureSample(tex, vec2(tc3.x, tc3.y), 0.0).rgb * (w3.x * w3.y);
    return max(vec3(0.0, 0.0, 0.0), result);
}
float sampleWeight(vec2 delta, float scale) {
    float x = scale * dot(delta, delta);
    return clamp(1.0 - x, 0.05, 1.0);
}
void TAAU() {
    uint x = GlobalInvocationID.x;
    uint y = GlobalInvocationID.y;
    vec2 nearestRenderPos = vec2(float(x) + 0.5f, float(y) + 0.5f) * RenderResolutionDivDisplayResolution.x - SubPixelJitter.xy - 0.5f;
    ivec2 intRenderPos = ivec2(round(nearestRenderPos.x), round(nearestRenderPos.y));
    vec4 currentColor = texelFetch(s_InputFinalColor, intRenderPos, 0).rgba;
    vec2 motionPixels = texelFetch(s_InputBufferMotionVectors, intRenderPos, 0).ba;
    vec3 c1 = currentColor.rgb;
    vec3 c2 = currentColor.rgb * currentColor.rgb;
    for(int i = -1; i <= 1; i ++ )
    {
        for(int j = -1; j <= 1; j ++ )
        {
            if (i == 0 && j == 0)
            continue;
            ivec2 p = intRenderPos + ivec2(i, j);
            vec3 c = texelFetch(s_InputFinalColor, p, 0).rgb;
            vec2 mv = texelFetch(s_InputBufferMotionVectors, p, 0).ba;
            c1 = c1 + c;
            c2 = c2 + c * c;
        }
    }
    motionPixels *= RenderResolution.xy;
    c1 = c1 / 9.0f;
    c2 = c2 / 9.0f;
    vec3 extent = sqrt(max(vec3(0.0, 0.0, 0.0), c2 - c1 * c1));
    float motionWeight = smoothstep(0.0, 1.0f, sqrt(dot(motionPixels, motionPixels)));
    float bias = mix(4.0f, 1.0f, motionWeight);
    vec3 minValidColor = c1 - extent * bias;
    vec3 maxValidColor = c1 + extent * bias;
    vec2 posPreviousPixels = vec2(float(x) + 0.5f, float(y) + 0.5f) - motionPixels * DisplayResolutionDivRenderResolution.x;
    posPreviousPixels = clamp(posPreviousPixels, vec2(0, 0), DisplayResolution.xy - 1.0f);
    vec3 prevColor = bicubicSampleCatmullRom(s_InputTAAHistory, posPreviousPixels, RecipDisplayResolution.xy);
    prevColor = min(maxValidColor, max(minValidColor, prevColor));
    float pixelWeight = max(motionWeight, sampleWeight(nearestRenderPos - vec2(intRenderPos), DisplayResolutionDivRenderResolution.x)) * 0.1f;
    vec3 finalColor = mix(prevColor, currentColor.rgb, pixelWeight);
    imageStore(s_OutputBuffer, ivec2(x, y), vec4(finalColor, 0.0));
}

layout(local_size_x = 16, local_size_y = 16, local_size_z = 1)in;
void main() {
    LocalInvocationID = gl_LocalInvocationID;
    LocalInvocationIndex = gl_LocalInvocationIndex;
    GlobalInvocationID = gl_GlobalInvocationID;
    WorkGroupID = gl_WorkGroupID;
    TAAU();
}

