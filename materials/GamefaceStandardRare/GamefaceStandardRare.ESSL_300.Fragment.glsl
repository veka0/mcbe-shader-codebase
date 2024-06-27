#version 300 es

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
uniform vec4 Coefficients[3];
uniform vec4 PixelOffsets[6];
uniform mat4 Transform;
uniform vec4 Viewport;
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
uniform lowp sampler2D s_Texture3;
float GetLuminance(vec3 color) {
    return 0.2126 * color.r + 0.7152 * color.g + 0.0722 * color.b;
}
vec2 computeGradient(in FragmentInput fragInput, in vec2 value, in vec2 stepSize) {
    vec2 dudx = dFdx(value);
    vec2 dudy = dFdy(value);
    vec2 gradient = vec2(2.0 * value.x * dudx.x + 2.0 * value.y * dudx.y, 2.0 * value.x * dudy.x + 2.0 * value.y * dudy.y);
    return gradient;
}
void ShadeGeometry(in FragmentInput fragInput, inout vec4 outColor, inout float alpha) {
    if (int(ShaderType.x) == 1) {
        vec2 posPixels = fragInput.screenPosition.xy;
        float distance2edge = length(posPixels - fragInput.additional.xy) - fragInput.additional.z;
        alpha = clamp(0.5 - distance2edge, 0.0, 1.0);
    } else if (int(ShaderType.x) == 2) {
        vec2 posPixels = fragInput.screenPosition.xy;
        float de = length(posPixels - fragInput.additional.xy);
        float distance2OuterEdge = de - fragInput.additional.z;
        float distance2InnerEdge = de - (fragInput.additional.z - fragInput.additional.w);
        alpha = clamp(0.5 - distance2OuterEdge, 0.0, 1.0);
        alpha *= 1.0 - clamp(0.5 - distance2InnerEdge, 0.0, 1.0);
    } else if (int(ShaderType.x) == 4) {
        vec2 offset = (fragInput.screenPosition.xy - fragInput.additional.xy) / fragInput.additional.zw;
        float test = dot(offset, offset) - 1.0;
        vec2 gradient = computeGradient(fragInput, offset, fragInput.additional.zw);
        float grad_dot = max(dot(gradient, gradient), 1.0e - 4);
        float invlen = inversesqrt(grad_dot);
        alpha = clamp(0.5 - test * invlen, 0.0, 1.0);
    } else if (int(ShaderType.x) == 5) {
        vec2 offset = (fragInput.screenPosition.xy - fragInput.additional.xy) / (fragInput.additional.zw + (PrimProps0.x / 2.0));
        float test = dot(offset, offset) - 1.0;
        vec2 gradient = computeGradient(fragInput, offset, (fragInput.additional.zw + (PrimProps0.x / 2.0)));
        float grad_dot = max(dot(gradient, gradient), 1.0e - 4);
        float invlen = inversesqrt(grad_dot);
        alpha = clamp(0.5 - test * invlen, 0.0, 1.0);
        offset = (fragInput.screenPosition.xy - fragInput.additional.xy) / ((fragInput.additional.zw - (PrimProps0.x / 2.0)));
        test = dot(offset, offset) - 1.0;
        gradient = computeGradient(fragInput, offset, (fragInput.additional.zw - (PrimProps0.x / 2.0)));
        grad_dot = max(dot(gradient, gradient), 1.0e - 4);
        invlen = inversesqrt(grad_dot);
        alpha *= clamp(0.5 + test * invlen, 0.0, 1.0);
    } else if (int(ShaderType.x) == 6) {
        outColor = vec4(0.0, 0.0, 0.0, 0.0);
        int stepsCount = int(PrimProps0.x);
        for(int i = 0; i < stepsCount; ++ i) {
            float coeff = Coefficients[i / 4][int(mod(float(i), 4.0))];
            vec2 offset;
            offset.x = PixelOffsets[(i * 2) / 4][int(mod(float(i * 2), 4.0))];
            offset.y = PixelOffsets[(i * 2 + 1) / 4][int(mod(float(i * 2 + 1), 4.0))];
            vec2 uvPoint = fragInput.additional.xy;
            vec2 uvPointWithOffset = uvPoint + offset;
            vec2 uvPointWithNegativeOffset = uvPoint - offset;
            if (PrimProps1.z != -1.0f || PrimProps1.w != -1.0f)
            {
                uvPointWithOffset = clamp(uvPointWithOffset, PrimProps1.xy, PrimProps1.xy + PrimProps1.zw);
                uvPointWithNegativeOffset = clamp(uvPointWithNegativeOffset, PrimProps1.xy, PrimProps1.xy + PrimProps1.zw);
            }
            uvPointWithOffset = (vec2((uvPointWithOffset).x, 1.0 - (uvPointWithOffset).y));
            uvPointWithNegativeOffset = (vec2((uvPointWithNegativeOffset).x, 1.0 - (uvPointWithNegativeOffset).y));
            outColor += coeff * (textureSample(s_Texture0, uvPointWithOffset) + textureSample(s_Texture0, uvPointWithNegativeOffset));
        }
        alpha = fragInput.color.a;
    } else if (int(ShaderType.x) == 7) {
        vec2 uvPoint = fragInput.additional.xy;
        if (PrimProps1.z != -1.0f || PrimProps1.w != -1.0f) {
            uvPoint.x = clamp(uvPoint.x, PrimProps1.x, PrimProps1.x + PrimProps1.z);
            uvPoint.y = clamp(uvPoint.y, PrimProps1.y, PrimProps1.y + PrimProps1.w);
        }
        uvPoint = (vec2((uvPoint).x, 1.0 - (uvPoint).y));
        vec4 baseColor = textureSample(s_Texture0, uvPoint);
        float nonZeroAlpha = max(baseColor.a, 0.00001);
        baseColor = vec4(baseColor.rgb / nonZeroAlpha, nonZeroAlpha);
        outColor.r = dot(baseColor, Coefficients[0]);
        outColor.g = dot(baseColor, Coefficients[1]);
        outColor.b = dot(baseColor, Coefficients[2]);
        outColor.a = dot(baseColor, PixelOffsets[0]);
        outColor += PixelOffsets[1];
        outColor.a = mix(GetLuminance(outColor.rgb), outColor.a, fragInput.color.b);
        alpha = outColor.a * fragInput.color.a * clamp(fragInput.additional.z, 0.0, 1.0);
        outColor.a = 1.0;
    } else if (int(ShaderType.x) == 9 || int(ShaderType.x) == 12) {
        vec3 YCbCr;
        YCbCr.x = textureSample(s_Texture0, fragInput.additional.xy).r;
        YCbCr.y = textureSample(s_Texture1, fragInput.additional.xy).r;
        YCbCr.z = textureSample(s_Texture2, fragInput.additional.xy).r;
        YCbCr -= vec3(0.0625, 0.5, 0.5);
        mat3 yuv2rgb = mtxFromRows(vec3(1.164, 0, 1.596), vec3(1.164, - 0.391, - 0.813), vec3(1.164, 2.018, 0));
        vec3 rgb = ((yuv2rgb) * (YCbCr));
        alpha = fragInput.color.a * clamp(fragInput.additional.z, 0.0, 1.0);
        outColor = vec4(rgb, 1.0);
        if (int(ShaderType.x) == 12) {
            float a = textureSample(s_Texture3, fragInput.additional.xy).r;
            alpha *= a;
        }
    } else if (int(ShaderType.x) == 11) {
        vec3 posPixels = vec3(fragInput.screenPosition.xy, 1.0);
        float distance2line = abs(dot(fragInput.additional.xyz, posPixels));
        alpha = clamp((1.0 - clamp(distance2line, 0.0, 1.0)) * fragInput.additional.w, 0.0, 1.0);
    } else if (int(ShaderType.x) == 19) {
        float dfValue = textureSample(s_Texture0, fragInput.additional.xy).r;
        float scale = sqrt(PrimProps0.y * 0.5);
        float bias = 0.5 * scale - 0.9;
        float outlineWidth = PrimProps0.z / PrimProps0.y * 0.5 * scale;
        dfValue *= scale;
        vec4 c = mix(PrimProps1, fragInput.color, clamp(dfValue - (bias + outlineWidth), 0.0, 1.0));
        c *= clamp(dfValue - max(0.0, bias - outlineWidth), 0.0, 1.0);
        outColor = c;
    }
}
void Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    float alpha = 1.0;
    vec4 outColor = fragInput.color;
    ShadeGeometry(fragInput, outColor, alpha);
    fragOutput.Color0 = outColor * alpha;
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

