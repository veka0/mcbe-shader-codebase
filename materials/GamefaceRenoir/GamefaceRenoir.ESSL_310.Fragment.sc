/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*/

$input v_additional, v_color, v_screenPosition, v_varyingParam0, v_varyingParam1
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

uniform vec4 GradientMidColor;
uniform vec4 GradientYCoord;
uniform vec4 ShaderType;
uniform mat4 CoordTransformVS;
uniform vec4 GradientEndColor;
uniform vec4 GradientStartColor;
uniform vec4 MaskScaleAndOffset;
uniform mat4 Transform;
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
    vec4 additional;
    vec4 color;
    vec4 position;
};

struct VertexOutput {
    vec4 position;
    vec4 additional;
    vec4 color;
    vec4 screenPosition;
    vec4 varyingParam0;
    vec4 varyingParam1;
};

struct FragmentInput {
    vec4 additional;
    vec4 color;
    vec4 screenPosition;
    vec4 varyingParam0;
    vec4 varyingParam1;
};

struct FragmentOutput {
    vec4 Color0;
};

SAMPLER2D_AUTOREG(s_Texture0);
SAMPLER2D_AUTOREG(s_Texture1);
SAMPLER2D_AUTOREG(s_Texture2);
float Mirror(float u) {
    float t = 2.0 * fract(u * 0.5);
    return t < 1.0 ? t : 2.0 - t;
}
void Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    float tVal = 0.0;
    if ((int(mod(float(int(ShaderType.x)), float(((int(0x2)) * 2)))) >= (int(0x2)))) {
        tVal = fragInput.varyingParam0.x;
    } else if ((int(mod(float(int(ShaderType.x)), float(((int(0x4)) * 2)))) >= (int(0x4)))) {
        tVal = length(fragInput.varyingParam0.xy);
    } else if ((int(mod(float(int(ShaderType.x)), float(((int(0x8)) * 2)))) >= (int(0x8)))) {
        tVal = (3.14 + atan(fragInput.varyingParam0.y, fragInput.varyingParam0.x)) / (2.0 * 3.14);
    }
    if ((int(mod(float(int(ShaderType.x)), float(((int(0x100)) * 2)))) >= (int(0x100)))) {
        tVal = fract(tVal);
    } else if ((int(mod(float(int(ShaderType.x)), float(((int(0x200)) * 2)))) >= (int(0x200)))) {
        tVal = Mirror(tVal);
    }
    vec4 colorTemp = vec4(0, 0, 0, 0);
    if ((int(mod(float(int(ShaderType.x)), float(((int(0x10)) * 2)))) >= (int(0x10)))) {
        colorTemp = mix(GradientStartColor, GradientEndColor, clamp(tVal, 0.0, 1.0));
    } else if ((int(mod(float(int(ShaderType.x)), float(((int(0x20)) * 2)))) >= (int(0x20)))) {
        float oneMinus2t = 1.0 - (2.0 * tVal);
        colorTemp = clamp(oneMinus2t, 0.0, 1.0) * GradientStartColor;
        colorTemp += (1.0 - min(abs(oneMinus2t), 1.0)) * GradientMidColor;
        colorTemp += clamp(-oneMinus2t, 0.0, 1.0) * GradientEndColor;
    } else if ((int(mod(float(int(ShaderType.x)), float(((int(0x40)) * 2)))) >= (int(0x40)))) {
        vec2 coord = vec2(tVal, GradientYCoord.x);
        colorTemp = textureSample(s_Texture2, coord);
    } else if ((int(mod(float(int(ShaderType.x)), float(((int(0x1)) * 2)))) >= (int(0x1)))) {
        vec2 uvCoords = (vec2((vec2(fragInput.additional.xy)).x, 1.0 - (vec2(fragInput.additional.xy)).y));
        colorTemp = textureSample(s_Texture0, uvCoords);
    }
    if ((int(mod(float(int(ShaderType.x)), float(((int(0x80)) * 2)))) >= (int(0x80)))) {
        float mask = textureSample(s_Texture1, fragInput.varyingParam1.xy).a;
        colorTemp *= mask;
    }
    fragOutput.Color0 = colorTemp * clamp(fragInput.additional.z, 0.0, 1.0);
}
void main() {
    FragmentInput fragmentInput;
    FragmentOutput fragmentOutput;
    fragmentInput.additional = v_additional;
    fragmentInput.color = v_color;
    fragmentInput.screenPosition = v_screenPosition;
    fragmentInput.varyingParam0 = v_varyingParam0;
    fragmentInput.varyingParam1 = v_varyingParam1;
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

