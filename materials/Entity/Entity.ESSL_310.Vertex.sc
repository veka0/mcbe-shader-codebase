/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - ALPHA_TEST_COLOR_MASK_PASS (not used)
* - ALPHA_TEST_COLOR_MASK_GLINT_PASS
* - ALPHA_TEST_COLOR_MASK_MULTIPLICATIVE_TINT_PASS (not used)
* - ALPHA_TEST_EMISSIVE_PASS (not used)
* - ALPHA_TEST_EMISSIVE_ONLY_PASS (not used)
* - ALPHA_TEST_GLINT_PASS
* - ALPHA_TEST_MASKED_OVERWRITE_PASS (not used)
* - ALPHA_TEST_MULTI_COLOR_PASS (not used)
* - BASE_COLOR_PASS (not used)
* - COLOR_MASK_PASS (not used)
* - EMISSIVE_PASS (not used)
* - GLINT_PASS
* - MULTI_COLOR_PASS (not used)
*
* SourceInputType0:
* - SOURCE_INPUT_TYPE0__CONSTANT (not used)
* - SOURCE_INPUT_TYPE0__SAMPLED (not used)
*
* SourceInputType1:
* - SOURCE_INPUT_TYPE1__CONSTANT (not used)
* - SOURCE_INPUT_TYPE1__SAMPLED (not used)
* - SOURCE_INPUT_TYPE1__SHARED0 (not used)
*
* SourceInputType2:
* - SOURCE_INPUT_TYPE2__CONSTANT (not used)
* - SOURCE_INPUT_TYPE2__SAMPLED (not used)
* - SOURCE_INPUT_TYPE2__SHARED0 (not used)
* - SOURCE_INPUT_TYPE2__SHARED1 (not used)
*/

$input a_indices, a_normal, a_position, a_texcoord0
$output v_fog, v_layerUv, v_light, v_texcoord0
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
uniform vec4 OverlayColor;
uniform mat4 Bones[8];
uniform vec4 FogColor;
uniform vec4 DiscardValue;
uniform vec4 GlintColor;
uniform vec4 UVAnimation;
uniform vec4 MatColor0;
uniform vec4 MatColor1;
uniform vec4 MatColor2;
uniform vec4 TileLightColor;
uniform vec4 TileLightIntensity;
uniform vec4 UVScale;
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
    int boneId;
    vec4 normal;
    vec3 position;
    vec2 texcoord0;
};

struct VertexOutput {
    vec4 position;
    vec4 fog;
    vec4 layerUv;
    vec4 light;
    vec2 texcoord0;
};

struct FragmentInput {
    vec4 fog;
    vec4 layerUv;
    vec4 light;
    vec2 texcoord0;
};

struct FragmentOutput {
    vec4 Color0;
};

SAMPLER2D_AUTOREG(s_MatTexture0);
SAMPLER2D_AUTOREG(s_MatTexture1);
SAMPLER2D_AUTOREG(s_MatTexture2);
#if defined(ALPHA_TEST_COLOR_MASK_GLINT_PASS)|| defined(ALPHA_TEST_GLINT_PASS)|| defined(GLINT_PASS)
vec2 CalculateLayerUV(const vec2 origUV, const float offset, const float rotation, const vec2 scale) {
    vec2 uv = origUV;
    uv -= 0.5;
    float rsin = sin(rotation);
    float rcos = cos(rotation);
    uv = ((uv) * (mat2(rcos, - rsin, rsin, rcos))); // Attention!
    uv.x += offset;
    uv += 0.5;
    return uv * scale;
}
void VertexGlint(VertexInput vertInput, inout VertexOutput vertOutput) {
    vertOutput.layerUv.xy = CalculateLayerUV(vertInput.texcoord0, UVAnimation.x, UVAnimation.z, UVScale.xy);
    vertOutput.layerUv.zw = CalculateLayerUV(vertInput.texcoord0, UVAnimation.y, UVAnimation.w, UVScale.xy);
    vertOutput.texcoord0 = vertInput.texcoord0;
}
#endif
float LightIntensity(const vec4 normal) {
    const float AMBIENT = 0.45;
    const float XFAC = -0.1;
    const float ZFAC = 0.1;
    vec3 N = normalize(((World) * (normal))).xyz; // Attention!
    N.y *= TileLightColor.a;
    float yLight = (1.0 + N.y) * 0.5;
    return yLight * (1.0 - AMBIENT) + N.x * N.x * XFAC + N.z * N.z * ZFAC + AMBIENT;
}
void VertexCommon(VertexInput vertInput, inout VertexOutput vertOutput) {
    vec4 entitySpacePosition = ((Bones[vertInput.boneId]) * (vec4(vertInput.position, 1))); // Attention!
    vec4 entitySpaceNormal = ((Bones[vertInput.boneId]) * (vertInput.normal)); // Attention!
    vertOutput.position = ((WorldViewProj) * (entitySpacePosition)); // Attention!
    vertOutput.texcoord0 = UVAnimation.xy + (vertInput.texcoord0 * UVAnimation.zw);
    float L = LightIntensity(entitySpaceNormal);
    L += OverlayColor.a * 0.35;
    vertOutput.light = vec4(L * TileLightColor.rgb, 1.0);
    vertOutput.fog.rgb = FogColor.rgb;
    vertOutput.fog.a = clamp(((vertOutput.position.z / FogControl.z) - FogControl.x) / (FogControl.y - FogControl.x), 0.0, 1.0);
}
void Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    VertexCommon(vertInput, vertOutput);
    #if defined(ALPHA_TEST_COLOR_MASK_GLINT_PASS)|| defined(ALPHA_TEST_GLINT_PASS)|| defined(GLINT_PASS)
    VertexGlint(vertInput, vertOutput);
    #endif
}
void main() {
    VertexInput vertexInput;
    VertexOutput vertexOutput;
    vertexInput.boneId = int(a_indices);
    vertexInput.normal = (a_normal);
    vertexInput.position = (a_position);
    vertexInput.texcoord0 = (a_texcoord0);
    vertexOutput.fog = vec4(0, 0, 0, 0);
    vertexOutput.layerUv = vec4(0, 0, 0, 0);
    vertexOutput.light = vec4(0, 0, 0, 0);
    vertexOutput.texcoord0 = vec2(0, 0);
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
    v_fog = vertexOutput.fog;
    v_layerUv = vertexOutput.layerUv;
    v_light = vertexOutput.light;
    v_texcoord0 = vertexOutput.texcoord0;
    gl_Position = vertexOutput.position;
}

