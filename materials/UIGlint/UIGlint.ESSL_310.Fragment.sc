/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*/

$input v_color, v_layer1UV, v_layer2UV, v_texcoord0
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

uniform vec4 UVOffset;
uniform vec4 GlintColor;
uniform vec4 HudOpacity;
uniform vec4 TintColor;
uniform vec4 UVRotation;
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
    vec4 color;
    vec3 position;
    vec2 texcoord0;
};

struct VertexOutput {
    vec4 position;
    vec4 color;
    vec2 layer1UV;
    vec2 layer2UV;
    vec2 texcoord0;
};

struct FragmentInput {
    vec4 color;
    vec2 layer1UV;
    vec2 layer2UV;
    vec2 texcoord0;
};

struct FragmentOutput {
    vec4 Color0;
};

SAMPLER2D_AUTOREG(s_GlintTexture);
SAMPLER2D_AUTOREG(s_MatTexture);
void Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    vec4 diffuse = textureSample(s_MatTexture, fragInput.texcoord0);
    if (diffuse.a <= 0.00390625) {
        discard;
    }
    vec4 layer1 = textureSample(s_GlintTexture, fract(fragInput.layer1UV));
    vec4 layer2 = textureSample(s_GlintTexture, fract(fragInput.layer2UV));
    vec4 glint = layer1 + layer2;
    glint *= GlintColor;
    diffuse.rgb = glint.rgb;
    diffuse = diffuse * TintColor;
    diffuse.rgb *= diffuse.rgb;
    diffuse.rgb *= TintColor.a;
    diffuse = diffuse * HudOpacity.x;
    fragOutput.Color0 = diffuse;
}
void main() {
    FragmentInput fragmentInput;
    FragmentOutput fragmentOutput;
    fragmentInput.color = v_color;
    fragmentInput.layer1UV = v_layer1UV;
    fragmentInput.layer2UV = v_layer2UV;
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

