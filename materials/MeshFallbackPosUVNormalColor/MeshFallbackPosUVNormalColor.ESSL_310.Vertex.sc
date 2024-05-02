/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - DEPTH_ONLY_PASS (not used)
* - OPAQUE_PASS (not used)
* - RASTERIZED_ALPHA_TEST_PASS
* - RASTERIZED_OPAQUE_PASS
* - RASTERIZED_TRANSPARENT_PASS
* - TRANSPARENT_PASS (not used)
*
* AlphaTest:
* - ALPHA_TEST__OFF (not used)
* - ALPHA_TEST__ON_DISCARD_VALUE_BASED (not used)
* - ALPHA_TEST__ON_VERTEX_TINT_MASK_BASED (not used)
*
* Lit:
* - LIT__OFF (not used)
* - LIT__ON
*
* MultiColorTint:
* - MULTI_COLOR_TINT__OFF (not used)
* - MULTI_COLOR_TINT__ON (not used)
*
* UseTextures:
* - USE_TEXTURES__OFF (not used)
* - USE_TEXTURES__ON (not used)
*/

$input a_color0, a_normal, a_position, a_texcoord0
$output v_color, v_fog, v_light, v_texCoords
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

uniform vec4 FogControl;
uniform vec4 ChangeColor;
uniform vec4 OverlayColor;
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

SAMPLER2D_AUTOREG(s_MatTexture);
float calculateFogIntensityVanilla(float cameraDepth, float maxDistance, float fogStart, float fogEnd) {
    float distance = cameraDepth / maxDistance;
    return clamp((distance - fogStart) / (fogEnd - fogStart), 0.0, 1.0);
}
#if ! defined(RASTERIZED_ALPHA_TEST_PASS)&& ! defined(RASTERIZED_OPAQUE_PASS)&& ! defined(RASTERIZED_TRANSPARENT_PASS)
vec4 jitterVertexPosition(vec3 worldPosition) {
    mat4 offsetProj = Proj;
    offsetProj[2][0] += SubPixelOffset.x; // Attention!
    offsetProj[2][1] -= SubPixelOffset.y; // Attention!
    return ((offsetProj) * (((View) * (vec4(worldPosition, 1.0f))))); // Attention!
}
#endif
void FallbackFogVert(VertexInput vertInput, inout VertexOutput vertOutput) {
    float cameraDepth = vertOutput.position.z;
    float fogIntensity = calculateFogIntensityVanilla(cameraDepth, FogControl.z, FogControl.x, FogControl.y);
    vertOutput.fog = vec4(FogColor.rgb, fogIntensity);
}
void VertShared(VertexInput vertInput, inout VertexOutput vertOutput) {
    vertOutput.texCoords = UVAnimation.xy + (vertInput.texCoords.xy * UVAnimation.zw);
    vertOutput.color = vertInput.color;
    vertOutput.position.z += ZShiftValue.x;
    #ifdef LIT__ON
    float L = 1.0;
    vec3 N = normalize(((World) * (vertInput.normal)).xyz); // Attention!
    N.y *= TileLightColor.w;
    float yLight = (1.0 + N.y) * 0.5;
    L = yLight * (1.0 - 0.45) + N.x * N.x * -0.1 + N.z * N.z * 0.1 + 0.45;
    vertOutput.light = vec4(vec3(L, L, L) * TileLightColor.xyz, 1.0);
    vertOutput.light += OverlayColor.a * 0.35;
    #endif
    FallbackFogVert(vertInput, vertOutput);
}
#if ! defined(RASTERIZED_ALPHA_TEST_PASS)&& ! defined(RASTERIZED_OPAQUE_PASS)&& ! defined(RASTERIZED_TRANSPARENT_PASS)
void JitterVert(VertexInput vertInput, inout VertexOutput vertOutput) {
    vec3 wpos = ((World) * (vec4(vertInput.position, 1.0))).xyz; // Attention!
    vertOutput.position = jitterVertexPosition(wpos);
    VertShared(vertInput, vertOutput);
}
#endif
#if defined(RASTERIZED_ALPHA_TEST_PASS)|| defined(RASTERIZED_OPAQUE_PASS)|| defined(RASTERIZED_TRANSPARENT_PASS)
void RasterizedVert(VertexInput vertInput, inout VertexOutput vertOutput) {
    vertOutput.position = ((WorldViewProj) * (vec4(vertInput.position, 1.0))); // Attention!
    VertShared(vertInput, vertOutput);
}
#endif
void main() {
    VertexInput vertexInput;
    VertexOutput vertexOutput;
    vertexInput.color = (a_color0);
    vertexInput.normal = (a_normal);
    vertexInput.position = (a_position);
    vertexInput.texCoords = (a_texcoord0);
    vertexOutput.color = vec4(0, 0, 0, 0);
    vertexOutput.fog = vec4(0, 0, 0, 0);
    vertexOutput.light = vec4(0, 0, 0, 0);
    vertexOutput.texCoords = vec2(0, 0);
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
    #if ! defined(RASTERIZED_ALPHA_TEST_PASS)&& ! defined(RASTERIZED_OPAQUE_PASS)&& ! defined(RASTERIZED_TRANSPARENT_PASS)
    JitterVert(vertexInput, vertexOutput);
    #endif
    #if defined(RASTERIZED_ALPHA_TEST_PASS)|| defined(RASTERIZED_OPAQUE_PASS)|| defined(RASTERIZED_TRANSPARENT_PASS)
    RasterizedVert(vertexInput, vertexOutput);
    #endif
    v_color = vertexOutput.color;
    v_fog = vertexOutput.fog;
    v_light = vertexOutput.light;
    v_texCoords = vertexOutput.texCoords;
    gl_Position = vertexOutput.position;
}

