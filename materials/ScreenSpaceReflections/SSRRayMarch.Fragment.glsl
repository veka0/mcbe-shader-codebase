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
* - uniform lowp sampler2D s_GbufferRoughness;
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
uniform highp mat4 u_invProj;
uniform highp mat4 u_invView;
uniform highp mat4 u_proj;
uniform highp mat4 u_view;
uniform highp sampler2D s_GbufferDepth;
uniform highp sampler2D s_GbufferNormal;
uniform highp sampler2D s_GbufferRoughness;
uniform highp vec4 CameraData;
uniform highp vec4 SSRFadingParamsAndThickness;
uniform highp vec4 SSRRayMarchingParams;
uniform highp vec4 SSRRoughnessCutoffParams;
uniform highp vec4 ScreenSize;
in highp vec4 v_projPosition;
in highp vec4 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
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
void func_21d92(inout highp vec3 arg_4185b, inout highp vec2 arg_0126e, inout highp vec3 arg_8417c, inout highp vec4 arg_0418b, inout int arg_eb797, inout highp float arg_cf4e3) {
    highp vec3 loc_99271 = normalize(reflect(normalize(arg_4185b), normalize((u_view * vec4(normalize(normalize(vec3(arg_0126e.x, arg_0126e.y, arg_8417c.z))), 0.0)).xyz)));
    highp vec3 loc_ac142 = arg_4185b + (loc_99271 * SSRRayMarchingParams.z);
    highp vec3 loc_999a9 = loc_ac142;
    highp vec3 loc_24d1c = loc_ac142 + loc_99271;
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
    highp vec4 loc_646fe = u_proj * vec4(loc_ac142, 1.0);
    highp vec4 loc_b8928 = loc_646fe;
    highp vec3 loc_ed77f = loc_646fe.xyz / vec3(loc_b8928.w);
    highp vec3 loc_f5923 = loc_ed77f;
    highp vec2 loc_189c5 = (loc_ed77f.xy + vec2(1.0)) * 0.5;
    loc_189c5.y = 1.0 - loc_189c5.y;
    highp vec3 loc_feb5c = vec3(loc_189c5.x, 1.0 - loc_189c5.y, loc_f5923.z);
    highp vec4 loc_31474 = u_proj * vec4(loc_24d1c, 1.0);
    highp vec4 loc_06cf7 = loc_31474;
    highp vec3 loc_3e8bc = loc_31474.xyz / vec3(loc_06cf7.w);
    highp vec3 loc_38931 = loc_3e8bc;
    highp vec2 loc_d39f6 = (loc_3e8bc.xy + vec2(1.0)) * 0.5;
    loc_d39f6.y = 1.0 - loc_d39f6.y;
    highp vec3 loc_aa5c0 = vec3(loc_d39f6.x, 1.0 - loc_d39f6.y, loc_38931.z) - loc_feb5c;
    highp vec2 loc_a13b6 = loc_aa5c0.xy * ScreenSize.xy;
    highp vec3 loc_58f30 = (loc_aa5c0 / vec3(max(abs(loc_a13b6.x), abs(loc_a13b6.y)))) * SSRRayMarchingParams.y;
    highp vec3 loc_42855 = loc_58f30;
    highp vec3 loc_12f79 = loc_feb5c / loc_58f30;
    highp vec3 loc_6c458 = (vec3(1.0) - loc_feb5c) / loc_58f30;
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
    int loc_7f413 = min(int(min(min(loc_a20bd.x, loc_a20bd.y), loc_a20bd.z)), int(SSRRayMarchingParams.x));
    highp vec3 loc_34e0b = vec3(0.0);
    highp vec3 loc_bc119 = loc_feb5c;
    highp float loc_e9327 = ((-(((2.0 * CameraData.y) * CameraData.x) / (((loc_bc119.z * (CameraData.y - CameraData.x)) - CameraData.y) - CameraData.x))) - CameraData.x) / (CameraData.y - CameraData.x);
    highp float loc_153a4;
    int loc_7f26d;
    highp vec3 loc_90bb9;
    int loc_55806 = 1;
    highp float loc_f4b0e = loc_e9327;
    for (; loc_55806 <= loc_7f413; loc_f4b0e = loc_153a4, loc_55806++)
    {
        highp vec3 loc_82463 = loc_feb5c + (loc_58f30 * float(loc_55806));
        highp vec3 loc_a160b = loc_82463;
        loc_153a4 = ((-(((2.0 * CameraData.y) * CameraData.x) / (((loc_a160b.z * (CameraData.y - CameraData.x)) - CameraData.y) - CameraData.x))) - CameraData.x) / (CameraData.y - CameraData.x);
        highp float loc_2931a = ((-(((2.0 * CameraData.y) * CameraData.x) / (((((texture(s_GbufferDepth, loc_82463.xy).x * 2.0) - 1.0) * (CameraData.y - CameraData.x)) - CameraData.y) - CameraData.x))) - CameraData.x) / (CameraData.y - CameraData.x);
        if ((loc_2931a <= loc_153a4) && (loc_f4b0e <= (loc_2931a + (SSRFadingParamsAndThickness.w * loc_2931a))))
        {
            loc_90bb9 = loc_82463;
            loc_7f26d = loc_55806;
            break;
        }
    }
    loc_34e0b = loc_90bb9;
    if (loc_7f26d < 1)
    {
        arg_0418b = vec4(0.0, 0.0, 0.0, -1.0);
        return;
    }
    highp float loc_8e3e2 = float(loc_7f26d - 1);
    highp float loc_1f44e = float(loc_7f26d);
    highp float loc_39c99;
    highp vec3 loc_22e67;
    loc_22e67 = loc_34e0b;
    loc_39c99 = loc_1f44e;
    highp float loc_5ef74;
    highp vec3 loc_16df8;
    highp float loc_31f17;
    highp float loc_8426a;
    int loc_30e69 = 0;
    highp float loc_58449 = loc_8e3e2;
    highp float loc_1fbb4 = loc_1f44e;
    for (; loc_30e69 < arg_eb797; loc_1fbb4 = loc_8426a, loc_58449 = loc_31f17, loc_22e67 = loc_16df8, loc_39c99 = loc_5ef74, loc_30e69++)
    {
        highp float loc_0341d = (loc_58449 + loc_1fbb4) * 0.5;
        highp vec3 loc_85eb3 = loc_feb5c + (loc_58f30 * loc_0341d);
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
            loc_16df8 = loc_22e67;
            loc_5ef74 = loc_39c99;
        }
    }
    loc_34e0b = loc_22e67;
    highp vec2 loc_17fb7 = loc_22e67.xy;
    highp vec2 loc_215a9 = (loc_22e67.xy * 2.0) - vec2(1.0);
    loc_215a9.x = pow(abs(loc_17fb7.x), SSRFadingParamsAndThickness.x * CameraData.z);
    loc_215a9.y = pow(abs(loc_17fb7.y), SSRFadingParamsAndThickness.y);
    highp vec4 loc_e7405 = texture(s_GbufferNormal, loc_22e67.xy);
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
    arg_0418b = vec4(loc_34e0b.xy, loc_34e0b.z, min(min(min((1.0 - loc_215a9.x) * (1.0 - loc_215a9.y), 1.0 - smoothstep(SSRFadingParamsAndThickness.z, 1.0, loc_39c99 / float(loc_7f413))), clamp(1.0 - dot(normalize(normalize(vec3(loc_ba96a.x, loc_ba96a.y, loc_2be11.z))), normalize((u_invView * vec4(loc_99271, 0.0)).xyz)), 0.0, 1.0)), mix(1.0, 0.0, (max(arg_cf4e3, SSRRoughnessCutoffParams.y) - SSRRoughnessCutoffParams.y) / (SSRRoughnessCutoffParams.x - SSRRoughnessCutoffParams.y))));
}
void main() {
    highp vec4 var_eb4c0 = texture(s_GbufferRoughness, v_texcoord0.xy);
    highp float var_c0a46 = var_eb4c0.w;
    highp vec4 var_53578;
    if (var_c0a46 > SSRRoughnessCutoffParams.x)
    {
        var_53578 = vec4(0.0, 0.0, 0.0, -1.0);
    }
    else
    {
        int var_f1ffd = int(SSRRayMarchingParams.w);
        highp vec4 var_b7389 = vec4(v_projPosition.xy, (texture(s_GbufferDepth, v_texcoord0.xy).x * 2.0) - 1.0, 1.0);
        highp mat4 var_1356c = u_invProj;
        highp float var_a1967 = var_b7389.x;
        highp float var_ccc39 = var_b7389.y;
        highp float var_071ba = var_b7389.w;
        highp float var_55419 = var_b7389.z;
        highp float var_10bf4 = var_b7389.w;
        highp vec4 var_67b7b = vec4(var_a1967 * var_1356c[0].x, var_ccc39 * var_1356c[1].y, var_071ba * var_1356c[3].z, (var_55419 * var_1356c[2].w) + (var_10bf4 * var_1356c[3].w));
        var_b7389 = var_67b7b;
        highp float var_750bb = var_b7389.w;
        highp vec4 var_f9757 = var_67b7b / vec4(var_750bb);
        var_b7389 = var_f9757;
        highp vec3 var_2b1ec = var_f9757.xyz;
        highp vec4 var_ad0af = texture(s_GbufferNormal, v_texcoord0.xy);
        highp vec2 var_34a65 = var_ad0af.xy;
        highp vec3 var_f857f = vec3(var_ad0af.xy, (1.0 - abs(var_34a65.x)) - abs(var_34a65.y));
        highp vec2 var_e3359;
        if (var_f857f.z < 0.0)
        {
            var_e3359 = (vec2(1.0) - abs(var_f857f.yx)) * ((step(vec2(0.0), var_f857f.xy) * 2.0) - vec2(1.0));
        }
        else
        {
            var_e3359 = var_f857f.xy;
        }
        highp vec3 var_83f17 = var_f857f;
        var_f857f = vec3(var_e3359.x, var_e3359.y, var_83f17.z);
        highp vec4 var_82fd4;
        func_21d92(var_2b1ec, var_e3359, var_83f17, var_82fd4, var_f1ffd, var_c0a46);
        var_53578 = var_82fd4;
    }
    bgfx_FragColor = var_53578;
}
