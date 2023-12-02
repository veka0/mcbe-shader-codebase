#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* FlipOcclusion:
* - FLIP_OCCLUSION__OFF (not used)
* - FLIP_OCCLUSION__ON (not used)
*
* NoOcclusion:
* - NO_OCCLUSION__OFF (not used)
* - NO_OCCLUSION__ON (not used)
*
* NoVariety:
* - NO_VARIETY__OFF
* - NO_VARIETY__ON (not used)
*/

#define attribute in
#define varying out
attribute vec4 a_color0;
attribute vec3 a_position;
attribute vec2 a_texcoord0;
varying vec4 v_fog;
varying float v_occlusionHeight;
varying vec2 v_occlusionUV;
varying vec2 v_texcoord0;
struct NoopSampler {
    int noop;
};

float fmod(float _a, float _b) {
    return _a - _b * trunc(_a / _b);
}
vec2 fmod(vec2 _a, vec2 _b) {
    return vec2(fmod(_a.x, _b.x), fmod(_a.y, _b.y));
}
vec3 fmod(vec3 _a, vec3 _b) {
    return vec3(fmod(_a.x, _b.x), fmod(_a.y, _b.y), fmod(_a.z, _b.z));
}
vec4 fmod(vec4 _a, vec4 _b) {
    return vec4(fmod(_a.x, _b.x), fmod(_a.y, _b.y), fmod(_a.z, _b.z), fmod(_a.w, _b.w));
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
float calculateFogIntensityVanilla(float cameraDepth, float maxDistance, float fogStart, float fogEnd) {
    float distance = cameraDepth / maxDistance;
    return clamp((distance - fogStart) / (fogEnd - fogStart), 0.0, 1.0);
}
void Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    vertOutput.texcoord0 = UVOffsetAndScale.xy + (vertInput.texcoord0 * UVOffsetAndScale.zw);
    #ifdef NO_VARIETY__OFF
    float spriteSelector = vertInput.color0.x * 255.0;
    vertOutput.texcoord0.x += spriteSelector * UVOffsetAndScale.z;
    #endif
    const float PARTICLE_BOX_DIMENSIONS = 30.0;
    const vec3 PARTICLE_BOX = vec3(PARTICLE_BOX_DIMENSIONS, PARTICLE_BOX_DIMENSIONS, PARTICLE_BOX_DIMENSIONS);
    vec3 worldSpacePosition = fmod(vertInput.position + PositionBaseOffset.xyz, PARTICLE_BOX);
    worldSpacePosition -= PARTICLE_BOX * 0.5f;
    worldSpacePosition += PositionForwardOffset.xyz;
    vec3 worldSpacePositionBottom = worldSpacePosition;
    vec3 worldSpacePositionTop = worldSpacePositionBottom + (Velocity.xyz * Dimensions.y);
    vec4 screenSpacePositionBottom = ((WorldViewProj) * (vec4(worldSpacePositionBottom, 1.0)));
    vec4 screenSpacePositionTop = ((WorldViewProj) * (vec4(worldSpacePositionTop, 1.0)));
    vec2 screenSpaceUpDirection = (screenSpacePositionTop.xy / screenSpacePositionTop.w) - (screenSpacePositionBottom.xy / screenSpacePositionBottom.w);
    vec2 screenSpaceRightDirection = normalize(vec2(-screenSpaceUpDirection.y, screenSpaceUpDirection.x));
    vertOutput.position = mix(screenSpacePositionTop, screenSpacePositionBottom, vertInput.texcoord0.y);
    vertOutput.position.xy += (0.5 - vertInput.texcoord0.x) * screenSpaceRightDirection * Dimensions.x;
    vec2 occlusionUV = worldSpacePosition.xz;
    occlusionUV += ViewPosition.xz;
    occlusionUV *= 1.0 / 64.0;
    occlusionUV += 0.5;
    vertOutput.occlusionUV = occlusionUV;
    float occlusionHeight = worldSpacePosition.y;
    occlusionHeight += ViewPosition.y - 0.5;
    occlusionHeight *= 1.0 / 255.0;
    vertOutput.occlusionHeight = occlusionHeight;
    float fogIntensity = calculateFogIntensityVanilla(vertOutput.position.z, FogAndDistanceControl.z, FogAndDistanceControl.x, FogAndDistanceControl.y);
    vertOutput.fog = vec4(FogColor.rgb, fogIntensity);
}
void main() {
    VertexInput vertexInput;
    VertexOutput vertexOutput;
    vertexInput.position = (a_position);
    vertexInput.texcoord0 = (a_texcoord0);
    vertexInput.color0 = (a_color0);
    vertexOutput.texcoord0 = vec2(0, 0);
    vertexOutput.occlusionUV = vec2(0, 0);
    vertexOutput.occlusionHeight = 0.0;
    vertexOutput.fog = vec4(0, 0, 0, 0);
    vertexOutput.position = vec4(0, 0, 0, 0);
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
    Vert(vertexInput, vertexOutput);
    v_texcoord0 = vertexOutput.texcoord0;
    v_occlusionUV = vertexOutput.occlusionUV;
    v_occlusionHeight = vertexOutput.occlusionHeight;
    v_fog = vertexOutput.fog;
    gl_Position = vertexOutput.position;
}

