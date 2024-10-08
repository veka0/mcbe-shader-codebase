#version 310 es

/*
* Available Macros:
*
* Passes:
* - COLOR_POST_PROCESS_PASS (not used)
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
vec3 vec3_splat(float _x) {
    return vec3(_x, _x, _x);
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

uniform vec4 u_viewRect;
uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 u_viewTexel;
uniform mat4 u_invView;
uniform vec4 GenericTonemapperContrastAndScaleAndOffsetAndCrosstalk;
uniform mat4 u_invProj;
uniform mat4 u_viewProj;
uniform mat4 u_invViewProj;
uniform vec4 ExposureCompensation;
uniform vec4 ColorGrading_Offset_Highlights;
uniform vec4 ColorGrading_Gamma_Highlights;
uniform mat4 u_prevViewProj;
uniform vec4 ColorGrading_Gamma_PlayerUI;
uniform mat4 u_model[4];
uniform mat4 u_modelView;
uniform mat4 u_modelViewProj;
uniform vec4 u_prevWorldPosOffset;
uniform vec4 u_alphaRef4;
uniform vec4 ColorGrading_Contrast_Highlights;
uniform vec4 ColorGrading_Saturation_Highlights;
uniform vec4 ColorGrading_Contrast_Midtones;
uniform vec4 ColorGrading_Contrast_Shadows;
uniform vec4 ColorGrading_Gain_Highlights;
uniform vec4 ColorGrading_Gain_Midtones;
uniform vec4 ScreenSize;
uniform vec4 ColorGrading_Gain_Shadows;
uniform vec4 ColorGrading_Offset_Shadows;
uniform vec4 ColorGrading_Offset_Midtones;
uniform vec4 ColorGrading_Gamma_Shadows;
uniform vec4 ColorGrading_Gamma_Midtones;
uniform vec4 TonemapParams0;
uniform vec4 ColorGrading_Saturation_Midtones;
uniform vec4 ColorGrading_Saturation_Shadows;
uniform vec4 GenericTonemapperCrosstalkParams;
uniform vec4 LuminanceMinMaxAndWhitePointAndMinWhitePoint;
uniform vec4 OutputTextureMaxValue;
uniform vec4 RasterizedColorEnabled;
uniform vec4 RenderMode;
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
uniform lowp sampler2D s_PreExposureLuminance;
uniform lowp sampler2D s_RasterColor;
uniform lowp sampler2D s_RasterizedColor;
vec3 getGradingVector(vec3 highlightVector, vec3 shadowVector, vec3 midtoneVector, float averageLuminance, float colorLuminance) {
    vec3 outVector = midtoneVector;
    if (ColorGrading_Contrast_Midtones.w > 0.0 && colorLuminance >= averageLuminance * ColorGrading_Saturation_Highlights.w) {
        outVector = highlightVector;
    } else if (ColorGrading_Contrast_Shadows.w > 0.0 && colorLuminance <= averageLuminance * ColorGrading_Saturation_Midtones.w) {
        outVector = shadowVector;
    } else {
        if (colorLuminance < averageLuminance && ColorGrading_Contrast_Shadows.w > 0.0) {
            float mixAmount = (colorLuminance - (averageLuminance * ColorGrading_Saturation_Midtones.w)) / (averageLuminance - (averageLuminance * ColorGrading_Saturation_Midtones.w));
            outVector = mix(shadowVector, midtoneVector, mixAmount);
        } else if (colorLuminance > averageLuminance && ColorGrading_Contrast_Midtones.w > 0.0) {
            float mixAmount = (colorLuminance - averageLuminance) / ((averageLuminance * ColorGrading_Saturation_Highlights.w) - averageLuminance);
            outVector = mix(midtoneVector, highlightVector, mixAmount);
        }
    }
    return outVector;
}
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
vec3 ApplyContrast(vec3 inColor, vec3 contrast, float contrastPivot) {
    vec3 pivotVec = vec3_splat(contrastPivot);
    vec3 colorClamp = max(inColor, vec3(0.0, 0.0, 0.0));
    vec3 outColor = (pivotVec * pow(colorClamp / pivotVec, contrast));
    return clamp(outColor, vec3_splat(0.0f), vec3_splat(OutputTextureMaxValue.x));
}
float CalculateMaxSaturation(float luminance, float channelValue, float currentSaturation) {
    float maxSaturation = currentSaturation;
    if (channelValue < luminance) {
        maxSaturation = 1.f + (channelValue / (luminance - channelValue));
    } else if (channelValue > luminance) {
        maxSaturation = 1.f + ((OutputTextureMaxValue.x - channelValue) / (channelValue - luminance));
    }
    return maxSaturation;
}
vec3 ApplySaturation(vec3 inColor, vec3 saturation) {
    float lumi = luminance(inColor);
    vec3 outColor = inColor;
    vec3 maxSaturation = vec3(
        CalculateMaxSaturation(lumi, inColor.x, saturation.x),
        CalculateMaxSaturation(lumi, inColor.y, saturation.y),
        CalculateMaxSaturation(lumi, inColor.z, saturation.z)
    );
    if (saturation.x > maxSaturation.x) {
        saturation = saturation * (maxSaturation.x / saturation.x);
    }
    if (saturation.y > maxSaturation.y) {
        saturation = saturation * (maxSaturation.y / saturation.y);
    }
    if (saturation.z > maxSaturation.z) {
        saturation = saturation * (maxSaturation.z / saturation.z);
    }
    return mix(vec3_splat(lumi), inColor, saturation);
}
vec3 ApplyGain(vec3 inColor, vec3 gain) {
    return clamp(inColor * gain, vec3_splat(0.0f), vec3_splat(OutputTextureMaxValue.x));
}
vec3 ApplyOffset(vec3 inColor, vec3 offset) {
    return clamp(inColor + offset, vec3_splat(0.0f), vec3_splat(OutputTextureMaxValue.x));
}
vec3 ApplyColorGrading(vec3 inColor, float averageLuminance) {
    vec3 outColor = inColor;
    float finalLuminance = luminance(inColor);
    outColor = ApplyContrast(outColor, getGradingVector(ColorGrading_Contrast_Highlights.xyz, ColorGrading_Contrast_Shadows.xyz, ColorGrading_Contrast_Midtones.xyz, averageLuminance, finalLuminance), ColorGrading_Contrast_Highlights.w * averageLuminance);
    outColor = ApplySaturation(outColor, getGradingVector(ColorGrading_Saturation_Highlights.xyz, ColorGrading_Saturation_Shadows.xyz, ColorGrading_Saturation_Midtones.xyz, averageLuminance, finalLuminance));
    outColor = ApplyGain(outColor, getGradingVector(ColorGrading_Gain_Highlights.xyz, ColorGrading_Gain_Shadows.xyz, ColorGrading_Gain_Midtones.xyz, averageLuminance, finalLuminance));
    outColor = ApplyOffset(outColor, vec3_splat(averageLuminance) * getGradingVector(ColorGrading_Offset_Highlights.xyz, ColorGrading_Offset_Shadows.xyz, ColorGrading_Offset_Midtones.xyz, averageLuminance, finalLuminance));
    return outColor;
}

const int kTonemapperReinhard = 0;
const int kTonemapperReinhardLuma = 1;
const int kTonemapperReinhardLuminance = 2;
const int kTonemapperHable = 3;
const int kTonemapperACES = 4;
const int kTonemapperGeneric = 5;
vec3 TonemapReinhard(vec3 rgb) {
    vec3 color = rgb / (1.0 + rgb);
    return color;
}
vec3 TonemapReinhardLuma(vec3 rgb, float W) {
    return (rgb * (vec3_splat(1.0) + (rgb / vec3_splat(W)))) / (vec3_splat(1.0) + rgb);
}
vec3 TonemapReinhardLuminance(vec3 rgb, float W) {
    float l_old = luminance(rgb);
    float l_new = (l_old * (1.0 + (l_old / W))) / (1.0 + l_old);
    return rgb * (l_new / l_old);
}
vec3 HableTonemap(vec3 x) {
    float A = 0.15;
    float B = 0.50;
    float C = 0.10;
    float D = 0.20;
    float E = 0.02;
    float F = 0.30;
    return ((x * (A * x + C * B) + D * E) / (x * (A * x + B) + D * F)) - E / F;
}
vec3 TonemapHable(vec3 rgb, float W) {
    const float ExposureBias = 2.0;
    vec3 curr = HableTonemap(ExposureBias * rgb);
    vec3 whiteScale = 1.0 / HableTonemap(vec3_splat(W));
    return curr * whiteScale;
}
vec3 RRTAndODTFit(vec3 v) {
    vec3 a = v * (v + 0.0245786) - 0.000090537;
    vec3 b = v * (0.983729 * v + 0.4329510) + 0.238081;
    return a / b;
}
vec3 ACESFitted(vec3 rgb) {
    mat3 ACESInputMat = mtxFromRows(
        vec3(0.59719, 0.35458, 0.04823),
        vec3(0.07600, 0.90834, 0.01566),
        vec3(0.02840, 0.13383, 0.83777)
    );
    mat3 ACESOutputMat = mtxFromRows(
        vec3(1.60475, - 0.53108, - 0.07367),
        vec3(-0.10208, 1.10813, - 0.00605),
        vec3(-0.00327, - 0.07276, 1.07602)
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
vec3 TonemapGeneric(vec3 rgb) {
    float peak = max(rgb.r, max(rgb.g, rgb.b));
    vec3 ratio = rgb / peak;
    peak = pow(peak, GenericTonemapperContrastAndScaleAndOffsetAndCrosstalk.x);
    peak = peak / (GenericTonemapperContrastAndScaleAndOffsetAndCrosstalk.y * peak + GenericTonemapperContrastAndScaleAndOffsetAndCrosstalk.z);
    ratio = mix(ratio, vec3(1.0f, 1.0f, 1.0f), pow(peak, GenericTonemapperContrastAndScaleAndOffsetAndCrosstalk.w));
    return peak * ratio;
}
vec3 ApplyTonemap(vec3 sceneColor, float averageLuminance, float compensation, float whitePoint, int tonemapper) {
    float toneMappedAverageLuminance = 0.18f;
    float exposure = (toneMappedAverageLuminance / averageLuminance) * compensation;
    sceneColor *= exposure;
    float scaledWhitePoint = exposure * whitePoint;
    float whitePointSquared = scaledWhitePoint * scaledWhitePoint;
    if (tonemapper == kTonemapperReinhardLuma) {
        sceneColor = TonemapReinhardLuma(sceneColor, whitePointSquared);
    }
    else if (tonemapper == kTonemapperReinhardLuminance) {
        sceneColor = TonemapReinhardLuminance(sceneColor, whitePointSquared);
    }
    else if (tonemapper == kTonemapperHable) {
        sceneColor = TonemapHable(sceneColor, whitePointSquared);
    }
    else if (tonemapper == kTonemapperACES) {
        sceneColor = TonemapACES(sceneColor);
    }
    else if (tonemapper == kTonemapperGeneric) {
        sceneColor = TonemapGeneric(sceneColor);
    }
    else {
        sceneColor = TonemapReinhard(sceneColor);
    }
    float finalLuminance = luminance(sceneColor);
    vec3 e = vec3_splat(1.0) / (getGradingVector(ColorGrading_Gamma_Highlights.xyz, ColorGrading_Gamma_Shadows.xyz, ColorGrading_Gamma_Midtones.xyz, toneMappedAverageLuminance, finalLuminance) * ColorGrading_Gamma_PlayerUI.x);
    sceneColor = pow(max(sceneColor, vec3_splat(0.0)), e);
    return sceneColor;
}
vec3 UnExposeLighting(vec3 color, float averageLuminance) {
    return color / (0.18f / averageLuminance + 1e - 4);
}
void Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    vec3 sceneColor = textureSample(s_ColorTexture, fragInput.texcoord0.xy).rgb;
    if (TonemapParams0.z > 0.0) {
        float unexposeValue = textureSample(s_PreExposureLuminance, vec2(0.5, 0.5)).r;
        sceneColor.rgb = UnExposeLighting(sceneColor.rgb, unexposeValue);
    }
    vec3 finalColor = sceneColor;
    if (TonemapParams0.y <= 0.5f) {
        finalColor.rgb = color_gamma(sceneColor.rgb);
    }
    else {
        float averageLuminance = clamp(textureSample(s_AverageLuminance, vec2(0.5f, 0.5f)).r, LuminanceMinMaxAndWhitePointAndMinWhitePoint.x, LuminanceMinMaxAndWhitePointAndMinWhitePoint.y);
        float compensation = ExposureCompensation.y;
        int exposureCurveType = int(ExposureCompensation.x);
        if (exposureCurveType > 0 && exposureCurveType < 2) {
            compensation = 1.03f - 2.0f / ((1.0f / log(10.0f)) * log(averageLuminance + 1.0f) + 2.0f);
        }
        else if (exposureCurveType > 1) {
            vec2 uv = vec2(LuminanceMinMaxAndWhitePointAndMinWhitePoint.x == LuminanceMinMaxAndWhitePointAndMinWhitePoint.y ? 0.5f : (luminanceToEV100(averageLuminance) - luminanceToEV100(LuminanceMinMaxAndWhitePointAndMinWhitePoint.x)) / (luminanceToEV100(LuminanceMinMaxAndWhitePointAndMinWhitePoint.y) - luminanceToEV100(LuminanceMinMaxAndWhitePointAndMinWhitePoint.x)), 0.5f);
            compensation = textureSample(s_CustomExposureCompensation, uv).r;
        }
        sceneColor = ApplyColorGrading(
            sceneColor,
            averageLuminance
        );
        float whitePoint = LuminanceMinMaxAndWhitePointAndMinWhitePoint.z;
        whitePoint = whitePoint < LuminanceMinMaxAndWhitePointAndMinWhitePoint.w ? LuminanceMinMaxAndWhitePointAndMinWhitePoint.w : whitePoint;
        finalColor.rgb = ApplyTonemap(
            sceneColor,
            averageLuminance,
            compensation,
            whitePoint,
            int(TonemapParams0.x)
        );
    }
    finalColor.rgb = clamp(finalColor.rgb, vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0));
    if (RasterizedColorEnabled.x > 0.0f) {
        vec4 rasterized = textureSample(s_RasterizedColor, fragInput.texcoord0);
        finalColor.rgb *= 1.0 - rasterized.a;
        finalColor.rgb += rasterized.rgb;
    }
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

