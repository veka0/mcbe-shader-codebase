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
uniform highp vec4 HiZViewportDimensionsAndBufferDimensions;
uniform highp vec4 SSRFadingParamsAndThickness;
uniform highp vec4 SSRRayMarchingParams;
uniform highp vec4 SSRRoughnessCutoffParams;
uniform highp vec4 ScreenSize;
uniform highp vec4 ScreenSpaceRayOffset;
in highp vec4 v_projPosition;
in highp vec4 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void func_ce01b(inout highp vec2 arg_d5b5e, inout highp vec4 arg_4909e, inout int arg_ebc6a, inout highp float arg_15392) {
    highp vec4 loc_a0cea = texture(s_GbufferDepth, arg_d5b5e);
    highp float loc_98e59 = (loc_a0cea.x * 2.0) - 1.0;
    if (loc_98e59 == 1.0)
    {
        arg_4909e = vec4(0.0, 0.0, 0.0, -1.0);
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
    highp vec3 loc_1378b = loc_aa8e7.xyz;
    highp vec3 loc_4cc58 = loc_1378b;
    highp vec4 loc_cabd1 = texture(s_GbufferNormal, arg_d5b5e);
    highp vec2 loc_d21e3 = loc_cabd1.xy;
    highp vec3 loc_6b26b = vec3(loc_cabd1.xy, (1.0 - abs(loc_d21e3.x)) - abs(loc_d21e3.y));
    highp vec2 loc_fd2bf;
    if (loc_6b26b.z < 0.0)
    {
        loc_fd2bf = (vec2(1.0) - abs(loc_6b26b.yx)) * ((step(vec2(0.0), loc_6b26b.xy) * 2.0) - vec2(1.0));
    }
    else
    {
        loc_fd2bf = loc_6b26b.xy;
    }
    highp vec3 loc_eea0e = loc_6b26b;
    loc_6b26b = vec3(loc_fd2bf.x, loc_fd2bf.y, loc_eea0e.z);
    highp vec3 loc_d8c03 = normalize(reflect(normalize(loc_1378b), normalize((transpose(u_invView) * vec4(normalize(normalize(vec3(loc_fd2bf.x, loc_fd2bf.y, loc_eea0e.z))), 0.0)).xyz)));
    highp vec3 loc_03c67 = loc_d8c03;
    highp vec3 loc_6c056 = loc_1378b + (loc_d8c03 * 1000.0);
    if (loc_6c056.z > CameraData.x)
    {
        loc_6c056 = loc_1378b + (loc_d8c03 * ((CameraData.x - loc_4cc58.z) / loc_03c67.z));
    }
    highp vec4 loc_646fe = u_proj * vec4(loc_6c056, 1.0);
    highp vec4 loc_b8928 = loc_646fe;
    highp vec3 loc_b2871 = loc_646fe.xyz / vec3(loc_b8928.w);
    highp vec2 loc_2fd59 = vec2(0.5 + (0.5 * loc_9c3f6.x), (0.5 * loc_9c3f6.y) + 0.5);
    highp vec2 loc_9cbe7 = (vec2(0.5 + (0.5 * loc_b2871.x), (0.5 * loc_b2871.y) + 0.5) - loc_2fd59) * HiZViewportDimensionsAndBufferDimensions.xy;
    highp vec2 loc_87826 = loc_9cbe7;
    highp float loc_34789 = loc_b2871.z - loc_9c3f6.z;
    highp float loc_3da03 = ScreenSpaceRayOffset.x / length(loc_9cbe7);
    highp vec2 loc_72023 = (loc_2fd59 * HiZViewportDimensionsAndBufferDimensions.xy) + (loc_9cbe7 * loc_3da03);
    highp vec2 loc_6ba92 = loc_72023;
    ivec2 loc_327eb = ivec2(floor(loc_72023));
    int loc_fdb69;
    highp float loc_9e752;
    loc_9e752 = loc_9c3f6.z + (loc_34789 * loc_3da03);
    loc_fdb69 = 0;
    int loc_bbba4;
    ivec2 loc_50101;
    highp float loc_36c9f;
    bool loc_a1710;
    for (;;)
    {
        if (loc_fdb69 < arg_ebc6a)
        {
            highp vec2 loc_eb188 = texelFetch(s_HiZBuffer, loc_327eb, 0).xy;
            int loc_58dd3;
            if (loc_87826.x > 0.0)
            {
                loc_58dd3 = loc_327eb.x + 1;
            }
            else
            {
                loc_58dd3 = loc_327eb.x;
            }
            int loc_26f64;
            if (loc_87826.y > 0.0)
            {
                loc_26f64 = loc_327eb.y + 1;
            }
            else
            {
                loc_26f64 = loc_327eb.y;
            }
            int loc_b28dc;
            if (loc_87826.x > 0.0)
            {
                loc_b28dc = loc_327eb.x + 1;
            }
            else
            {
                loc_b28dc = loc_327eb.x - 1;
            }
            int loc_4bf1a;
            if (loc_87826.y > 0.0)
            {
                loc_4bf1a = loc_327eb.y + 1;
            }
            else
            {
                loc_4bf1a = loc_327eb.y - 1;
            }
            highp float loc_90154 = loc_6ba92.x;
            highp float loc_fea5e = (float(loc_58dd3) - loc_90154) / loc_87826.x;
            highp float loc_d127e = loc_6ba92.y;
            highp float loc_e1ff0 = (float(loc_26f64) - loc_d127e) / loc_87826.y;
            if (loc_fea5e < loc_e1ff0)
            {
                loc_6ba92.x = float(loc_58dd3);
                loc_6ba92.y += (loc_fea5e * loc_87826.y);
                loc_50101 = ivec2(loc_b28dc, loc_327eb.y);
                loc_36c9f = loc_9e752 + (loc_fea5e * loc_34789);
            }
            else
            {
                loc_6ba92.y = float(loc_26f64);
                loc_6ba92.x += (loc_e1ff0 * loc_87826.x);
                loc_50101 = ivec2(loc_327eb.x, loc_4bf1a);
                loc_36c9f = loc_9e752 + (loc_e1ff0 * loc_34789);
            }
            if ((max(loc_9e752, loc_36c9f) > (1.0 - loc_eb188.x)) && (min(loc_9e752, loc_36c9f) < (1.0 - loc_eb188.y)))
            {
                loc_a1710 = true;
                break;
            }
            bool loc_899fe = loc_50101.x < 0;
            bool loc_8ff40;
            if (!loc_899fe)
            {
                loc_8ff40 = loc_50101.y < 0;
            }
            else
            {
                loc_8ff40 = loc_899fe;
            }
            bool loc_4551e;
            if (!loc_8ff40)
            {
                loc_4551e = loc_50101.x >= int(HiZViewportDimensionsAndBufferDimensions.x);
            }
            else
            {
                loc_4551e = loc_8ff40;
            }
            bool loc_517d4;
            if (!loc_4551e)
            {
                loc_517d4 = loc_50101.y >= int(HiZViewportDimensionsAndBufferDimensions.y);
            }
            else
            {
                loc_517d4 = loc_4551e;
            }
            if (loc_517d4)
            {
                loc_a1710 = false;
                break;
            }
            loc_327eb = loc_50101;
            loc_bbba4 = loc_fdb69 + 1;
            loc_9e752 = loc_36c9f;
            loc_fdb69 = loc_bbba4;
            continue;
        }
        else
        {
            loc_a1710 = false;
            break;
        }
    }
    if (loc_a1710)
    {
        highp vec2 loc_cfd63 = (vec2(loc_327eb) + vec2(0.5)) / HiZViewportDimensionsAndBufferDimensions.xy;
        highp vec2 loc_a3f03 = (loc_cfd63 * 2.0) - vec2(1.0);
        loc_a3f03.x = pow(abs(loc_a3f03.x), SSRFadingParamsAndThickness.x * CameraData.z);
        loc_a3f03.y = pow(abs(loc_a3f03.y), SSRFadingParamsAndThickness.y);
        highp vec4 loc_5fee2 = texture(s_GbufferNormal, loc_cfd63);
        highp vec2 loc_3daf3 = loc_5fee2.xy;
        highp vec3 loc_ce69c = vec3(loc_5fee2.xy, (1.0 - abs(loc_3daf3.x)) - abs(loc_3daf3.y));
        highp vec2 loc_699bf;
        if (loc_ce69c.z < 0.0)
        {
            loc_699bf = (vec2(1.0) - abs(loc_ce69c.yx)) * ((step(vec2(0.0), loc_ce69c.xy) * 2.0) - vec2(1.0));
        }
        else
        {
            loc_699bf = loc_ce69c.xy;
        }
        highp vec3 loc_b40c3 = loc_ce69c;
        loc_ce69c = vec3(loc_699bf.x, loc_699bf.y, loc_b40c3.z);
        arg_4909e = vec4(loc_cfd63, loc_9e752, min(min(min((1.0 - loc_a3f03.x) * (1.0 - loc_a3f03.y), 1.0 - smoothstep(SSRFadingParamsAndThickness.z, 1.0, float(loc_fdb69) / float(arg_ebc6a))), clamp(1.0 - dot(normalize(normalize(vec3(loc_699bf.x, loc_699bf.y, loc_b40c3.z))), normalize((u_invView * vec4(loc_d8c03, 0.0)).xyz)), 0.0, 1.0)), mix(1.0, 0.0, (max(arg_15392, SSRRoughnessCutoffParams.y) - SSRRoughnessCutoffParams.y) / (SSRRoughnessCutoffParams.x - SSRRoughnessCutoffParams.y))));
        return;
    }
    else
    {
        arg_4909e = vec4(0.0, 0.0, 0.0, -1.0);
        return;
    }
}
void main() {
    highp vec2 var_d7236 = (floor(v_texcoord0.xy * ScreenSize.xy) + vec2(0.5)) * ScreenSize.zw;
    uvec4 var_6dbc5 = texelFetch(s_GbufferRoughness, ivec2(vec2(textureSize(s_GbufferRoughness, 0)) * var_d7236.xy), 0);
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
        highp vec2 var_0d1be = var_d7236.xy;
        highp vec4 var_1384b;
        func_ce01b(var_0d1be, var_1384b, var_17f47, var_a42ff);
        var_2c222 = var_1384b;
    }
    bgfx_FragData0 = var_2c222;
}
