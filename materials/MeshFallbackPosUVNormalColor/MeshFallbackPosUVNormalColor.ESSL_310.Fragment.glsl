#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - DEPTH_ONLY_PASS (not used)
* - OPAQUE_PASS (not used)
* - RASTERIZED_ALPHA_TEST_PASS (not used)
* - RASTERIZED_OPAQUE_PASS (not used)
* - RASTERIZED_TRANSPARENT_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* AlphaTest:
* - ALPHA_TEST__OFF
* - ALPHA_TEST__ON_DISCARD_VALUE_BASED
* - ALPHA_TEST__ON_VERTEX_TINT_MASK_BASED
*
* Lit:
* - LIT__OFF
* - LIT__ON
*
* MultiColorTint:
* - MULTI_COLOR_TINT__OFF
* - MULTI_COLOR_TINT__ON
*
* UseTextures:
* - USE_TEXTURES__OFF
* - USE_TEXTURES__ON
*/

#extension GL_EXT_texture_cube_map_array : enable
#if GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif
#define attribute in
#define varying in
out vec4 bgfx_FragColor;
varying vec4 v_color;
varying vec4 v_fog;
varying vec4 v_light;
centroid varying vec2 v_texCoords;
struct NoopSampler {
    int noop;
};

#ifdef USE_TEXTURES__ON
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
uniform vec4 FogControl;
uniform vec4 ChangeColor;
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
uniform vec4 CurrentColor;
uniform vec4 FogColor;
uniform vec4 DiscardValue;
uniform vec4 HudOpacity;
uniform vec4 SubPixelOffset;
uniform vec4 TileLightColor;
uniform vec4 TileLightIntensity;
uniform vec4 UVAnimation;
uniform vec4 ZShiftValue;
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
    vec4 color;
    vec4 normal;
    vec3 position;
    vec2 texCoords;
};

struct VertexOutput {
    vec4 position;
    vec4 color;
    vec4 fog;
    vec4 light;
    vec2 texCoords;
};

struct FragmentInput {
    vec4 color;
    vec4 fog;
    vec4 light;
    vec2 texCoords;
};

struct FragmentOutput {
    vec4 Color0;
};

uniform lowp sampler2D s_MatTexture;
vec3 applyFogVanilla(vec3 diffuse, vec3 fogColor, float fogIntensity) {
    return mix(diffuse, fogColor, fogIntensity);
}
void FallbackApplyFog(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    fragOutput.Color0.rgb = applyFogVanilla(fragOutput.Color0.rgb, fragInput.fog.rgb, fragInput.fog.a);
}
void Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    #ifdef USE_TEXTURES__OFF
    vec4 diffuse = vec4(1, 1, 1, 1);
    #endif
    #ifdef USE_TEXTURES__ON
    vec4 diffuse = textureSample(s_MatTexture, fragInput.texCoords);
    #endif
    #if defined(ALPHA_TEST__ON_DISCARD_VALUE_BASED)&&(defined(LIT__ON)|| defined(MULTI_COLOR_TINT__ON))
    if (diffuse.a < DiscardValue.x)
    #endif
    #ifdef ALPHA_TEST__ON_VERTEX_TINT_MASK_BASED
    if (diffuse.a <= 0.0)
    #endif
    // Approximation, matches 120 cases out of 144
    #ifndef ALPHA_TEST__OFF
    discard;
    #endif
    #ifdef MULTI_COLOR_TINT__ON
    vec2 colorMask = diffuse.rg;
    diffuse.rgb = colorMask.rrr * fragInput.color.rgb;
    diffuse.rgb = mix(diffuse.rgb, colorMask.ggg * ChangeColor.rgb, ceil(colorMask.g));
    #endif
    #if defined(ALPHA_TEST__ON_DISCARD_VALUE_BASED)&& defined(LIT__OFF)&& defined(MULTI_COLOR_TINT__OFF)
    if (diffuse.a < DiscardValue.x)
    discard;
    #endif
    diffuse.rgb = mix(diffuse.rgb, OverlayColor.rgb, OverlayColor.a);
    #ifdef LIT__ON
    diffuse *= fragInput.light;
    #endif
    #ifdef MULTI_COLOR_TINT__OFF
    diffuse = CurrentColor * fragInput.color * diffuse;
    #endif
    diffuse.a *= HudOpacity.x;
    fragOutput.Color0 = diffuse;
    FallbackApplyFog(fragInput, fragOutput);
}
void main() {
    FragmentInput fragmentInput;
    FragmentOutput fragmentOutput;
    fragmentInput.color = v_color;
    fragmentInput.fog = v_fog;
    fragmentInput.light = v_light;
    fragmentInput.texCoords = v_texCoords;
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

