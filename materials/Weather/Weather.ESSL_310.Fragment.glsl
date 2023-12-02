#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* FlipOcclusion:
* - FLIP_OCCLUSION__OFF
* - FLIP_OCCLUSION__ON
*
* NoOcclusion:
* - NO_OCCLUSION__OFF
* - NO_OCCLUSION__ON
*
* NoVariety:
* - NO_VARIETY__OFF (not used)
* - NO_VARIETY__ON (not used)
*/

#if GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif
#define attribute in
#define varying in
out vec4 bgfx_FragColor;
varying vec4 v_fog;
varying float v_occlusionHeight;
varying vec2 v_occlusionUV;
varying vec2 v_texcoord0;
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

uniform vec4 u_viewRect;
uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 Dimensions;
uniform vec4 u_viewTexel;
uniform mat4 u_invView;
uniform vec4 ViewPosition;
uniform mat4 u_invProj;
uniform mat4 u_viewProj;
uniform mat4 u_invViewProj;
uniform mat4 u_prevViewProj;
uniform mat4 u_model[4];
uniform mat4 u_modelView;
uniform mat4 u_modelViewProj;
uniform vec4 u_prevWorldPosOffset;
uniform vec4 u_alphaRef4;
uniform vec4 UVOffsetAndScale;
uniform vec4 FogColor;
uniform vec4 OcclusionHeightOffset;
uniform vec4 FogAndDistanceControl;
uniform vec4 PositionForwardOffset;
uniform vec4 PositionBaseOffset;
uniform vec4 Velocity;
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
    vec3 position;
    vec2 texcoord0;
    vec4 color0;
};

struct VertexOutput {
    vec4 position;
    vec2 texcoord0;
    vec2 occlusionUV;
    float occlusionHeight;
    vec4 fog;
};

struct FragmentInput {
    vec2 texcoord0;
    vec2 occlusionUV;
    float occlusionHeight;
    vec4 fog;
};

struct FragmentOutput {
    vec4 Color0;
};

uniform lowp sampler2D s_WeatherTexture;
uniform lowp sampler2D s_OcclusionTexture;
uniform lowp sampler2D s_LightingTexture;
vec3 applyFogVanilla(vec3 diffuse, vec3 fogColor, float fogIntensity) {
    return mix(diffuse, fogColor, fogIntensity);
}
float getOcclusionHeight(const vec4 occlusionTextureSample) {
    float height = occlusionTextureSample.g + (occlusionTextureSample.b * 255.0f) - (OcclusionHeightOffset.x / 255.0f);
    return height;
}
float getOcclusionLuminance(const vec4 occlusionTextureSample) {
    return occlusionTextureSample.r;
}
bool isOccluded(const vec2 occlusionUV, const float occlusionHeight, const float occlusionHeightThreshold) {
    #if defined(FLIP_OCCLUSION__OFF)&& defined(NO_OCCLUSION__OFF)
    return (occlusionUV.x >= 0.0 && occlusionUV.x <= 1.0 && occlusionUV.y >= 0.0 && occlusionUV.y <= 1.0 && occlusionHeight < occlusionHeightThreshold);
    #endif
    #ifdef NO_OCCLUSION__ON
    return false;
    #endif
    #if defined(FLIP_OCCLUSION__ON)&& defined(NO_OCCLUSION__OFF)
    return (occlusionUV.x >= 0.0 && occlusionUV.x <= 1.0 && occlusionUV.y >= 0.0 && occlusionUV.y <= 1.0 && occlusionHeight > occlusionHeightThreshold);
    #endif
}
void Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    vec4 diffuse = textureSample(s_WeatherTexture, fragInput.texcoord0);
    vec4 occlusionLuminanceAndHeightThreshold = textureSample(s_OcclusionTexture, fragInput.occlusionUV);
    float occlusionLuminance = getOcclusionLuminance(occlusionLuminanceAndHeightThreshold);
    float occlusionHeightThreshold = getOcclusionHeight(occlusionLuminanceAndHeightThreshold);
    if (isOccluded(fragInput.occlusionUV, fragInput.occlusionHeight, occlusionHeightThreshold)) {
        diffuse.a = 0.0;
    }
    else {
        float mixAmount = (fragInput.occlusionHeight - occlusionHeightThreshold) * 25.0;
        float uvX = occlusionLuminance - (mixAmount * occlusionLuminance);
        vec2 lightingUV = vec2(uvX, 1.0);
        vec3 light = textureSample(s_LightingTexture, lightingUV).rgb;
        diffuse.rgb *= light;
        diffuse.rgb = applyFogVanilla(diffuse.rgb, fragInput.fog.rgb, fragInput.fog.a);
    }
    fragOutput.Color0 = diffuse;
}
void main() {
    FragmentInput fragmentInput;
    FragmentOutput fragmentOutput;
    fragmentInput.texcoord0 = v_texcoord0;
    fragmentInput.occlusionUV = v_occlusionUV;
    fragmentInput.occlusionHeight = v_occlusionHeight;
    fragmentInput.fog = v_fog;
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

