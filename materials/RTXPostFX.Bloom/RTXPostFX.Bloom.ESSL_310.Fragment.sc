/*
* Available Macros:
*
* Passes:
* - BLOOM_DOWNSCALE_GAUSSIAN_PASS
* - BLOOM_DOWNSCALE_UNIFORM_PASS
* - BLOOM_FINAL_PASS
* - BLOOM_UPSCALE_PASS
*/

$input v_texcoord0
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

uniform vec4 RenderMode;
uniform vec4 ScreenSize;
uniform vec4 gBloomMultiplier;
uniform vec4 gViewportScale;
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
    vec2 texcoord0;
};

struct VertexOutput {
    vec4 position;
    vec2 texcoord0;
};

struct FragmentInput {
    vec2 texcoord0;
};

struct FragmentOutput {
    vec4 Color0;
};

SAMPLER2D_AUTOREG(s_RasterColor);
SAMPLER2D_AUTOREG(s_gBloomOriginalInput);
#ifdef BLOOM_DOWNSCALE_GAUSSIAN_PASS
vec4 applyDownscaleGaussianPass(FragmentInput fragInput) {
    return textureSample(s_RasterColor, fragInput.texcoord0);
}
#endif
#ifdef BLOOM_DOWNSCALE_UNIFORM_PASS
vec4 applyDownscaleUniformPass(FragmentInput fragInput) {
    return textureSample(s_RasterColor, fragInput.texcoord0);
}
#endif
#ifdef BLOOM_FINAL_PASS
vec4 applyBloomFinalPass(FragmentInput fragInput) {
    return textureSample(s_RasterColor, fragInput.texcoord0);
}
#endif
#ifdef BLOOM_UPSCALE_PASS
vec4 applyUpscalePass(FragmentInput fragInput) {
    return textureSample(s_RasterColor, fragInput.texcoord0);
}
#endif
void Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    #ifdef BLOOM_DOWNSCALE_GAUSSIAN_PASS
    fragOutput.Color0 = applyDownscaleGaussianPass(fragInput);
    #endif
    #ifdef BLOOM_DOWNSCALE_UNIFORM_PASS
    fragOutput.Color0 = applyDownscaleUniformPass(fragInput);
    #endif
    #ifdef BLOOM_FINAL_PASS
    fragOutput.Color0 = applyBloomFinalPass(fragInput);
    #endif
    #ifdef BLOOM_UPSCALE_PASS
    fragOutput.Color0 = applyUpscalePass(fragInput);
    #endif
}
void main() {
    FragmentInput fragmentInput;
    FragmentOutput fragmentOutput;
    fragmentInput.texcoord0 = v_texcoord0;
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
    gl_FragColor = fragmentOutput.Color0;
}

