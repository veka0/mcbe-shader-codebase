#version 310 es

/*
* Available Macros:
*
* Passes:
* - FALLBACK_PASS (not used)
* - SAMPLE_CASCADED_SHADOWS_PASS (not used)
*
* ThreadLimit:
* - THREAD_LIMIT__LIMITED_AT128
* - THREAD_LIMIT__LIMITED_AT256
* - THREAD_LIMIT__NATIVE
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2DArray s_CascadedShadowBufferOut;
* - uniform highp sampler2DArray s_PreviousCascadedShadowBuffer;
* - uniform highp sampler2DArray s_ShadowCascades;
*
* Uniforms:
* - uniform vec4 CascadesParameters[8];
* - uniform vec4 CascadesPerSet;
* - uniform mat4 CascadesShadowInvProj[8];
* - uniform mat4 CascadesShadowProj[8];
* - uniform mat4 CloudShadowProj;
* - uniform vec4 CloudShadowsVisible;
* - uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
* - uniform vec4 DirectionalLightSkyLightHeuristicToggles;
* - uniform vec4 DirectionalLightSourceDiffuseColorAndIlluminance;
* - uniform vec4 DirectionalLightSourceShadowDirection;
* - uniform vec4 DirectionalLightSourceWorldSpaceDirection;
* - uniform vec4 DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLightAndGPUBlockLightingEnabled;
* - uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
* - uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
* - uniform vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
* - uniform vec4 JitterOffset;
* - uniform vec4 NdLFloor;
* - uniform mat4 PlayerShadowProj;
* - uniform vec4 PointLightNdLFloor;
* - uniform mat4 PrevInvProj;
* - uniform vec4 QuantizationParameters;
* - uniform vec4 QuantizationPrecisionRoundingParameters;
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
* - uniform vec4 TemporalSettings;
* - uniform vec4 VolumeDimensions;
* - uniform vec4 VolumeNearFar;
* - uniform vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
* - uniform vec4 VolumeShadowSettings;
*/

#ifdef THREAD_LIMIT__LIMITED_AT128
layout(local_size_x = 8, local_size_y = 8, local_size_z = 2) in;
#endif
#ifdef THREAD_LIMIT__LIMITED_AT256
layout(local_size_x = 8, local_size_y = 8, local_size_z = 4) in;
#endif
#ifdef THREAD_LIMIT__NATIVE
layout(local_size_x = 8, local_size_y = 8, local_size_z = 8) in;
#endif
layout(location = 0, binding = 2, r32f) uniform writeonly highp image2DArray s_CascadedShadowBufferOut;
uniform highp sampler2DArray s_PreviousCascadedShadowBuffer;
uniform highp sampler2DArray s_ShadowCascades;
uniform mat4 CascadesShadowProj[8];
uniform mat4 CloudShadowProj;
uniform mat4 PlayerShadowProj;
uniform mat4 PrevInvProj;
uniform mat4 u_invViewProj;
uniform mat4 u_prevViewProj;
uniform mat4 u_proj;
uniform vec4 CascadesParameters[8];
uniform vec4 CascadesPerSet;
uniform vec4 CloudShadowsVisible;
uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
uniform vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
uniform vec4 JitterOffset;
uniform vec4 QuantizationParameters;
uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
uniform vec4 TemporalSettings;
uniform vec4 VolumeDimensions;
uniform vec4 VolumeNearFar;
uniform vec4 VolumeShadowSettings;
uniform vec4 u_prevWorldPosOffset;
void func_a0b5c(inout vec3 arg_9b0e1, inout float arg_7a26d) {
    vec4 loc_12ebe = PlayerShadowProj * vec4(arg_9b0e1, 1.0);
    loc_12ebe.z -= CascadesParameters[0].y;
    loc_12ebe.z = min(loc_12ebe.z, 1.0);
    vec2 loc_0d624 = ((loc_12ebe.xy * 0.5) + vec2(0.5)) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y;
    int loc_64b28;
    if (QuantizationParameters.x != 0.0)
    {
        loc_64b28 = 1;
    }
    else
    {
        loc_64b28 = clamp(int((2.0 * VolumeShadowSettings.x) + 0.5), 1, 9);
    }
    int loc_a4d0e = loc_64b28 / 2;
    vec2 loc_6828b = loc_0d624;
    loc_6828b.y += (1.0 - FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y);
    loc_12ebe.z = (loc_12ebe.z * 0.5) + 0.5;
    loc_0d624 = loc_6828b;
    vec2 loc_9adef = vec2(loc_0d624.x, 1.0 - loc_0d624.y);
    bool loc_2c837 = loc_9adef.x >= 0.0;
    bool loc_d06e3;
    if (loc_2c837)
    {
        loc_d06e3 = loc_9adef.x < FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y;
    }
    else
    {
        loc_d06e3 = loc_2c837;
    }
    bool loc_da85e;
    if (loc_d06e3)
    {
        loc_da85e = loc_9adef.y >= 0.0;
    }
    else
    {
        loc_da85e = loc_d06e3;
    }
    bool loc_e80f2;
    if (loc_da85e)
    {
        loc_e80f2 = loc_9adef.y < FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y;
    }
    else
    {
        loc_e80f2 = loc_da85e;
    }
    if (!loc_e80f2)
    {
        arg_7a26d = 1.0;
        return;
    }
    float loc_304c3 = dot(CascadesPerSet, vec4(1.0)) + 1.0;
    float loc_e55e0;
    loc_e55e0 = 0.0;
    float loc_edd8a;
    for (int loc_e3b31 = 0; loc_e3b31 < loc_64b28; loc_e55e0 = loc_edd8a, loc_e3b31++)
    {
        loc_edd8a = loc_e55e0;
        float loc_5e275;
        for (int loc_d3328 = 0; loc_d3328 < loc_64b28; loc_edd8a = loc_5e275, loc_d3328++)
        {
            vec2 loc_49c98 = loc_0d624 + ((vec2(float(loc_d3328 - loc_a4d0e) + 0.5, float(loc_e3b31 - loc_a4d0e) + 0.5) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.z) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y);
            vec3 loc_747f0 = vec3(loc_49c98.x, loc_49c98.y, loc_304c3);
            if (QuantizationParameters.x != 0.0)
            {
                loc_5e275 = loc_edd8a + float(textureLod(s_ShadowCascades, loc_747f0, 0.0).x >= loc_12ebe.z);
            }
            else
            {
                vec4 loc_8954e = step(vec4(loc_12ebe.z), textureGather(s_ShadowCascades, loc_747f0));
                vec2 loc_db73a = fract((loc_747f0.xy * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                loc_5e275 = loc_edd8a + mix(mix(loc_8954e.w, loc_8954e.z, loc_db73a.x), mix(loc_8954e.x, loc_8954e.y, loc_db73a.x), loc_db73a.y);
            }
        }
    }
    arg_7a26d = loc_e55e0 / float(loc_64b28 * loc_64b28);
}
void func_61e30() {
    int loc_a77cc = int(GlobalInvocationID.x);
    int loc_7b57e = int(GlobalInvocationID.y);
    int loc_3a001 = int(GlobalInvocationID.z);
    if (((loc_a77cc >= int(VolumeDimensions.x)) || (loc_7b57e >= int(VolumeDimensions.y))) || (loc_3a001 >= int(VolumeDimensions.z)))
    {
        return;
    }
    vec3 loc_cfbf6 = ((vec3(float(loc_a77cc), float(loc_7b57e), float(loc_3a001)) + vec3(0.5)) + JitterOffset.xyz) / VolumeDimensions.xyz;
    vec3 loc_777c2 = loc_cfbf6;
    vec2 loc_b796d = VolumeNearFar.xy;
    float loc_fcce6 = (exp(4.0 * loc_777c2.z) - 1.0) * 0.0186573602259159088134765625;
    vec4 loc_fbb16 = u_proj * vec4(0.0, 0.0, -(((1.0 - loc_fcce6) * loc_b796d.x) + (loc_fcce6 * loc_b796d.y)), 1.0);
    vec4 loc_e8a8c = u_invViewProj * vec4((loc_cfbf6.xy * 2.0) - vec2(1.0), loc_fbb16.z / loc_fbb16.w, 1.0);
    vec4 loc_dc33a = loc_e8a8c;
    vec3 loc_65cad = loc_e8a8c.xyz / vec3(loc_dc33a.w);
    float loc_459f6;
    if (int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.x) == 1)
    {
        int loc_40b65 = int(dot(clamp(CascadesPerSet, vec4(0.0), vec4(1.0)), vec4(1.0)));
        float loc_edd0a;
        loc_edd0a = 1.0;
        int loc_6b9d2;
        float loc_531f7;
        for (int loc_018d5 = 0, loc_591f5 = 0; loc_018d5 < loc_40b65; loc_591f5 = loc_6b9d2, loc_edd0a = loc_531f7, loc_018d5++)
        {
            int loc_8c1cb = min((loc_591f5 + int(CascadesPerSet[loc_018d5])), 8);
            loc_531f7 = loc_edd0a;
            loc_6b9d2 = loc_591f5;
            int loc_0249d;
            float loc_17e4b;
            for (; loc_6b9d2 < loc_8c1cb; loc_531f7 = loc_17e4b, loc_6b9d2 = loc_0249d)
            {
                vec4 loc_52ba9 = CascadesShadowProj[loc_6b9d2] * vec4(loc_65cad, 1.0);
                vec3 loc_48014 = abs(loc_52ba9.xyz);
                bool loc_54586 = loc_48014.x <= 1.0;
                bool loc_d55ba;
                if (loc_54586)
                {
                    loc_d55ba = loc_48014.y <= 1.0;
                }
                else
                {
                    loc_d55ba = loc_54586;
                }
                bool loc_18633;
                if (loc_d55ba)
                {
                    loc_18633 = loc_48014.z <= 1.0;
                }
                else
                {
                    loc_18633 = loc_d55ba;
                }
                if (loc_18633)
                {
                    vec4 loc_216b9 = loc_52ba9;
                    int loc_f902c;
                    if (QuantizationParameters.x != 0.0)
                    {
                        loc_f902c = 1;
                    }
                    else
                    {
                        loc_f902c = clamp(int((CascadesParameters[loc_6b9d2].w * VolumeShadowSettings.x) + 0.5), 1, 9);
                    }
                    int loc_35619 = loc_f902c / 2;
                    vec2 loc_66983 = ((loc_52ba9.xy * 0.5) + vec2(0.5)) * CascadesParameters[loc_6b9d2].x;
                    float loc_6cb97 = (loc_216b9.z * 0.5) + 0.5;
                    loc_66983.y += (1.0 - CascadesParameters[loc_6b9d2].x);
                    float loc_23a52;
                    loc_23a52 = 0.0;
                    float loc_02409;
                    for (int loc_60213 = 0; loc_60213 < loc_f902c; loc_23a52 = loc_02409, loc_60213++)
                    {
                        loc_02409 = loc_23a52;
                        float loc_e7504;
                        for (int loc_b0778 = 0; loc_b0778 < loc_f902c; loc_02409 = loc_e7504, loc_b0778++)
                        {
                            vec2 loc_ff11f = loc_66983 + ((vec2(float(loc_b0778 - loc_35619) + 0.5, float(loc_60213 - loc_35619) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadesParameters[loc_6b9d2].x);
                            vec4 loc_3ce11 = textureGather(s_ShadowCascades, vec3(loc_ff11f, float(loc_6b9d2)));
                            vec4 loc_8c59a = loc_3ce11;
                            if (QuantizationParameters.x != 0.0)
                            {
                                loc_e7504 = loc_02409 + float(loc_8c59a.w >= (loc_6cb97 - CascadesParameters[loc_6b9d2].y));
                            }
                            else
                            {
                                vec4 loc_5b947 = step(vec4(loc_6cb97 - CascadesParameters[loc_6b9d2].y), loc_3ce11);
                                vec2 loc_df983 = fract((loc_ff11f * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                                loc_e7504 = loc_02409 + mix(mix(loc_5b947.w, loc_5b947.z, loc_df983.x), mix(loc_5b947.x, loc_5b947.y, loc_df983.x), loc_df983.y);
                            }
                        }
                    }
                    loc_17e4b = min(loc_531f7, loc_23a52 / float(loc_f902c * loc_f902c));
                    loc_0249d = loc_8c1cb;
                }
                else
                {
                    loc_17e4b = loc_531f7;
                    loc_0249d = loc_6b9d2 + 1;
                }
            }
        }
        float loc_13448;
        if (int(FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.x) > 0)
        {
            float loc_66fda;
            func_a0b5c(loc_65cad, loc_66fda);
            loc_13448 = loc_66fda;
        }
        else
        {
            loc_13448 = 1.0;
        }
        bool loc_77735 = int(CloudShadowsVisible.x) > 0;
        bool loc_b7d63;
        if (loc_77735)
        {
            loc_b7d63 = int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.y) > 0;
        }
        else
        {
            loc_b7d63 = loc_77735;
        }
        float loc_43108;
        if (loc_b7d63)
        {
            vec4 loc_2190e = CloudShadowProj * vec4(loc_65cad, 1.0);
            vec4 loc_c5771 = loc_2190e;
            loc_c5771 = loc_2190e / vec4(loc_c5771.w);
            loc_c5771.z -= (CascadesParameters[0].y / loc_c5771.w);
            int loc_1bc55;
            if (QuantizationParameters.x != 0.0)
            {
                loc_1bc55 = 1;
            }
            else
            {
                loc_1bc55 = clamp(int((EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.z * VolumeShadowSettings.x) + 0.5), 1, 9);
            }
            int loc_f7be1 = loc_1bc55 / 2;
            vec2 loc_ada76 = ((loc_c5771.xy * 0.5) + vec2(0.5)) * CascadesParameters[0].x;
            loc_ada76.y += (1.0 - CascadesParameters[0].x);
            loc_c5771.z = (loc_c5771.z * 0.5) + 0.5;
            float loc_fd132 = dot(CascadesPerSet, vec4(1.0));
            float loc_a3de1;
            loc_a3de1 = 0.0;
            float loc_d5586;
            for (int loc_dfba4 = 0; loc_dfba4 < loc_1bc55; loc_a3de1 = loc_d5586, loc_dfba4++)
            {
                loc_d5586 = loc_a3de1;
                float loc_a0cdc;
                for (int loc_2bf38 = 0; loc_2bf38 < loc_1bc55; loc_d5586 = loc_a0cdc, loc_2bf38++)
                {
                    vec3 loc_03539 = vec3(loc_ada76 + ((vec2(float(loc_2bf38 - loc_f7be1) + 0.5, float(loc_dfba4 - loc_f7be1) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadesParameters[0].x), loc_fd132);
                    if (QuantizationParameters.x != 0.0)
                    {
                        loc_a0cdc = loc_d5586 + float(textureLod(s_ShadowCascades, loc_03539, 0.0).x >= loc_c5771.z);
                    }
                    else
                    {
                        vec4 loc_f1dbe = step(vec4(loc_c5771.z), textureGather(s_ShadowCascades, loc_03539));
                        vec2 loc_57774 = fract((loc_03539.xy * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                        loc_a0cdc = loc_d5586 + mix(mix(loc_f1dbe.w, loc_f1dbe.z, loc_57774.x), mix(loc_f1dbe.x, loc_f1dbe.y, loc_57774.x), loc_57774.y);
                    }
                }
            }
            float loc_4fda1 = loc_a3de1 / float(loc_1bc55 * loc_1bc55);
            float loc_138c2;
            if (loc_4fda1 < 1.0)
            {
                loc_138c2 = min(1.0, max(loc_4fda1, 1.0 - EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.w));
            }
            else
            {
                loc_138c2 = 1.0;
            }
            loc_43108 = loc_138c2;
        }
        else
        {
            loc_43108 = 1.0;
        }
        loc_459f6 = mix(min(loc_edd0a, min(loc_13448, loc_43108)), 1.0, smoothstep(max(0.0, ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y - min(ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y * 0.100000001490116119384765625, 8.0)), ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y, -0.0));
    }
    else
    {
        loc_459f6 = 1.0;
    }
    if (TemporalSettings.x != 0.0)
    {
        vec3 loc_dfafd = (vec3(float(loc_a77cc), float(loc_7b57e), float(loc_3a001)) + vec3(0.5)) / VolumeDimensions.xyz;
        vec3 loc_e9300 = loc_dfafd;
        vec2 loc_9d396 = VolumeNearFar.xy;
        float loc_fcd55 = (exp(4.0 * loc_e9300.z) - 1.0) * 0.0186573602259159088134765625;
        vec4 loc_62495 = u_proj * vec4(0.0, 0.0, -(((1.0 - loc_fcd55) * loc_9d396.x) + (loc_fcd55 * loc_9d396.y)), 1.0);
        vec4 loc_d7f13 = u_invViewProj * vec4((loc_dfafd.xy * 2.0) - vec2(1.0), loc_62495.z / loc_62495.w, 1.0);
        vec4 loc_d1c9b = loc_d7f13;
        vec4 loc_bf151 = u_prevViewProj * vec4((loc_d7f13.xyz / vec3(loc_d1c9b.w)) - u_prevWorldPosOffset.xyz, 1.0);
        vec4 loc_d9ce7 = loc_bf151;
        vec3 loc_ec028 = loc_bf151.xyz / vec3(loc_d9ce7.w);
        vec2 loc_1fa2a = VolumeNearFar.xy;
        vec2 loc_eb216 = (loc_ec028.xy + vec2(1.0)) * 0.5;
        vec4 loc_3fd1f = PrevInvProj * vec4(loc_ec028, 1.0);
        float loc_77774 = loc_eb216.x;
        vec3 loc_4a1a9 = vec3(loc_77774, loc_eb216.y, log((53.598148345947265625 * ((((-loc_3fd1f.z) / loc_3fd1f.w) - loc_1fa2a.x) / (loc_1fa2a.y - loc_1fa2a.x))) + 1.0) * 0.25);
        vec3 loc_3ffa7 = VolumeDimensions.xyz * loc_4a1a9;
        ivec3 loc_b3099 = ivec3(VolumeDimensions.xyz);
        vec3 loc_96ba4 = loc_4a1a9;
        float loc_68f82 = (loc_96ba4.z * float(loc_b3099.z)) - 0.5;
        int loc_3e42f = clamp(int(loc_68f82), 0, loc_b3099.z - 2);
        imageStore(s_CascadedShadowBufferOut, ivec3(loc_a77cc, loc_7b57e, loc_3a001), vec4(mix(loc_459f6, mix(textureLod(s_PreviousCascadedShadowBuffer, vec3(loc_77774, loc_eb216.y, float(loc_3e42f)), 0.0), textureLod(s_PreviousCascadedShadowBuffer, vec3(loc_77774, loc_eb216.y, float(loc_3e42f + 1)), 0.0), vec4(clamp(loc_68f82 - float(loc_3e42f), 0.0, 1.0))).x, mix(TemporalSettings.z, 0.0, clamp(length(clamp(loc_3ffa7, vec3(0.0), VolumeDimensions.xyz) - loc_3ffa7) * TemporalSettings.y, 0.0, 1.0))), 0.0, 0.0, 0.0));
    }
    else
    {
        imageStore(s_CascadedShadowBufferOut, ivec3(loc_a77cc, loc_7b57e, loc_3a001), vec4(loc_459f6, 0.0, 0.0, 0.0));
    }
}
void main() {
    uvec3 GlobalInvocationID = gl_GlobalInvocationID;
    func_61e30();
}
