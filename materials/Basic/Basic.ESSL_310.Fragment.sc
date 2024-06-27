/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS
* - OPAQUE_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON
*
* SampleMatTexture:
* - SAMPLE_MAT_TEXTURE__OFF (not used)
* - SAMPLE_MAT_TEXTURE__ON
*
* TransformUV0:
* - TRANSFORM_UV0__OFF (not used)
* - TRANSFORM_UV0__ON (not used)
*/

$input v_bitangent, v_color0, v_normal, v_tangent, v_texcoord0, v_viewDir, v_wpos
struct NoopSampler {
    int noop;
};

#ifdef SAMPLE_MAT_TEXTURE__ON
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
mat4 mtxFromRows(vec4 _0, vec4 _1, vec4 _2, vec4 _3) {
    return transpose(mat4(_0, _1, _2, _3));
}
mat3 mtxFromRows(vec3 _0, vec3 _1, vec3 _2) {
    return transpose(mat3(_0, _1, _2));
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

uniform vec4 LightDirectionAndIntensity;
uniform vec4 MatColor;
uniform mat4 UV0Transform;
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
    vec4 color0;
    vec4 normal;
    vec3 position;
    vec4 tangent;
    vec2 texcoord0;
    #ifdef INSTANCING__ON
    vec4 instanceData0;
    vec4 instanceData1;
    vec4 instanceData2;
    #endif
};

struct VertexOutput {
    vec4 position;
    vec3 bitangent;
    vec4 color0;
    vec3 normal;
    vec3 tangent;
    vec2 texcoord0;
    vec3 viewDir;
    vec3 wpos;
};

struct FragmentInput {
    vec3 bitangent;
    vec4 color0;
    vec3 normal;
    vec3 tangent;
    vec2 texcoord0;
    vec3 viewDir;
    vec3 wpos;
};

struct FragmentOutput {
    vec4 Color0;
};

SAMPLER2D_AUTOREG(s_MatTexture);
void Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    mat3 tbn = mtxFromRows(
        normalize(fragInput.tangent),
        normalize(fragInput.bitangent),
        normalize(fragInput.normal)
    );
    mat3 vsToTs = transpose(tbn);
    vec3 normal;
    normal.xyz = vec3(0, 0, 1);
    vec3 vsLightDir = ((View) * (vec4(LightDirectionAndIntensity.xyz, 0))).xyz; // Attention!
    vec3 lightDir = normalize(vsLightDir.xyz);
    float l = clamp(dot(lightDir, fragInput.normal), 0.0, 1.0);
    vec4 lightColor = vec4(0.2, 0.2, 0.2, 0.2) + 0.8 * vec4(l, l, l, 1);
    vec4 diffuse = MatColor;
    #ifdef SAMPLE_MAT_TEXTURE__ON
    diffuse *= textureSample(s_MatTexture, fragInput.texcoord0);
    #endif
    #ifdef ALPHA_TEST_PASS
    const float ALPHA_THRESHOLD = 0.5;
    if (diffuse.a < ALPHA_THRESHOLD) {
        discard;
    }
    #endif
    diffuse *= fragInput.color0;
    fragOutput.Color0 = diffuse;
}
void main() {
    FragmentInput fragmentInput;
    FragmentOutput fragmentOutput;
    fragmentInput.bitangent = v_bitangent;
    fragmentInput.color0 = v_color0;
    fragmentInput.normal = v_normal;
    fragmentInput.tangent = v_tangent;
    fragmentInput.texcoord0 = v_texcoord0;
    fragmentInput.viewDir = v_viewDir;
    fragmentInput.wpos = v_wpos;
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

