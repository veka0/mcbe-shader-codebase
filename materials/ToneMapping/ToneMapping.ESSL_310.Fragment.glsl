#version 310 es

/*
* Available Macros:
*
* Passes:
* - TONEMAP_PASS (not used)
*/

#if GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif
#define attribute in
#define varying in
out vec4 bgfx_FragColor;
varying vec2 v_texcoord0;
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
vec3 vec3_splat(float _x) {
    return vec3(_x, _x, _x);
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
uniform vec4 ExposureCompensation;
uniform mat4 u_prevViewProj;
uniform mat4 u_model[4];
uniform vec4 LuminanceMinMax;
uniform mat4 u_modelView;
uniform mat4 u_modelViewProj;
uniform vec4 u_prevWorldPosOffset;
uniform vec4 u_alphaRef4;
uniform vec4 RenderMode;
uniform vec4 ScreenSize;
uniform vec4 TonemapCorrection;
uniform vec4 TonemapParams0;
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
    vec4 position;
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

uniform lowp sampler2D s_AverageLuminance;
uniform lowp sampler2D s_ColorTexture;
uniform lowp sampler2D s_CustomExposureCompensation;
uniform lowp sampler2D s_LuminanceColorTexture;
uniform lowp sampler2D s_MaxLuminance;
uniform lowp sampler2D s_RasterColor;
uniform lowp sampler2D s_RasterizedColor;
vec3 color_gamma(vec3 clr) {
    float e = 1.0 / 2.2;
    return pow(max(clr, vec3(0.0, 0.0, 0.0)), vec3(e, e, e));
}
vec4 color_gamma(vec4 clr) {
    return vec4(color_gamma(clr.rgb), clr.a);
}
float luminance(vec3 clr) {
    return dot(clr, vec3(0.2126, 0.7152, 0.0722));
}
struct ColorTransform {
    float hue;
    float saturation;
    float luminance;
};

float luminanceToEV100(float luminance) {
    return log2(luminance) + 3.0f;
}
vec3 TonemapReinhard(vec3 rgb, float W) {
    vec3 color = rgb / (1.0 + rgb);
    return color;
}
vec3 TonemapReinhardLuminance(vec3 rgb, float W) {
    float l_old = luminance(rgb);
    float l_new = (l_old * (1.0 + (l_old / W))) / (1.0 + l_old);
    return rgb * (l_new / l_old);
}
vec3 TonemapReinhardJodie(vec3 rgb) {
    float l = luminance(rgb);
    vec3 tc = rgb / (1.0 + rgb);
    return mix(rgb / (1.0 + l), tc, tc);
}
vec3 Uncharted2Tonemap(vec3 x) {
    float A = 0.15;
    float B = 0.50;
    float C = 0.10;
    float D = 0.20;
    float E = 0.02;
    float F = 0.30;
    return ((x * (A * x + C * B) + D * E) / (x * (A * x + B) + D * F)) - E / F;
}
vec3 TonemapUncharted2(vec3 rgb, float W) {
    const float ExposureBias = 2.0;
    vec3 curr = Uncharted2Tonemap(ExposureBias * rgb);
    vec3 whiteScale = 1.0 / Uncharted2Tonemap(vec3_splat(W));
    return curr * whiteScale;
}
vec3 RRTAndODTFit(vec3 v) {
    vec3 a = v * (v + 0.0245786) - 0.000090537;
    vec3 b = v * (0.983729 * v + 0.4329510) + 0.238081;
    return a / b;
}
vec3 ACESFitted(vec3 rgb) {
    const mat3 ACESInputMat = mat3(
        0.59719, 0.35458, 0.04823,
        0.07600, 0.90834, 0.01566,
        0.02840, 0.13383, 0.83777
    );
    const mat3 ACESOutputMat = mat3(
        1.60475, - 0.53108, - 0.07367,
        - 0.10208, 1.10813, - 0.00605,
        - 0.00327, - 0.07276, 1.07602
    );
    rgb = ((ACESInputMat) * (rgb));
    rgb = RRTAndODTFit(rgb);
    rgb = ((ACESOutputMat) * (rgb));
    rgb = clamp(rgb, 0.0, 1.0);
    return rgb;
}
vec3 TonemapACES(vec3 rgb) {
    return ACESFitted(rgb);
}
vec3 TonemapColorCorrection(vec3 rgb, float luminance, float brightness, float contrast, float saturation) {
    rgb = (rgb - 0.5) * contrast + 0.5 + brightness;
    return mix(vec3_splat(luminance), rgb, max(0.0, saturation));
}
vec3 ApplyTonemap(vec3 bloomedHDRi, vec3 sceneHDRi, float averageLuminance, float brightness, float contrast, float saturation, float compensation, float whitePoint, int tonemapper) {
    float exposure = (0.18f / averageLuminance) * compensation;
    bloomedHDRi *= exposure;
    float scaledWhitePoint = exposure * whitePoint;
    float whitePointSquared = scaledWhitePoint * scaledWhitePoint;
    if (tonemapper == 1) {
        bloomedHDRi = TonemapReinhardLuminance(bloomedHDRi, whitePointSquared);
    }
    else if (tonemapper == 2) {
        bloomedHDRi = TonemapReinhardJodie(bloomedHDRi);
    }
    else if (tonemapper == 3) {
        bloomedHDRi = TonemapUncharted2(bloomedHDRi, whitePointSquared);
    }
    else if (tonemapper == 4) {
        bloomedHDRi = TonemapACES(bloomedHDRi);
    }
    else {
        bloomedHDRi = TonemapReinhard(bloomedHDRi, whitePointSquared);
    }
    float finalLuminance = luminance(bloomedHDRi);
    bloomedHDRi = color_gamma(bloomedHDRi);
    return TonemapColorCorrection(bloomedHDRi, finalLuminance, brightness, contrast, saturation);
}
void Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    vec3 bloomedHDRi = textureSample(s_ColorTexture, fragInput.texcoord0.xy).rgb;
    vec3 sceneHDRi = textureSample(s_LuminanceColorTexture, fragInput.texcoord0.xy).rgb;
    vec3 finalColor = bloomedHDRi;
    if (TonemapParams0.y <= 0.5f) {
        finalColor.rgb = color_gamma(bloomedHDRi.rgb);
    }
    else {
        float averageLuminance = clamp(textureSample(s_AverageLuminance, vec2(0.5f, 0.5f)).r, LuminanceMinMax.x, LuminanceMinMax.y);
        float compensation = ExposureCompensation.y;
        int exposureCurveType = int(ExposureCompensation.x);
        if (exposureCurveType > 0 && exposureCurveType < 2) {
            compensation = 1.03f - 2.0f / ((1.0f / log(10.0f)) * log(averageLuminance + 1.0f) + 2.0f);
        }
        else if (exposureCurveType > 1) {
            vec2 uv = vec2(LuminanceMinMax.x == LuminanceMinMax.y ? 0.5f : (luminanceToEV100(averageLuminance) - luminanceToEV100(LuminanceMinMax.x)) / (luminanceToEV100(LuminanceMinMax.y) - luminanceToEV100(LuminanceMinMax.x)), 0.5f);
            compensation = textureSample(s_CustomExposureCompensation, uv).r;
        }
        float whitePoint = textureSample(s_MaxLuminance, vec2(0.5f, 0.5f)).r;
        whitePoint = whitePoint < TonemapCorrection.w ? TonemapCorrection.w : whitePoint;
        finalColor.rgb = ApplyTonemap(
            bloomedHDRi,
            sceneHDRi,
            averageLuminance,
            TonemapCorrection.x,
            TonemapCorrection.y,
            TonemapCorrection.z,
            compensation,
            whitePoint,
            int(TonemapParams0.x)
        );
    }
    finalColor.rgb = clamp(finalColor.rgb, vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0));
    vec4 rasterized = textureSample(s_RasterizedColor, fragInput.texcoord0);
    finalColor.rgb *= 1.0 - rasterized.a;
    finalColor.rgb += rasterized.rgb;
    fragOutput.Color0 = vec4(finalColor.rgb, 1.0);
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
    bgfx_FragColor = fragmentOutput.Color0;
}

