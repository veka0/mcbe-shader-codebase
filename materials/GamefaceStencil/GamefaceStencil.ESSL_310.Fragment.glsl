#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*/

#if GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif
#define attribute in
#define varying in
out vec4 bgfx_FragColor;
varying vec4 v_additional;
varying vec4 v_color;
varying vec4 v_screenPosition;
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
uniform vec4 u_viewTexel;
uniform mat4 u_invView;
uniform mat4 u_invProj;
uniform mat4 u_viewProj;
uniform mat4 u_invViewProj;
uniform mat4 u_prevViewProj;
uniform mat4 u_model[4];
uniform vec4 PrimProps0;
uniform mat4 u_modelView;
uniform mat4 u_modelViewProj;
uniform vec4 u_prevWorldPosOffset;
uniform vec4 ShaderType;
uniform vec4 PrimProps1;
uniform vec4 u_alphaRef4;
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
};

struct FragmentInput {
    vec4 additional;
    vec4 color;
    vec4 screenPosition;
};

struct FragmentOutput {
    vec4 Color0;
};

uniform lowp sampler2D s_Texture0;
uniform lowp sampler2D s_Texture1;
uniform lowp sampler2D s_Texture2;
float GetLuminance(vec3 color) {
    return 0.2126 * color.r + 0.7152 * color.g + 0.0722 * color.b;
}
void ShadeGeometry(in FragmentInput fragInput, inout vec4 outColor, inout float alpha) {
    if (int(ShaderType.x) == 0) {
        alpha = min(1.0, fragInput.additional.z * fragInput.additional.w);
    } else if (int(ShaderType.x) == 3) {
        vec2 uvPoint = fragInput.additional.xy;
        if (PrimProps1.z != -1.0f || PrimProps1.w != -1.0f)
        {
            uvPoint.x = clamp(fragInput.additional.x, PrimProps1.x, PrimProps1.x + PrimProps1.z);
            uvPoint.y = clamp(fragInput.additional.y, PrimProps1.y, PrimProps1.y + PrimProps1.w);
        }
        outColor = textureSample(s_Texture0, uvPoint);
        outColor.a = mix(1.0 - outColor.a, outColor.a, fragInput.color.r);
    } else if (int(ShaderType.x) == 17) {
        float dfValue = textureSample(s_Texture1, fragInput.additional.xy).r;
        float lum = GetLuminance(fragInput.color.xyz);
        outColor = fragInput.color * pow(abs(dfValue), 1.45 - lum);
    } else if (int(ShaderType.x) == 18) {
        float dfValue = textureSample(s_Texture2, fragInput.additional.xy).r;
        dfValue = (dfValue * 7.96875) - 3.984375;
        dfValue = smoothstep(-0.50196078431 / PrimProps0.x, 0.50196078431 / PrimProps0.x, dfValue);
        float lum = GetLuminance(fragInput.color.xyz);
        outColor = fragInput.color * pow(abs(dfValue), 1.45 - lum);
    }
}
void Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    float alpha = 1.0;
    vec4 outColor = fragInput.color;
    ShadeGeometry(fragInput, outColor, alpha);
    if (int(ShaderType.x) == 3) {
        alpha = outColor.a;
    }
    if (alpha < 0.00390625) {
        discard;
    }
    fragOutput.Color0 = vec4(1.0, 1.0, 1.0, 1.0);
}
void main() {
    FragmentInput fragmentInput;
    FragmentOutput fragmentOutput;
    fragmentInput.additional = v_additional;
    fragmentInput.color = v_color;
    fragmentInput.screenPosition = v_screenPosition;
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

