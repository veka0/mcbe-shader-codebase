/*
* Available Macros:
*
* Passes:
* - OPAQUE_PASS
* - TRANSPARENT_PASS
*
* Fancy:
* - FANCY__OFF
* - FANCY__ON
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

uniform vec4 OverlayColor;
uniform vec4 FogAndDistanceControl;
uniform vec4 FogColor;
uniform vec4 SubPixelOffset;
uniform vec4 TileLightColor;
uniform vec4 UVAnimation;
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

SAMPLER2D_AUTOREG(s_BeaconTexture);
#ifdef OPAQUE_PASS
float calculateLightIntensity(const mat4 world, const vec4 normal, const vec4 tileLightColor) {
    #ifdef FANCY__OFF
    return 1.0;
    #endif
    #ifdef FANCY__ON
    const float AMBIENT = 0.45;
    const float XFAC = -0.1;
    const float ZFAC = 0.1;
    vec3 N = normalize(((world) * (normal))).xyz; // Attention!
    N.y *= tileLightColor.a;
    float yLight = (1.0 + N.y) * 0.5;
    return yLight * (1.0 - AMBIENT) + N.x * N.x * XFAC + N.z * N.z * ZFAC + AMBIENT;
    #endif
}
float calculateFogIntensityVanilla(float cameraDepth, float maxDistance, float fogStart, float fogEnd) {
    float distance = cameraDepth / maxDistance;
    return clamp((distance - fogStart) / (fogEnd - fogStart), 0.0, 1.0);
}
#endif
vec4 jitterVertexPosition(vec3 worldPosition) {
    mat4 offsetProj = Proj;
    offsetProj[2][0] += SubPixelOffset.x; // Attention!
    offsetProj[2][1] -= SubPixelOffset.y; // Attention!
    return ((offsetProj) * (((View) * (vec4(worldPosition, 1.0f))))); // Attention!
}
void Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    vertOutput.position = jitterVertexPosition(vertInput.position.xyz);
    #ifdef OPAQUE_PASS
    float lightIntensity = calculateLightIntensity(World, vec4(vertInput.normal.xyz, 0.0), TileLightColor);
    lightIntensity += OverlayColor.a * 0.35;
    vertOutput.light = vec4(lightIntensity * TileLightColor.xyz, 1.0);
    #endif
    vertOutput.color = vertInput.color;
    #ifdef OPAQUE_PASS
    vertOutput.texCoords = UVAnimation.xy + (vertInput.texCoords.xy * UVAnimation.zw);
    float fogIntensity = calculateFogIntensityVanilla(vertOutput.position.z, FogAndDistanceControl.z, FogAndDistanceControl.x, FogAndDistanceControl.y);
    vertOutput.fog = vec4(FogColor.rgb, fogIntensity);
    #endif
    #ifdef TRANSPARENT_PASS
    vertOutput.texCoords = vertInput.texCoords.xy;
    #endif
}
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
    Vert(vertexInput, vertexOutput);
    v_color = vertexOutput.color;
    v_fog = vertexOutput.fog;
    v_light = vertexOutput.light;
    v_texCoords = vertexOutput.texCoords;
    gl_Position = vertexOutput.position;
}

