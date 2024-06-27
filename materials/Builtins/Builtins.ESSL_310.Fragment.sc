/*
* Available Macros:
*
* Passes:
* - CLEAR0_PASS (not used)
* - CLEAR1_PASS (not used)
* - CLEAR2_PASS (not used)
* - CLEAR3_PASS (not used)
* - CLEAR4_PASS (not used)
* - CLEAR5_PASS (not used)
* - CLEAR6_PASS (not used)
* - CLEAR7_PASS (not used)
* - DEBUGFONT_PASS
*/

#ifdef DEBUGFONT_PASS
$input v_color0, v_color1, v_texcoord0
#endif
struct NoopSampler {
    int noop;
};

#ifdef DEBUGFONT_PASS
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

uniform vec4 bgfx_clear_color[8];
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
    #ifdef DEBUGFONT_PASS
    vec4 color0;
    vec4 color1;
    #endif
    vec3 position;
    #ifdef DEBUGFONT_PASS
    vec2 texcoord0;
    #endif
};

struct VertexOutput {
    vec4 position;
    #ifdef DEBUGFONT_PASS
    vec4 color0;
    vec4 color1;
    vec2 texcoord0;
    #endif
};

struct FragmentInput {
    #ifndef DEBUGFONT_PASS
    float dummy;
    #endif
    #ifdef DEBUGFONT_PASS
    vec4 color0;
    vec4 color1;
    vec2 texcoord0;
    #endif
};

struct FragmentOutput {
    vec4 Color0;
};

SAMPLER2D_AUTOREG(s_texColor);
void Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    #ifndef DEBUGFONT_PASS
    fragOutput.Color0 = bgfx_clear_color[0];
    #endif
    #ifdef DEBUGFONT_PASS
    vec4 color = mix(fragInput.color0, fragInput.color1, textureSample(s_texColor, fragInput.texcoord0).xxxx);
    if (color.w < 1.0 / 255.0)
    {
        discard;
    }
    fragOutput.Color0 = color;
    #endif
}
void main() {
    FragmentInput fragmentInput;
    FragmentOutput fragmentOutput;
    #ifdef DEBUGFONT_PASS
    fragmentInput.color0 = v_color0;
    fragmentInput.color1 = v_color1;
    fragmentInput.texcoord0 = v_texcoord0;
    #endif
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

