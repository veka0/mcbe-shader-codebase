#version 310 es

/*
* Available Macros:
*
* Passes:
* - SSR_FILL_GAPS_PASS (not used)
* - SSR_GET_REFLECTED_COLOR_PASS (not used)
* - SSR_RAY_MARCH_PASS (not used)
* - SSR_RAY_MARCH_HZB_PASS (not used)
*
* ExtendedGapFill:
* - EXTENDED_GAP_FILL__OFF (not used)
* - EXTENDED_GAP_FILL__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_GbufferDepth;
* - uniform lowp sampler2D s_GbufferNormal;
* - uniform lowp usampler2D s_GbufferRoughness;
* - uniform lowp sampler2D s_HiZBuffer;
* - uniform lowp sampler2D s_InputTexture;
* - uniform lowp sampler2D s_PreviousReflectionBuffer;
* - uniform lowp sampler2D s_RasterColor;
*
* Uniforms:
* - uniform vec4 CameraData;
* - uniform vec4 HiZMipCount;
* - uniform vec4 HiZViewportDimensionsAndBufferDimensions;
* - uniform vec4 SSRFadingParamsAndThickness;
* - uniform vec4 SSRRayMarchingParams;
* - uniform vec4 SSRRoughnessCutoffParams;
* - uniform vec4 SSRTemporalAccumulationParams;
* - uniform vec4 ScreenSize;
* - uniform vec4 ScreenSpaceRayOffset;
* - uniform vec4 UnitPlaneExtents;
* - uniform vec4 ViewportScale;
*/

precision mediump float;
precision highp int;
float var_ab8ec;
uniform highp mat4 u_invProj;
uniform highp mat4 u_invView;
uniform highp mat4 u_proj;
uniform highp sampler2D s_GbufferDepth;
uniform highp sampler2D s_GbufferNormal;
uniform highp sampler2D s_HiZBuffer;
uniform highp usampler2D s_GbufferRoughness;
uniform highp vec4 CameraData;
uniform highp vec4 HiZMipCount;
uniform highp vec4 HiZViewportDimensionsAndBufferDimensions;
uniform highp vec4 SSRFadingParamsAndThickness;
uniform highp vec4 SSRRayMarchingParams;
uniform highp vec4 SSRRoughnessCutoffParams;
uniform highp vec4 ScreenSize;
uniform highp vec4 ScreenSpaceRayOffset;
in highp vec4 v_projPosition;
in highp vec4 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void func_f7f95(inout highp vec4 arg_e78ee, inout highp vec4 arg_c638b, inout int arg_e18c9, inout highp float arg_838a8) {
    highp vec4 loc_25747 = texture(s_GbufferDepth, arg_e78ee.xy);
    highp float loc_98e59 = (loc_25747.x * 2.0) - 1.0;
    if (loc_98e59 == 1.0)
    {
        arg_c638b = vec4(0.0, 0.0, 0.0, -1.0);
        return;
    }
    highp vec3 loc_9c3f6 = vec3(v_projPosition.xy, loc_98e59);
    highp vec4 loc_df846 = vec4(v_projPosition.xy, loc_98e59, 1.0);
    highp mat4 loc_4fa47 = u_invProj;
    highp mat4 loc_498b7 = u_invProj;
    highp mat4 loc_4882d = u_invProj;
    highp mat4 loc_78c1b = u_invProj;
    highp mat4 loc_40575 = u_invProj;
    highp float loc_eb413 = loc_df846.x;
    highp float loc_ac116 = loc_df846.y;
    highp float loc_f2b7c = loc_df846.w;
    highp float loc_0357c = loc_df846.z;
    highp float loc_2c821 = loc_df846.w;
    highp vec4 loc_9666f = vec4(loc_eb413 * loc_4fa47[0].x, loc_ac116 * loc_498b7[1].y, loc_f2b7c * loc_4882d[3].z, (loc_0357c * loc_78c1b[2].w) + (loc_2c821 * loc_40575[3].w));
    loc_df846 = loc_9666f;
    highp float loc_d799e = loc_df846.w;
    highp vec4 loc_aa8e7 = loc_9666f / vec4(loc_d799e);
    loc_df846 = loc_aa8e7;
    highp vec3 loc_7f17e = loc_aa8e7.xyz;
    highp vec3 loc_4cc58 = loc_7f17e;
    highp vec4 loc_e7405 = texture(s_GbufferNormal, arg_e78ee.xy);
    highp vec2 loc_d21e3 = loc_e7405.xy;
    highp vec3 loc_7ee6e = vec3(loc_e7405.xy, (1.0 - abs(loc_d21e3.x)) - abs(loc_d21e3.y));
    highp vec2 loc_46b19;
    if (loc_7ee6e.z < 0.0)
    {
        loc_46b19 = (vec2(1.0) - abs(loc_7ee6e.yx)) * ((step(vec2(0.0), loc_7ee6e.xy) * 2.0) - vec2(1.0));
    }
    else
    {
        loc_46b19 = loc_7ee6e.xy;
    }
    loc_7ee6e.x = loc_46b19.x;
    loc_7ee6e.y = loc_46b19.y;
    highp vec3 loc_018a8 = normalize(reflect(normalize(loc_7f17e), normalize((transpose(u_invView) * vec4(normalize(normalize(loc_7ee6e)), 0.0)).xyz)));
    highp vec3 loc_03c67 = loc_018a8;
    highp vec3 loc_6c056 = loc_7f17e + (loc_018a8 * 1000.0);
    if (loc_6c056.z > CameraData.x)
    {
        loc_6c056 = loc_7f17e + (loc_018a8 * ((CameraData.x - loc_4cc58.z) / loc_03c67.z));
    }
    highp vec4 loc_646fe = u_proj * vec4(loc_6c056, 1.0);
    highp vec4 loc_b8928 = loc_646fe;
    highp vec3 loc_b2871 = loc_646fe.xyz / vec3(loc_b8928.w);
    highp vec2 loc_2fd59 = vec2(0.5 + (0.5 * loc_9c3f6.x), (0.5 * loc_9c3f6.y) + 0.5);
    highp vec2 loc_9cbe7 = (vec2(0.5 + (0.5 * loc_b2871.x), (0.5 * loc_b2871.y) + 0.5) - loc_2fd59) * HiZViewportDimensionsAndBufferDimensions.xy;
    highp vec2 loc_9de07 = loc_9cbe7;
    highp float loc_34789 = loc_b2871.z - loc_9c3f6.z;
    highp float loc_3da03 = ScreenSpaceRayOffset.x / length(loc_9cbe7);
    highp vec2 loc_ee24b = (loc_2fd59 * HiZViewportDimensionsAndBufferDimensions.xy) + (loc_9cbe7 * loc_3da03);
    highp vec2 loc_5fdf6 = loc_ee24b;
    int loc_95ab6;
    ivec2 loc_4d565;
    int loc_4b637;
    highp float loc_5bb06;
    loc_5bb06 = loc_9c3f6.z + (loc_34789 * loc_3da03);
    loc_4b637 = 0;
    loc_4d565 = ivec2(floor(loc_ee24b));
    loc_95ab6 = 0;
    highp vec2 loc_4c627;
    ivec2 loc_0f04f;
    bool loc_6790c;
    int loc_b0736;
    ivec2 loc_f2779;
    int loc_57e41;
    highp float loc_b5012;
    for (;;)
    {
        if (loc_95ab6 < arg_e18c9)
        {
            highp vec2 loc_a7fd1 = texelFetch(s_HiZBuffer, loc_4d565 >> ivec2(loc_4b637), loc_4b637).xy;
            ivec2 loc_4066a = (loc_4d565 >> ivec2(loc_4b637)) << ivec2(loc_4b637);
            int loc_a253c = 1 << loc_4b637;
            int loc_14df2;
            if (loc_9de07.x > 0.0)
            {
                loc_14df2 = loc_4066a.x + loc_a253c;
            }
            else
            {
                loc_14df2 = loc_4066a.x;
            }
            int loc_6bc48;
            if (loc_9de07.y > 0.0)
            {
                loc_6bc48 = loc_4066a.y + loc_a253c;
            }
            else
            {
                loc_6bc48 = loc_4066a.y;
            }
            int loc_d7248;
            if (loc_9de07.x > 0.0)
            {
                loc_d7248 = loc_4066a.x + loc_a253c;
            }
            else
            {
                loc_d7248 = loc_4066a.x - 1;
            }
            int loc_4686a;
            if (loc_9de07.y > 0.0)
            {
                loc_4686a = loc_4066a.y + loc_a253c;
            }
            else
            {
                loc_4686a = loc_4066a.y - 1;
            }
            highp float loc_b956b = (float(loc_14df2) - loc_5fdf6.x) / loc_9de07.x;
            highp float loc_728e8 = (float(loc_6bc48) - loc_5fdf6.y) / loc_9de07.y;
            highp float loc_616aa;
            if (loc_b956b < loc_728e8)
            {
                loc_4c627 = vec2(float(loc_14df2), loc_5fdf6.y + (loc_b956b * loc_9de07.y));
                loc_0f04f = ivec2(loc_d7248, int(floor(loc_4c627.y)));
                loc_616aa = loc_5bb06 + (loc_b956b * loc_34789);
            }
            else
            {
                loc_4c627 = vec2(loc_5fdf6.x + (loc_728e8 * loc_9de07.x), float(loc_6bc48));
                loc_0f04f = ivec2(int(floor(loc_4c627.x)), loc_4686a);
                loc_616aa = loc_5bb06 + (loc_728e8 * loc_34789);
            }
            if (((loc_95ab6 > 0) && (max(loc_5bb06, loc_616aa) >= (((1.0 - loc_a7fd1.x) * 2.0) - 1.0))) && (min(loc_5bb06, loc_616aa) <= (((1.0 - loc_a7fd1.y) * 2.0) - 1.0)))
            {
                int loc_b9404;
                if (loc_4b637 == 0)
                {
                    loc_6790c = true;
                    break;
                }
                else
                {
                    loc_b9404 = loc_4b637 - 1;
                }
                loc_b5012 = loc_5bb06;
                loc_57e41 = loc_b9404;
                loc_f2779 = loc_4d565;
                loc_b0736 = loc_95ab6;
            }
            else
            {
                bool loc_d3eb0 = loc_0f04f.x < 0;
                bool loc_f2821;
                if (!loc_d3eb0)
                {
                    loc_f2821 = loc_0f04f.y < 0;
                }
                else
                {
                    loc_f2821 = loc_d3eb0;
                }
                bool loc_03dc2;
                if (!loc_f2821)
                {
                    loc_03dc2 = loc_0f04f.x >= int(HiZViewportDimensionsAndBufferDimensions.x);
                }
                else
                {
                    loc_03dc2 = loc_f2821;
                }
                bool loc_1b531;
                if (!loc_03dc2)
                {
                    loc_1b531 = loc_0f04f.y >= int(HiZViewportDimensionsAndBufferDimensions.y);
                }
                else
                {
                    loc_1b531 = loc_03dc2;
                }
                if (loc_1b531)
                {
                    loc_6790c = false;
                    break;
                }
                loc_5fdf6 = loc_4c627;
                int loc_2c583;
                if ((loc_4b637 + 1) < int(HiZMipCount.x))
                {
                    loc_2c583 = loc_4b637 + 1;
                }
                else
                {
                    loc_2c583 = loc_4b637;
                }
                loc_b5012 = loc_616aa;
                loc_57e41 = loc_2c583;
                loc_f2779 = loc_0f04f;
                loc_b0736 = loc_95ab6 + 1;
            }
            loc_5bb06 = loc_b5012;
            loc_4b637 = loc_57e41;
            loc_4d565 = loc_f2779;
            loc_95ab6 = loc_b0736;
            continue;
        }
        else
        {
            loc_6790c = false;
            break;
        }
    }
    if (loc_6790c)
    {
        highp vec2 loc_1ea54 = (vec2(loc_4d565) + vec2(0.5)) / HiZViewportDimensionsAndBufferDimensions.xy;
        highp vec2 loc_a852f = (loc_1ea54 * 2.0) - vec2(1.0);
        loc_a852f.x = pow(abs(loc_a852f.x), SSRFadingParamsAndThickness.x * CameraData.z);
        loc_a852f.y = pow(abs(loc_a852f.y), SSRFadingParamsAndThickness.y);
        highp vec4 loc_5fee2 = texture(s_GbufferNormal, loc_1ea54);
        highp vec2 loc_3daf3 = loc_5fee2.xy;
        highp vec3 loc_18e99 = vec3(loc_5fee2.xy, (1.0 - abs(loc_3daf3.x)) - abs(loc_3daf3.y));
        highp vec2 loc_f4966;
        if (loc_18e99.z < 0.0)
        {
            loc_f4966 = (vec2(1.0) - abs(loc_18e99.yx)) * ((step(vec2(0.0), loc_18e99.xy) * 2.0) - vec2(1.0));
        }
        else
        {
            loc_f4966 = loc_18e99.xy;
        }
        loc_18e99.x = loc_f4966.x;
        loc_18e99.y = loc_f4966.y;
        arg_c638b = vec4(loc_1ea54, loc_5bb06, min(min(min((1.0 - loc_a852f.x) * (1.0 - loc_a852f.y), 1.0 - smoothstep(SSRFadingParamsAndThickness.z, 1.0, float(loc_95ab6) / float(arg_e18c9))), clamp(1.0 - dot(normalize(normalize(loc_18e99)), normalize((u_invView * vec4(loc_018a8, 0.0)).xyz)), 0.0, 1.0)), mix(1.0, 0.0, (max(arg_838a8, SSRRoughnessCutoffParams.y) - SSRRoughnessCutoffParams.y) / (SSRRoughnessCutoffParams.x - SSRRoughnessCutoffParams.y))));
        return;
    }
    else
    {
        arg_c638b = vec4(0.0, 0.0, 0.0, -1.0);
        return;
    }
}
void main() {
    highp vec4 var_fcc9a = v_texcoord0;
    highp vec2 var_9828e = (floor(v_texcoord0.xy * ScreenSize.xy) + vec2(0.5)) * ScreenSize.zw;
    var_fcc9a.x = var_9828e.x;
    var_fcc9a.y = var_9828e.y;
    uvec4 var_6dbc5 = texelFetch(s_GbufferRoughness, ivec2(vec2(textureSize(s_GbufferRoughness, 0)) * var_fcc9a.xy), 0);
    uint var_4b676 = var_6dbc5.x & 65535u;
    uvec2 var_e21cd = uvec2(var_4b676 >> 8u, var_4b676 & 255u);
    highp vec2 var_92e53 = vec2(float(var_e21cd.x), var_ab8ec) * vec2(0.0039215688593685626983642578125);
    highp float var_a42ff = var_92e53.x;
    highp vec4 var_2c222;
    if (var_a42ff > SSRRoughnessCutoffParams.x)
    {
        var_2c222 = vec4(0.0, 0.0, 0.0, -1.0);
    }
    else
    {
        int var_17f47 = int(SSRRayMarchingParams.x);
        highp vec4 var_1384b;
        func_f7f95(var_fcc9a, var_1384b, var_17f47, var_a42ff);
        var_2c222 = var_1384b;
    }
    bgfx_FragData0 = var_2c222;
}
