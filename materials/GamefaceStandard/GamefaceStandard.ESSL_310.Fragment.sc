/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*/

$input v_additional, v_color, v_screenPosition
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

uniform vec4 PrimProps0;
uniform vec4 ShaderType;
uniform vec4 PrimProps1;
uniform vec4 TextureSize1;
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
    vec3 screenPosition;
};

struct FragmentInput {
    vec4 additional;
    vec4 color;
    vec3 screenPosition;
};

struct FragmentOutput {
    vec4 Color0;
};

SAMPLER2D_AUTOREG(s_Texture0);
SAMPLER2D_AUTOREG(s_Texture1);
SAMPLER2D_AUTOREG(s_Texture2);
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
            uvPoint = clamp(uvPoint, PrimProps1.xy, PrimProps1.xy + PrimProps1.zw);
        }
        uvPoint = (vec2((uvPoint).x, 1.0 - (uvPoint).y));
        outColor = textureSample(s_Texture0, uvPoint);
        outColor.a = mix(1.0 - outColor.a, outColor.a, fragInput.color.r);
        outColor.a = mix(GetLuminance(outColor.rgb), outColor.a, fragInput.color.b);
        alpha = fragInput.color.a * clamp(fragInput.additional.z, 0.0, 1.0);
    } else if (int(ShaderType.x) == 17) {
        vec2 uvPos = vec2(fragInput.additional.x, fragInput.additional.y);
        vec2 texCoords = vec2(uvPos.x * TextureSize1.x, uvPos.y * TextureSize1.y);
        vec2 centeredTexCoords = floor(texCoords) + vec2(0.5, 0.5);
        vec2 centeredUvPos = vec2(centeredTexCoords.x / TextureSize1.x, centeredTexCoords.y / TextureSize1.y);
        float dfValue = textureSample(s_Texture1, centeredUvPos).r;
        float lum = GetLuminance(fragInput.color.xyz);
        outColor = fragInput.color * pow(abs(dfValue), 1.45 - lum);
    } else if (int(ShaderType.x) == 18) {
        vec2 uvPos = vec2(fragInput.additional.x, fragInput.additional.y);
        float dfValue = textureSample(s_Texture2, uvPos).r;
        dfValue = (dfValue * 7.96875) - 3.984375;
        dfValue = smoothstep(-0.50196078431 / fragInput.additional.z, 0.50196078431 / fragInput.additional.z, dfValue);
        float lum = GetLuminance(fragInput.color.xyz);
        outColor = fragInput.color * pow(dfValue, 1.45 - lum);
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
    gl_FragColor = fragmentOutput.Color0;
}

