#version 310 es

/*
* Available Macros:
*
* Passes:
* - SSR_FILL_GAPS_PASS (not used)
* - SSR_GET_REFLECTED_COLOR_PASS (not used)
* - SSR_RAY_MARCH_PASS (not used)
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
* - uniform lowp sampler2D s_InputTexture;
* - uniform lowp sampler2D s_PreviousReflectionBuffer;
* - uniform lowp sampler2D s_RasterColor;
*
* Uniforms:
* - uniform vec4 CameraData;
* - uniform vec4 SSRFadingParamsAndThickness;
* - uniform vec4 SSRRayMarchingParams;
* - uniform vec4 SSRRoughnessCutoffParams;
* - uniform vec4 SSRTemporalAccumulationParams;
* - uniform vec4 ScreenSize;
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
uniform highp usampler2D s_GbufferRoughness;
uniform highp vec4 CameraData;
uniform highp vec4 SSRFadingParamsAndThickness;
uniform highp vec4 SSRRayMarchingParams;
uniform highp vec4 SSRRoughnessCutoffParams;
uniform highp vec4 ScreenSize;
uniform highp vec4 ViewportScale;
in highp vec4 v_projPosition;
in highp vec4 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void func_7a080(inout bool arg_3514b, inout highp vec3 arg_6cf39) {
    if (CameraData.x < CameraData.y)
    {
        arg_3514b = (CameraData.x < arg_6cf39.z) && (arg_6cf39.z < CameraData.y);
        return;
    }
    else
    {
        arg_3514b = (CameraData.x > arg_6cf39.z) && (arg_6cf39.z > CameraData.y);
        return;
    }
}
void func_d31db(inout highp vec3 arg_0a9df, inout highp vec3 arg_b97ab, inout highp vec4 arg_0418b, inout int arg_eb797, inout highp float arg_cf4e3) {
    highp vec3 loc_fe905 = normalize(reflect(normalize(arg_0a9df), arg_b97ab));
    highp vec3 loc_ac142 = arg_0a9df + (arg_b97ab * SSRRayMarchingParams.z);
    highp vec3 loc_999a9 = loc_ac142;
    highp vec3 loc_24d1c = loc_ac142 + loc_fe905;
    highp vec3 loc_4d47b = loc_24d1c;
    bool loc_94df4;
    func_7a080(loc_94df4, loc_4d47b);
    bool loc_49ba4 = !loc_94df4;
    bool loc_24c20;
    if (!loc_49ba4)
    {
        bool loc_7988a;
        func_7a080(loc_7988a, loc_999a9);
        loc_24c20 = !loc_7988a;
    }
    else
    {
        loc_24c20 = loc_49ba4;
    }
    if (loc_24c20)
    {
        arg_0418b = vec4(0.0, 0.0, 0.0, -1.0);
        return;
    }
    highp vec3 loc_c900b = vec3(ViewportScale.xy, 1.0);
    highp vec4 loc_646fe = u_proj * vec4(loc_ac142, 1.0);
    highp vec4 loc_b8928 = loc_646fe;
    highp vec3 loc_ed77f = loc_646fe.xyz / vec3(loc_b8928.w);
    highp vec3 loc_53ba1 = loc_ed77f;
    highp vec2 loc_88050 = (loc_ed77f.xy + vec2(1.0)) * 0.5;
    loc_88050.y = 1.0 - loc_88050.y;
    highp vec3 loc_2583a = vec3(loc_88050.x, 1.0 - loc_88050.y, loc_53ba1.z) * loc_c900b;
    highp vec4 loc_31474 = u_proj * vec4(loc_24d1c, 1.0);
    highp vec4 loc_06cf7 = loc_31474;
    highp vec3 loc_3e8bc = loc_31474.xyz / vec3(loc_06cf7.w);
    highp vec3 loc_ace7f = loc_3e8bc;
    highp vec2 loc_13b66 = (loc_3e8bc.xy + vec2(1.0)) * 0.5;
    loc_13b66.y = 1.0 - loc_13b66.y;
    highp vec3 loc_a37dc = (vec3(loc_13b66.x, 1.0 - loc_13b66.y, loc_ace7f.z) * loc_c900b) - loc_2583a;
    highp vec2 loc_a13b6 = loc_a37dc.xy * ScreenSize.xy;
    highp vec3 loc_58f30 = (loc_a37dc / vec3(max(abs(loc_a13b6.x), abs(loc_a13b6.y)))) * SSRRayMarchingParams.y;
    highp vec3 loc_42855 = loc_58f30;
    highp vec3 loc_12f79 = loc_2583a / loc_58f30;
    highp vec3 loc_6c458 = (vec3(1.0) - loc_2583a) / loc_58f30;
    highp float loc_52170;
    if (loc_42855.x < 0.0)
    {
        loc_52170 = abs(loc_12f79.x);
    }
    else
    {
        loc_52170 = loc_6c458.x;
    }
    highp float loc_1029f;
    if (loc_42855.y < 0.0)
    {
        loc_1029f = abs(loc_12f79.y);
    }
    else
    {
        loc_1029f = loc_6c458.y;
    }
    highp float loc_165e0;
    if (loc_42855.z < 0.0)
    {
        loc_165e0 = abs(loc_12f79.z);
    }
    else
    {
        loc_165e0 = loc_6c458.z;
    }
    highp vec3 loc_a20bd = vec3(loc_52170, loc_1029f, loc_165e0);
    int loc_ca178 = min(int(min(min(loc_a20bd.x, loc_a20bd.y), loc_a20bd.z)), int(SSRRayMarchingParams.x));
    highp vec3 loc_34e0b = vec3(0.0);
    highp vec3 loc_bc119 = loc_2583a;
    highp float loc_e9327 = ((-(((2.0 * CameraData.y) * CameraData.x) / (((loc_bc119.z * (CameraData.y - CameraData.x)) - CameraData.y) - CameraData.x))) - CameraData.x) / (CameraData.y - CameraData.x);
    int loc_83e87;
    highp vec3 loc_477c0;
    loc_477c0 = vec3(0.0);
    loc_83e87 = -1;
    bool loc_dc696;
    int loc_34ff7;
    highp float loc_66d32;
    int loc_acfc4;
    highp vec3 loc_511a5;
    int loc_386b5 = 1;
    bool loc_802b4 = false;
    highp float loc_f7a27 = loc_e9327;
    for (; (loc_386b5 <= loc_ca178) && (!loc_802b4); loc_f7a27 = loc_66d32, loc_477c0 = loc_511a5, loc_83e87 = loc_acfc4, loc_802b4 = loc_dc696, loc_386b5 = loc_34ff7)
    {
        highp vec3 loc_82463 = loc_2583a + (loc_58f30 * float(loc_386b5));
        highp vec3 loc_a160b = loc_82463;
        loc_66d32 = ((-(((2.0 * CameraData.y) * CameraData.x) / (((loc_a160b.z * (CameraData.y - CameraData.x)) - CameraData.y) - CameraData.x))) - CameraData.x) / (CameraData.y - CameraData.x);
        highp float loc_35944 = ((-(((2.0 * CameraData.y) * CameraData.x) / (((((texture(s_GbufferDepth, loc_82463.xy).x * 2.0) - 1.0) * (CameraData.y - CameraData.x)) - CameraData.y) - CameraData.x))) - CameraData.x) / (CameraData.y - CameraData.x);
        loc_dc696 = (loc_35944 <= loc_66d32) && (loc_f7a27 <= (loc_35944 + (SSRFadingParamsAndThickness.w * loc_35944)));
        if (loc_dc696)
        {
            loc_511a5 = loc_82463;
            loc_acfc4 = loc_386b5;
        }
        else
        {
            loc_511a5 = loc_477c0;
            loc_acfc4 = loc_83e87;
        }
        loc_34ff7 = loc_386b5 + 1;
    }
    loc_34e0b = loc_477c0;
    if (loc_83e87 < 1)
    {
        arg_0418b = vec4(0.0, 0.0, 0.0, -1.0);
        return;
    }
    highp float loc_8e3e2 = float(loc_83e87 - 1);
    highp float loc_1f44e = float(loc_83e87);
    highp float loc_39c99;
    highp vec3 loc_6ff03;
    loc_6ff03 = loc_34e0b;
    loc_39c99 = loc_1f44e;
    highp float loc_5ef74;
    highp vec3 loc_16df8;
    highp float loc_31f17;
    highp float loc_8426a;
    int loc_30e69 = 0;
    highp float loc_58449 = loc_8e3e2;
    highp float loc_1fbb4 = loc_1f44e;
    for (; loc_30e69 < arg_eb797; loc_1fbb4 = loc_8426a, loc_58449 = loc_31f17, loc_6ff03 = loc_16df8, loc_39c99 = loc_5ef74, loc_30e69++)
    {
        highp float loc_0341d = (loc_58449 + loc_1fbb4) * 0.5;
        highp vec3 loc_85eb3 = loc_2583a + (loc_58f30 * loc_0341d);
        highp vec3 loc_c1f8f = loc_85eb3;
        if ((((-(((2.0 * CameraData.y) * CameraData.x) / (((loc_c1f8f.z * (CameraData.y - CameraData.x)) - CameraData.y) - CameraData.x))) - CameraData.x) / (CameraData.y - CameraData.x)) > (((-(((2.0 * CameraData.y) * CameraData.x) / (((((texture(s_GbufferDepth, loc_85eb3.xy).x * 2.0) - 1.0) * (CameraData.y - CameraData.x)) - CameraData.y) - CameraData.x))) - CameraData.x) / (CameraData.y - CameraData.x)))
        {
            loc_8426a = loc_0341d;
            loc_31f17 = loc_58449;
            loc_16df8 = loc_85eb3;
            loc_5ef74 = loc_0341d;
        }
        else
        {
            loc_8426a = loc_1fbb4;
            loc_31f17 = loc_0341d;
            loc_16df8 = loc_6ff03;
            loc_5ef74 = loc_39c99;
        }
    }
    loc_34e0b = loc_6ff03;
    highp vec2 loc_919c5 = (loc_6ff03.xy * 2.0) - vec2(1.0);
    loc_919c5.x = pow(abs(loc_919c5.x), SSRFadingParamsAndThickness.x * CameraData.z);
    loc_919c5.y = pow(abs(loc_919c5.y), SSRFadingParamsAndThickness.y);
    highp vec4 loc_e7405 = texture(s_GbufferNormal, loc_6ff03.xy);
    highp vec2 loc_d21e3 = loc_e7405.xy;
    highp vec3 loc_6b26b = vec3(loc_e7405.xy, (1.0 - abs(loc_d21e3.x)) - abs(loc_d21e3.y));
    highp vec2 loc_ba96a;
    if (loc_6b26b.z < 0.0)
    {
        loc_ba96a = (vec2(1.0) - abs(loc_6b26b.yx)) * ((step(vec2(0.0), loc_6b26b.xy) * 2.0) - vec2(1.0));
    }
    else
    {
        loc_ba96a = loc_6b26b.xy;
    }
    highp vec3 loc_2be11 = loc_6b26b;
    loc_6b26b = vec3(loc_ba96a.x, loc_ba96a.y, loc_2be11.z);
    arg_0418b = vec4(loc_34e0b.xy, loc_34e0b.z, min(min(min((1.0 - loc_919c5.x) * (1.0 - loc_919c5.y), 1.0 - smoothstep(SSRFadingParamsAndThickness.z, 1.0, loc_39c99 / float(loc_ca178))), clamp(1.0 - dot(normalize(normalize(vec3(loc_ba96a.x, loc_ba96a.y, loc_2be11.z))), normalize((u_invView * vec4(loc_fe905, 0.0)).xyz)), 0.0, 1.0)), mix(1.0, 0.0, (max(arg_cf4e3, SSRRoughnessCutoffParams.y) - SSRRoughnessCutoffParams.y) / (SSRRoughnessCutoffParams.x - SSRRoughnessCutoffParams.y))));
}
void main() {
    highp vec2 var_d7236 = (floor(v_texcoord0.xy * ScreenSize.xy) + vec2(0.5)) * ScreenSize.zw;
    uvec4 var_6dbc5 = texelFetch(s_GbufferRoughness, ivec2(vec2(textureSize(s_GbufferRoughness, 0)) * var_d7236.xy), 0);
    uint var_4b676 = var_6dbc5.x & 65535u;
    uvec2 var_e21cd = uvec2(var_4b676 >> 8u, var_4b676 & 255u);
    highp vec2 var_92e53 = vec2(float(var_e21cd.x), var_ab8ec) * vec2(0.0039215688593685626983642578125);
    highp float var_e080c = var_92e53.x;
    highp vec4 var_2c222;
    if (var_e080c > SSRRoughnessCutoffParams.x)
    {
        var_2c222 = vec4(0.0, 0.0, 0.0, -1.0);
    }
    else
    {
        int var_935ff = int(SSRRayMarchingParams.w);
        highp vec2 var_fe7f4 = var_d7236.xy;
        highp vec4 var_f1c12 = vec4(v_projPosition.xy, (texture(s_GbufferDepth, var_fe7f4).x * 2.0) - 1.0, 1.0);
        highp mat4 var_66373 = u_invProj;
        highp mat4 var_27f4c = u_invProj;
        highp mat4 var_fb307 = u_invProj;
        highp mat4 var_622c9 = u_invProj;
        highp mat4 var_88001 = u_invProj;
        highp float var_a1967 = var_f1c12.x;
        highp float var_ccc39 = var_f1c12.y;
        highp float var_071ba = var_f1c12.w;
        highp float var_55419 = var_f1c12.z;
        highp float var_10bf4 = var_f1c12.w;
        highp vec4 var_67b7b = vec4(var_a1967 * var_66373[0].x, var_ccc39 * var_27f4c[1].y, var_071ba * var_fb307[3].z, (var_55419 * var_622c9[2].w) + (var_10bf4 * var_88001[3].w));
        var_f1c12 = var_67b7b;
        highp float var_750bb = var_f1c12.w;
        highp vec4 var_f9757 = var_67b7b / vec4(var_750bb);
        var_f1c12 = var_f9757;
        highp vec3 var_87acf = var_f9757.xyz;
        highp vec4 var_5fee2 = texture(s_GbufferNormal, var_fe7f4);
        highp vec2 var_34a65 = var_5fee2.xy;
        highp vec3 var_f857f = vec3(var_5fee2.xy, (1.0 - abs(var_34a65.x)) - abs(var_34a65.y));
        highp vec2 var_a8234;
        if (var_f857f.z < 0.0)
        {
            var_a8234 = (vec2(1.0) - abs(var_f857f.yx)) * ((step(vec2(0.0), var_f857f.xy) * 2.0) - vec2(1.0));
        }
        else
        {
            var_a8234 = var_f857f.xy;
        }
        highp vec3 var_01dc5 = var_f857f;
        var_f857f = vec3(var_a8234.x, var_a8234.y, var_01dc5.z);
        highp vec3 var_05fb6 = normalize((transpose(u_invView) * vec4(normalize(normalize(vec3(var_a8234.x, var_a8234.y, var_01dc5.z))), 0.0)).xyz);
        highp vec4 var_7f57a;
        func_d31db(var_87acf, var_05fb6, var_7f57a, var_935ff, var_e080c);
        var_2c222 = var_7f57a;
    }
    bgfx_FragData0 = var_2c222;
}
