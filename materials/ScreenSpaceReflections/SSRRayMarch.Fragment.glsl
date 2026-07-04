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
* - uniform lowp sampler2D s_RasterColor;
*
* Uniforms:
* - uniform vec4 CameraData;
* - uniform vec4 RenderMode;
* - uniform vec4 SSRFadingParams;
* - uniform vec4 SSRRayMarchingParams;
* - uniform vec4 SSRRoughnessCutoffParams;
* - uniform vec4 ScreenSize;
* - uniform vec4 UnitPlaneExtents;
*/

precision mediump float;
precision highp int;
uniform highp mat4 u_invProj;
uniform highp mat4 u_proj;
uniform highp mat4 u_view;
uniform highp sampler2D s_GbufferDepth;
uniform highp sampler2D s_GbufferNormal;
uniform highp sampler2D s_GbufferRoughness;
uniform highp vec4 CameraData;
uniform highp vec4 SSRFadingParams;
uniform highp vec4 SSRRayMarchingParams;
uniform highp vec4 SSRRoughnessCutoffParams;
uniform highp vec4 ScreenSize;
uniform highp vec4 UnitPlaneExtents;
in highp vec4 v_projPosition;
in highp vec2 v_texcoord0;
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
void func_d2fad(inout highp vec3 arg_8ff75, inout highp vec2 arg_26f8d, inout highp vec3 arg_d2d2d, inout highp vec4 arg_ae71b, inout int arg_eb797, inout highp float arg_b12bb) {
    highp vec3 loc_54878 = reflect(normalize(arg_8ff75), normalize((u_view * vec4(normalize(normalize(vec3(arg_26f8d.x, arg_26f8d.y, arg_d2d2d.z))), 0.0)).xyz));
    highp vec3 loc_ac142 = arg_8ff75 + (loc_54878 * SSRRayMarchingParams.z);
    highp vec3 loc_999a9 = loc_ac142;
    highp vec3 loc_24d1c = loc_ac142 + loc_54878;
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
        arg_ae71b = vec4(0.0, 0.0, 0.0, -1.0);
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
    int loc_e201e = min(int(min(min(loc_a20bd.x, loc_a20bd.y), loc_a20bd.z)), int(SSRRayMarchingParams.x));
    highp vec3 loc_2b544 = vec3(0.0);
    highp vec3 loc_bc119 = loc_feb5c;
    highp float loc_e9327 = ((-(((2.0 * CameraData.y) * CameraData.x) / (((loc_bc119.z * (CameraData.y - CameraData.x)) - CameraData.y) - CameraData.x))) - CameraData.x) / (CameraData.y - CameraData.x);
    highp float loc_339dc;
    int loc_7dcb5;
    highp vec3 loc_3ee51;
    int loc_cadec = 1;
    highp float loc_4f5e1 = loc_e9327;
    for (; loc_cadec <= loc_e201e; loc_4f5e1 = loc_339dc, loc_cadec++)
    {
        highp vec3 loc_3a27d = loc_feb5c + (loc_58f30 * float(loc_cadec));
        highp vec3 loc_a160b = loc_3a27d;
        loc_339dc = ((-(((2.0 * CameraData.y) * CameraData.x) / (((loc_a160b.z * (CameraData.y - CameraData.x)) - CameraData.y) - CameraData.x))) - CameraData.x) / (CameraData.y - CameraData.x);
        highp vec4 loc_d36ff = texture(s_GbufferDepth, loc_3a27d.xy);
        highp float loc_f2cf8 = ((-(((2.0 * CameraData.y) * CameraData.x) / (((((loc_d36ff.x * 2.0) - 1.0) * (CameraData.y - CameraData.x)) - CameraData.y) - CameraData.x))) - CameraData.x) / (CameraData.y - CameraData.x);
        if (loc_339dc > loc_f2cf8)
        {
            if (loc_4f5e1 < loc_f2cf8)
            {
                loc_3ee51 = loc_3a27d;
                loc_7dcb5 = loc_cadec;
                break;
            }
            else
            {
                loc_3ee51 = vec3(0.0);
                loc_7dcb5 = -1;
                break;
            }
        }
    }
    loc_2b544 = loc_3ee51;
    if (loc_7dcb5 < 1)
    {
        arg_ae71b = vec4(0.0, 0.0, 0.0, -1.0);
        return;
    }
    highp float loc_8e3e2 = float(loc_7dcb5 - 1);
    highp float loc_1f44e = float(loc_7dcb5);
    highp float loc_d8fa7;
    highp vec3 loc_1281f;
    loc_1281f = loc_2b544;
    loc_d8fa7 = loc_1f44e;
    highp float loc_5ef74;
    highp vec3 loc_16df8;
    highp float loc_31f17;
    highp float loc_8426a;
    int loc_30e69 = 0;
    highp float loc_58449 = loc_8e3e2;
    highp float loc_1fbb4 = loc_1f44e;
    for (; loc_30e69 < arg_eb797; loc_1fbb4 = loc_8426a, loc_58449 = loc_31f17, loc_1281f = loc_16df8, loc_d8fa7 = loc_5ef74, loc_30e69++)
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
            loc_16df8 = loc_1281f;
            loc_5ef74 = loc_d8fa7;
        }
    }
    loc_2b544 = loc_1281f;
    highp vec2 loc_60203 = (loc_1281f.xy * 2.0) - vec2(1.0);
    loc_60203.x = pow(abs(loc_60203.x), SSRFadingParams.x * CameraData.z);
    loc_60203.y = pow(abs(loc_60203.y), SSRFadingParams.y);
    highp vec2 loc_f4147 = loc_1281f.xy;
    arg_ae71b = vec4(loc_1281f.xy, distance(arg_8ff75, vec4(vec3(((vec2(loc_f4147.x, 1.0 - loc_f4147.y) * 2.0) - vec2(1.0)) * UnitPlaneExtents.xy, -1.0) * mix(CameraData.x, CameraData.y, ((-(((2.0 * CameraData.y) * CameraData.x) / (((loc_2b544.z * (CameraData.y - CameraData.x)) - CameraData.y) - CameraData.x))) - CameraData.x) / (CameraData.y - CameraData.x)), 1.0).xyz), min(min((1.0 - loc_60203.x) * (1.0 - loc_60203.y), 1.0 - smoothstep(SSRFadingParams.z, 1.0, loc_d8fa7 / float(loc_e201e))), mix(1.0, 0.0, (max(arg_b12bb, SSRRoughnessCutoffParams.y) - SSRRoughnessCutoffParams.y) / (SSRRoughnessCutoffParams.x - SSRRoughnessCutoffParams.y))));
}
void main() {
    highp vec4 var_a28fd = texture(s_GbufferRoughness, v_texcoord0);
    highp float var_c0a46 = var_a28fd.w;
    highp vec4 var_53578;
    if (var_c0a46 > SSRRoughnessCutoffParams.x)
    {
        var_53578 = vec4(0.0, 0.0, 0.0, -1.0);
    }
    else
    {
        int var_f1ffd = int(SSRRayMarchingParams.w);
        highp vec4 var_d6b2b = vec4(v_projPosition.xy, (texture(s_GbufferDepth, v_texcoord0).x * 2.0) - 1.0, 1.0);
        highp mat4 var_1356c = u_invProj;
        highp float var_a1967 = var_d6b2b.x;
        highp float var_ccc39 = var_d6b2b.y;
        highp float var_071ba = var_d6b2b.w;
        highp float var_55419 = var_d6b2b.z;
        highp float var_10bf4 = var_d6b2b.w;
        highp vec4 var_67b7b = vec4(var_a1967 * var_1356c[0].x, var_ccc39 * var_1356c[1].y, var_071ba * var_1356c[3].z, (var_55419 * var_1356c[2].w) + (var_10bf4 * var_1356c[3].w));
        var_d6b2b = var_67b7b;
        highp float var_750bb = var_d6b2b.w;
        highp vec4 var_f9757 = var_67b7b / vec4(var_750bb);
        var_d6b2b = var_f9757;
        highp vec3 var_2b1ec = var_f9757.xyz;
        highp vec4 var_2c670 = texture(s_GbufferNormal, v_texcoord0);
        highp vec2 var_34a65 = var_2c670.xy;
        highp vec3 var_f857f = vec3(var_2c670.xy, (1.0 - abs(var_34a65.x)) - abs(var_34a65.y));
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
        func_d2fad(var_2b1ec, var_e3359, var_83f17, var_82fd4, var_f1ffd, var_c0a46);
        var_53578 = var_82fd4;
    }
    bgfx_FragColor = var_53578;
}
