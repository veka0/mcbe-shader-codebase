/*
* Available Macros:
*
* Passes:
* - BLEND_PASS (not used)
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

uniform vec4 PaperWhite;
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

SAMPLER2D_AUTOREG(s_TexColor);
vec3 NormalizeHDRSceneValue(vec3 hdrSceneValue, float paperWhiteNits) {
    const float MAX_NITS = 10000.0;
    vec3 normalizedLinearValue = hdrSceneValue * paperWhiteNits / MAX_NITS;
    return normalizedLinearValue;
}
vec3 LinearToST2084(vec3 normalizedLinearValue) {
    vec3 constant1 = vec3(0.1593017578, 0.1593017578, 0.1593017578);
    vec3 constant2 = vec3(78.84375, 78.84375, 78.84375);
    vec3 ST2084 = pow((0.8359375 + 18.8515625 * pow(abs(normalizedLinearValue), constant1)) / (1.0 + 18.6875 * pow(abs(normalizedLinearValue), constant1)), constant2);
    return ST2084;
}
vec4 ConvertToHDR10(vec4 hdrSceneValue, float paperWhiteNits) {
    mat3 from709to2020 = mtxFromRows(
        vec3(0.6274040, 0.3292820, 0.0433136),
        vec3(0.0690970, 0.9195400, 0.0113612),
        vec3(0.0163916, 0.0880132, 0.8955950)
    );
    vec3 rec2020 = ((from709to2020) * (hdrSceneValue.rgb)); // Attention!
    vec3 normalizedLinearValue = NormalizeHDRSceneValue(rec2020, paperWhiteNits);
    vec3 HDR10 = LinearToST2084(normalizedLinearValue);
    return vec4(HDR10.r, HDR10.g, HDR10.b, hdrSceneValue.a);
}
void Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    vec4 c = textureSample(s_TexColor, fragInput.texcoord0);
    fragOutput.Color0 = ConvertToHDR10(c, PaperWhite.x);
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

