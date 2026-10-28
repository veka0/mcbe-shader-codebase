#version 310 es

/*
* Available Macros:
*
* Passes:
* - COMBINE_PASS (not used)
* - FALLBACK_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - layout(binding = 0, std430) buffer s_DirtyVolumeKeysBuffer { UintEntry s_DirtyVolumeKeys[]; };
* - layout(binding = 1, std430) buffer s_GpuEntryBufferBuffer { GpuVolumeEntry s_GpuEntryBuffer[]; };
* - layout(binding = 2, std430) buffer s_PerGroupLerpsBuffer { FloatEntry s_PerGroupLerps[]; };
* - layout(binding = 3, std430) buffer s_TransitioningGpuEntryBufferBuffer { GpuVolumeEntry s_TransitioningGpuEntryBuffer[]; };
* - layout(binding = 4, std430) buffer s_TransitioningVoxelBufferBuffer { VoxelNode s_TransitioningVoxelBuffer[]; };
* - layout(binding = 5, std430) buffer s_VoxelBufferBuffer { VoxelNode s_VoxelBuffer[]; };
*
* Uniforms:
* - uniform vec4 DirtyVolumeCount;
* - uniform vec4 GpuEntryBufferCapacity;
* - uniform vec4 TransitioningAmbientScalar;
* - uniform vec4 TransitioningGpuEntryBufferCapacity;
* - uniform vec4 TransitioningVolumesLayerCount;
*/

layout(local_size_x = 256, local_size_y = 1, local_size_z = 1) in;
struct GpuVolumeEntry {
    int packed_xy;
    int packed_zw;
    int hash;
    int user_data;
};

struct UintEntry {
    uint data;
};

struct VoxelNode {
    uint data;
};

struct FloatEntry {
    float data;
};

layout(binding = 1, std430) buffer s_GpuEntryBuffer { GpuVolumeEntry GpuEntryBuffer[]; } var_c8427;
layout(binding = 3, std430) buffer s_TransitioningGpuEntryBuffer { GpuVolumeEntry TransitioningGpuEntryBuffer[]; } var_47161;
layout(binding = 0, std430) buffer s_DirtyVolumeKeys { UintEntry DirtyVolumeKeys[]; } var_00f8d;
layout(binding = 5, std430) buffer s_VoxelBuffer { VoxelNode VoxelBuffer[]; } var_cba50;
layout(binding = 4, std430) buffer s_TransitioningVoxelBuffer { VoxelNode TransitioningVoxelBuffer[]; } var_3fedc;
layout(binding = 2, std430) buffer s_PerGroupLerps { FloatEntry PerGroupLerps[]; } var_ed9af;
uniform vec4 DirtyVolumeCount;
uniform vec4 GpuEntryBufferCapacity;
uniform vec4 TransitioningAmbientScalar;
uniform vec4 TransitioningGpuEntryBufferCapacity;
uniform vec4 TransitioningVolumesLayerCount;
shared uint sTransitionOffsetCache[32];
void func_f0f8c(inout uint arg_047d2, inout vec3 arg_aa7d7) {
    if (var_cba50.VoxelBuffer[arg_047d2].data == 0u)
    {
        arg_aa7d7 = vec3(0.0);
        return;
    }
    vec4 loc_951c2 = vec4(uvec4(var_cba50.VoxelBuffer[arg_047d2].data, var_cba50.VoxelBuffer[arg_047d2].data >> 8u, var_cba50.VoxelBuffer[arg_047d2].data >> 16u, var_cba50.VoxelBuffer[arg_047d2].data >> 24u) & uvec4(255u)) * vec4(0.0039215688593685626983642578125);
    vec4 loc_0dc9c = loc_951c2;
    arg_aa7d7 = (loc_951c2.xyz * loc_0dc9c.w) * 6.0;
}
void func_af205(inout uint arg_9a3a5, inout uint arg_cc2dc, inout bool arg_e4a17, inout ivec4 arg_ebd58) {
    if (arg_9a3a5 < 32u)
    {
        arg_cc2dc = sTransitionOffsetCache[arg_9a3a5];
        arg_e4a17 = sTransitionOffsetCache[arg_9a3a5] != 4294967295u;
        return;
    }
    ivec4 loc_3b1b6 = ivec4(arg_ebd58.xyz, int(arg_9a3a5));
    ivec4 loc_18509 = loc_3b1b6;
    int loc_702ca = (loc_18509.x & 65535) | (loc_18509.y << 16);
    int loc_0062b = (loc_18509.z & 65535) | (loc_18509.w << 16);
    ivec4 loc_22622 = loc_3b1b6;
    uint loc_e0ed4 = uint(loc_22622.x) * 1540483477u;
    uint loc_a1c62 = uint(loc_22622.y) * 1540483477u;
    uint loc_46d8c = uint(loc_22622.z) * 1540483477u;
    uint loc_35ca7 = uint(loc_22622.w) * 1540483477u;
    uint loc_4df2f = ((((((2293326976u ^ ((loc_e0ed4 ^ (loc_e0ed4 >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((loc_a1c62 ^ (loc_a1c62 >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((loc_46d8c ^ (loc_46d8c >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((loc_35ca7 ^ (loc_35ca7 >> uint(24))) * 1540483477u);
    uint loc_0053f = (loc_4df2f ^ (loc_4df2f >> uint(13))) * 1540483477u;
    uint loc_df266 = loc_0053f ^ (loc_0053f >> uint(15));
    uint loc_be8b0 = (loc_df266 ^ (loc_df266 >> uint(16))) & 65535u;
    uint loc_28df8 = loc_be8b0 | uint(loc_be8b0 == 0u);
    uint loc_6b949 = uint(TransitioningGpuEntryBufferCapacity.x);
    int loc_51ba1;
    uint loc_ac8fa;
    bool loc_064aa;
    uint loc_23e5d;
    loc_23e5d = 0u;
    loc_064aa = false;
    loc_ac8fa = loc_28df8 & (loc_6b949 - 1u);
    loc_51ba1 = 0;
    bool loc_06f21;
    uint loc_8736f;
    uint loc_5f390;
    uint loc_94970;
    bool loc_1d3fd;
    for (;;)
    {
        if (loc_51ba1 < 8)
        {
            uint loc_cdb85 = uint(var_47161.TransitioningGpuEntryBuffer[loc_ac8fa].hash) & 65535u;
            bool loc_1ceed = loc_cdb85 == loc_28df8;
            bool loc_f4f2f;
            if (loc_1ceed)
            {
                loc_f4f2f = var_47161.TransitioningGpuEntryBuffer[loc_ac8fa].packed_xy == loc_702ca;
            }
            else
            {
                loc_f4f2f = loc_1ceed;
            }
            bool loc_f3d93;
            if (loc_f4f2f)
            {
                loc_f3d93 = var_47161.TransitioningGpuEntryBuffer[loc_ac8fa].packed_zw == loc_0062b;
            }
            else
            {
                loc_f3d93 = loc_f4f2f;
            }
            if (loc_064aa)
            {
                loc_5f390 = loc_23e5d;
            }
            else
            {
                uint loc_d77c3;
                if (loc_f3d93)
                {
                    loc_d77c3 = uint(var_47161.TransitioningGpuEntryBuffer[loc_ac8fa].user_data);
                }
                else
                {
                    loc_d77c3 = loc_23e5d;
                }
                loc_5f390 = loc_d77c3;
            }
            loc_06f21 = loc_064aa || loc_f3d93;
            loc_8736f = (loc_ac8fa + 1u) & (loc_6b949 - 1u);
            if (loc_06f21 || (loc_cdb85 == 0u))
            {
                loc_1d3fd = loc_06f21;
                loc_94970 = loc_5f390;
                break;
            }
            loc_23e5d = loc_5f390;
            loc_064aa = loc_06f21;
            loc_ac8fa = loc_8736f;
            loc_51ba1++;
            continue;
        }
        else
        {
            loc_1d3fd = loc_064aa;
            loc_94970 = loc_23e5d;
            break;
        }
    }
    arg_cc2dc = loc_94970 >> 2u;
    arg_e4a17 = loc_1d3fd;
}
void func_2ac1e(inout uint arg_ab3e5, inout vec3 arg_aa7d7) {
    if (var_3fedc.TransitioningVoxelBuffer[arg_ab3e5].data == 0u)
    {
        arg_aa7d7 = vec3(0.0);
        return;
    }
    vec4 loc_8af8a = vec4(uvec4(var_3fedc.TransitioningVoxelBuffer[arg_ab3e5].data, var_3fedc.TransitioningVoxelBuffer[arg_ab3e5].data >> 8u, var_3fedc.TransitioningVoxelBuffer[arg_ab3e5].data >> 16u, var_3fedc.TransitioningVoxelBuffer[arg_ab3e5].data >> 24u) & uvec4(255u)) * vec4(0.0039215688593685626983642578125);
    vec4 loc_0dc9c = loc_8af8a;
    arg_aa7d7 = (loc_8af8a.xyz * loc_0dc9c.w) * 6.0;
}
void func_8e782() {
    uint loc_6ffe4 = GlobalInvocationID.y;
    uint loc_addfb = GlobalInvocationID.x;
    bool loc_531eb = loc_6ffe4 < uint(DirtyVolumeCount.x);
    ivec4 loc_2ee36;
    if (loc_531eb)
    {
        uint loc_d0a87 = loc_6ffe4 * 4u;
        loc_2ee36 = ivec4(int(var_00f8d.DirtyVolumeKeys[loc_d0a87].data), int(var_00f8d.DirtyVolumeKeys[loc_d0a87 + 1u].data), int(var_00f8d.DirtyVolumeKeys[loc_d0a87 + 2u].data), 0);
    }
    else
    {
        loc_2ee36 = ivec4(0);
    }
    uint loc_53897;
    bool loc_5a4f8;
    bool loc_3cc13;
    uint loc_5b51e;
    bool loc_cf3c5;
    uint loc_21bdd;
    uint loc_4a085;
    if (loc_531eb)
    {
        ivec4 loc_6c45e = ivec4(loc_2ee36.xyz, 0);
        ivec4 loc_bdc37 = loc_6c45e;
        int loc_ab334 = (loc_bdc37.x & 65535) | (loc_bdc37.y << 16);
        int loc_76717 = (loc_bdc37.z & 65535) | (loc_bdc37.w << 16);
        ivec4 loc_4e614 = loc_6c45e;
        uint loc_48d5b = uint(loc_4e614.x) * 1540483477u;
        uint loc_d322d = uint(loc_4e614.y) * 1540483477u;
        uint loc_33724 = uint(loc_4e614.z) * 1540483477u;
        uint loc_05410 = uint(loc_4e614.w) * 1540483477u;
        uint loc_fd4f6 = ((((((2293326976u ^ ((loc_48d5b ^ (loc_48d5b >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((loc_d322d ^ (loc_d322d >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((loc_33724 ^ (loc_33724 >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((loc_05410 ^ (loc_05410 >> uint(24))) * 1540483477u);
        uint loc_2545b = (loc_fd4f6 ^ (loc_fd4f6 >> uint(13))) * 1540483477u;
        uint loc_19f5a = loc_2545b ^ (loc_2545b >> uint(15));
        uint loc_065df = (loc_19f5a ^ (loc_19f5a >> uint(16))) & 65535u;
        uint loc_c4ba2 = loc_065df | uint(loc_065df == 0u);
        uint loc_980a9 = uint(GpuEntryBufferCapacity.x);
        int loc_d6224;
        uint loc_75570;
        bool loc_87a71;
        uint loc_8e0b6;
        loc_8e0b6 = 0u;
        loc_87a71 = false;
        loc_75570 = loc_c4ba2 & (loc_980a9 - 1u);
        loc_d6224 = 0;
        bool loc_4f504;
        uint loc_d350f;
        uint loc_e1ab1;
        uint loc_f6fcc;
        bool loc_8040f;
        for (;;)
        {
            if (loc_d6224 < 8)
            {
                uint loc_a70f2 = uint(var_c8427.GpuEntryBuffer[loc_75570].hash) & 65535u;
                bool loc_734de = loc_a70f2 == loc_c4ba2;
                bool loc_e4213;
                if (loc_734de)
                {
                    loc_e4213 = var_c8427.GpuEntryBuffer[loc_75570].packed_xy == loc_ab334;
                }
                else
                {
                    loc_e4213 = loc_734de;
                }
                bool loc_ec5a7;
                if (loc_e4213)
                {
                    loc_ec5a7 = var_c8427.GpuEntryBuffer[loc_75570].packed_zw == loc_76717;
                }
                else
                {
                    loc_ec5a7 = loc_e4213;
                }
                if (loc_87a71)
                {
                    loc_e1ab1 = loc_8e0b6;
                }
                else
                {
                    uint loc_5ebd4;
                    if (loc_ec5a7)
                    {
                        loc_5ebd4 = uint(var_c8427.GpuEntryBuffer[loc_75570].user_data);
                    }
                    else
                    {
                        loc_5ebd4 = loc_8e0b6;
                    }
                    loc_e1ab1 = loc_5ebd4;
                }
                loc_4f504 = loc_87a71 || loc_ec5a7;
                loc_d350f = (loc_75570 + 1u) & (loc_980a9 - 1u);
                if (loc_4f504 || (loc_a70f2 == 0u))
                {
                    loc_8040f = loc_4f504;
                    loc_f6fcc = loc_e1ab1;
                    break;
                }
                loc_8e0b6 = loc_e1ab1;
                loc_87a71 = loc_4f504;
                loc_75570 = loc_d350f;
                loc_d6224++;
                continue;
            }
            else
            {
                loc_8040f = loc_87a71;
                loc_f6fcc = loc_8e0b6;
                break;
            }
        }
        ivec4 loc_3e3dc = ivec4(loc_2ee36.xyz, 1);
        ivec4 loc_04003 = loc_3e3dc;
        int loc_c1719 = (loc_04003.x & 65535) | (loc_04003.y << 16);
        int loc_dd71d = (loc_04003.z & 65535) | (loc_04003.w << 16);
        ivec4 loc_bfd0f = loc_3e3dc;
        uint loc_0cd1e = uint(loc_bfd0f.x) * 1540483477u;
        uint loc_8761e = uint(loc_bfd0f.y) * 1540483477u;
        uint loc_50019 = uint(loc_bfd0f.z) * 1540483477u;
        uint loc_d75f9 = uint(loc_bfd0f.w) * 1540483477u;
        uint loc_0dfdf = ((((((2293326976u ^ ((loc_0cd1e ^ (loc_0cd1e >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((loc_8761e ^ (loc_8761e >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((loc_50019 ^ (loc_50019 >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((loc_d75f9 ^ (loc_d75f9 >> uint(24))) * 1540483477u);
        uint loc_7f298 = (loc_0dfdf ^ (loc_0dfdf >> uint(13))) * 1540483477u;
        uint loc_98e42 = loc_7f298 ^ (loc_7f298 >> uint(15));
        uint loc_a6111 = (loc_98e42 ^ (loc_98e42 >> uint(16))) & 65535u;
        uint loc_793a7 = loc_a6111 | uint(loc_a6111 == 0u);
        uint loc_83694 = uint(GpuEntryBufferCapacity.x);
        int loc_e0407;
        uint loc_4f652;
        bool loc_756b0;
        uint loc_3b3f7;
        loc_3b3f7 = 0u;
        loc_756b0 = false;
        loc_4f652 = loc_793a7 & (loc_83694 - 1u);
        loc_e0407 = 0;
        bool loc_47863;
        uint loc_4d9ec;
        uint loc_c9324;
        uint loc_d4bbd;
        bool loc_15d4a;
        for (;;)
        {
            if (loc_e0407 < 8)
            {
                uint loc_f074a = uint(var_c8427.GpuEntryBuffer[loc_4f652].hash) & 65535u;
                bool loc_cd5f3 = loc_f074a == loc_793a7;
                bool loc_4425f;
                if (loc_cd5f3)
                {
                    loc_4425f = var_c8427.GpuEntryBuffer[loc_4f652].packed_xy == loc_c1719;
                }
                else
                {
                    loc_4425f = loc_cd5f3;
                }
                bool loc_d5e1b;
                if (loc_4425f)
                {
                    loc_d5e1b = var_c8427.GpuEntryBuffer[loc_4f652].packed_zw == loc_dd71d;
                }
                else
                {
                    loc_d5e1b = loc_4425f;
                }
                if (loc_756b0)
                {
                    loc_c9324 = loc_3b3f7;
                }
                else
                {
                    uint loc_29941;
                    if (loc_d5e1b)
                    {
                        loc_29941 = uint(var_c8427.GpuEntryBuffer[loc_4f652].user_data);
                    }
                    else
                    {
                        loc_29941 = loc_3b3f7;
                    }
                    loc_c9324 = loc_29941;
                }
                loc_47863 = loc_756b0 || loc_d5e1b;
                loc_4d9ec = (loc_4f652 + 1u) & (loc_83694 - 1u);
                if (loc_47863 || (loc_f074a == 0u))
                {
                    loc_15d4a = loc_47863;
                    loc_d4bbd = loc_c9324;
                    break;
                }
                loc_3b3f7 = loc_c9324;
                loc_756b0 = loc_47863;
                loc_4f652 = loc_4d9ec;
                loc_e0407++;
                continue;
            }
            else
            {
                loc_15d4a = loc_756b0;
                loc_d4bbd = loc_3b3f7;
                break;
            }
        }
        ivec4 loc_3eeeb = ivec4(loc_2ee36.xyz, 2);
        ivec4 loc_9d3ac = loc_3eeeb;
        int loc_e9ebb = (loc_9d3ac.x & 65535) | (loc_9d3ac.y << 16);
        int loc_00125 = (loc_9d3ac.z & 65535) | (loc_9d3ac.w << 16);
        ivec4 loc_efe25 = loc_3eeeb;
        uint loc_9ae3f = uint(loc_efe25.x) * 1540483477u;
        uint loc_000b2 = uint(loc_efe25.y) * 1540483477u;
        uint loc_b2246 = uint(loc_efe25.z) * 1540483477u;
        uint loc_6a12e = uint(loc_efe25.w) * 1540483477u;
        uint loc_f11ec = ((((((2293326976u ^ ((loc_9ae3f ^ (loc_9ae3f >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((loc_000b2 ^ (loc_000b2 >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((loc_b2246 ^ (loc_b2246 >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((loc_6a12e ^ (loc_6a12e >> uint(24))) * 1540483477u);
        uint loc_45a46 = (loc_f11ec ^ (loc_f11ec >> uint(13))) * 1540483477u;
        uint loc_9445e = loc_45a46 ^ (loc_45a46 >> uint(15));
        uint loc_afb65 = (loc_9445e ^ (loc_9445e >> uint(16))) & 65535u;
        uint loc_4b7c5 = loc_afb65 | uint(loc_afb65 == 0u);
        uint loc_1bdd1 = uint(GpuEntryBufferCapacity.x);
        int loc_faae1;
        uint loc_ad5ff;
        bool loc_66824;
        uint loc_93709;
        loc_93709 = 0u;
        loc_66824 = false;
        loc_ad5ff = loc_4b7c5 & (loc_1bdd1 - 1u);
        loc_faae1 = 0;
        bool loc_3a09b;
        uint loc_2e330;
        uint loc_68fb9;
        uint loc_11c6b;
        bool loc_66d24;
        for (;;)
        {
            if (loc_faae1 < 8)
            {
                uint loc_90296 = uint(var_c8427.GpuEntryBuffer[loc_ad5ff].hash) & 65535u;
                bool loc_44ed0 = loc_90296 == loc_4b7c5;
                bool loc_63659;
                if (loc_44ed0)
                {
                    loc_63659 = var_c8427.GpuEntryBuffer[loc_ad5ff].packed_xy == loc_e9ebb;
                }
                else
                {
                    loc_63659 = loc_44ed0;
                }
                bool loc_be77e;
                if (loc_63659)
                {
                    loc_be77e = var_c8427.GpuEntryBuffer[loc_ad5ff].packed_zw == loc_00125;
                }
                else
                {
                    loc_be77e = loc_63659;
                }
                if (loc_66824)
                {
                    loc_68fb9 = loc_93709;
                }
                else
                {
                    uint loc_75091;
                    if (loc_be77e)
                    {
                        loc_75091 = uint(var_c8427.GpuEntryBuffer[loc_ad5ff].user_data);
                    }
                    else
                    {
                        loc_75091 = loc_93709;
                    }
                    loc_68fb9 = loc_75091;
                }
                loc_3a09b = loc_66824 || loc_be77e;
                loc_2e330 = (loc_ad5ff + 1u) & (loc_1bdd1 - 1u);
                if (loc_3a09b || (loc_90296 == 0u))
                {
                    loc_66d24 = loc_3a09b;
                    loc_11c6b = loc_68fb9;
                    break;
                }
                loc_93709 = loc_68fb9;
                loc_66824 = loc_3a09b;
                loc_ad5ff = loc_2e330;
                loc_faae1++;
                continue;
            }
            else
            {
                loc_66d24 = loc_66824;
                loc_11c6b = loc_93709;
                break;
            }
        }
        loc_4a085 = loc_11c6b >> 2u;
        loc_21bdd = loc_d4bbd >> 2u;
        loc_cf3c5 = loc_15d4a;
        loc_5b51e = loc_f6fcc >> 2u;
        loc_3cc13 = loc_66d24;
        loc_5a4f8 = loc_8040f;
        loc_53897 = uint(TransitioningVolumesLayerCount.x);
    }
    else
    {
        loc_4a085 = 0u;
        loc_21bdd = 0u;
        loc_cf3c5 = false;
        loc_5b51e = 0u;
        loc_3cc13 = false;
        loc_5a4f8 = false;
        loc_53897 = 0u;
    }
    if (loc_531eb && (gl_LocalInvocationIndex < min(loc_53897, 32u)))
    {
        ivec4 loc_a3915 = ivec4(loc_2ee36.xyz, int(gl_LocalInvocationIndex));
        ivec4 loc_3c064 = loc_a3915;
        int loc_de81d = (loc_3c064.x & 65535) | (loc_3c064.y << 16);
        int loc_e13b3 = (loc_3c064.z & 65535) | (loc_3c064.w << 16);
        ivec4 loc_1fdc3 = loc_a3915;
        uint loc_0986f = uint(loc_1fdc3.x) * 1540483477u;
        uint loc_1ba40 = uint(loc_1fdc3.y) * 1540483477u;
        uint loc_a273f = uint(loc_1fdc3.z) * 1540483477u;
        uint loc_5ce06 = uint(loc_1fdc3.w) * 1540483477u;
        uint loc_a0c1a = ((((((2293326976u ^ ((loc_0986f ^ (loc_0986f >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((loc_1ba40 ^ (loc_1ba40 >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((loc_a273f ^ (loc_a273f >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((loc_5ce06 ^ (loc_5ce06 >> uint(24))) * 1540483477u);
        uint loc_93661 = (loc_a0c1a ^ (loc_a0c1a >> uint(13))) * 1540483477u;
        uint loc_20586 = loc_93661 ^ (loc_93661 >> uint(15));
        uint loc_45352 = (loc_20586 ^ (loc_20586 >> uint(16))) & 65535u;
        uint loc_2fa48 = loc_45352 | uint(loc_45352 == 0u);
        uint loc_808c8 = uint(TransitioningGpuEntryBufferCapacity.x);
        int loc_74f15;
        uint loc_350cc;
        bool loc_54861;
        uint loc_9661e;
        loc_9661e = 0u;
        loc_54861 = false;
        loc_350cc = loc_2fa48 & (loc_808c8 - 1u);
        loc_74f15 = 0;
        bool loc_a5869;
        uint loc_5c38a;
        uint loc_32464;
        uint loc_9a2fa;
        bool loc_439a5;
        for (;;)
        {
            if (loc_74f15 < 8)
            {
                uint loc_0c95b = uint(var_47161.TransitioningGpuEntryBuffer[loc_350cc].hash) & 65535u;
                bool loc_120fa = loc_0c95b == loc_2fa48;
                bool loc_755ce;
                if (loc_120fa)
                {
                    loc_755ce = var_47161.TransitioningGpuEntryBuffer[loc_350cc].packed_xy == loc_de81d;
                }
                else
                {
                    loc_755ce = loc_120fa;
                }
                bool loc_09b56;
                if (loc_755ce)
                {
                    loc_09b56 = var_47161.TransitioningGpuEntryBuffer[loc_350cc].packed_zw == loc_e13b3;
                }
                else
                {
                    loc_09b56 = loc_755ce;
                }
                if (loc_54861)
                {
                    loc_32464 = loc_9661e;
                }
                else
                {
                    uint loc_2e7cb;
                    if (loc_09b56)
                    {
                        loc_2e7cb = uint(var_47161.TransitioningGpuEntryBuffer[loc_350cc].user_data);
                    }
                    else
                    {
                        loc_2e7cb = loc_9661e;
                    }
                    loc_32464 = loc_2e7cb;
                }
                loc_a5869 = loc_54861 || loc_09b56;
                loc_5c38a = (loc_350cc + 1u) & (loc_808c8 - 1u);
                if (loc_a5869 || (loc_0c95b == 0u))
                {
                    loc_439a5 = loc_a5869;
                    loc_9a2fa = loc_32464;
                    break;
                }
                loc_9661e = loc_32464;
                loc_54861 = loc_a5869;
                loc_350cc = loc_5c38a;
                loc_74f15++;
                continue;
            }
            else
            {
                loc_439a5 = loc_54861;
                loc_9a2fa = loc_9661e;
                break;
            }
        }
        sTransitionOffsetCache[gl_LocalInvocationIndex] = loc_439a5 ? (loc_9a2fa >> 2u) : 4294967295u;
    }
    barrier();
    if (((!loc_531eb) || (!loc_5a4f8)) || (!loc_3cc13))
    {
        return;
    }
    uint loc_e5c08 = loc_addfb * 16u;
    uint loc_2272d = min((loc_e5c08 + 16u), 4096u);
    for (uint loc_f7c78 = loc_e5c08; loc_f7c78 < loc_2272d; loc_f7c78++)
    {
        uint loc_f3dbb = loc_5b51e + loc_f7c78;
        vec3 loc_2c21d;
        func_f0f8c(loc_f3dbb, loc_2c21d);
        vec3 loc_13d4b;
        if (loc_cf3c5)
        {
            uint loc_366dc = loc_21bdd + loc_f7c78;
            vec3 loc_7e129;
            func_f0f8c(loc_366dc, loc_7e129);
            loc_13d4b = loc_7e129;
        }
        else
        {
            loc_13d4b = vec3(0.0);
        }
        uint loc_df3fe = loc_53897 / 2u;
        vec3 loc_53b3e;
        loc_53b3e = vec3(0.0);
        vec3 loc_39565;
        for (uint loc_74442 = 0u; loc_74442 < loc_df3fe; loc_53b3e = loc_39565, loc_74442++)
        {
            uint loc_8512f = loc_74442 * 2u;
            uint loc_de454 = (loc_74442 * 2u) + 1u;
            bool loc_309d1;
            uint loc_fdb16;
            func_af205(loc_8512f, loc_fdb16, loc_309d1, loc_2ee36);
            vec3 loc_969e3;
            if (loc_309d1)
            {
                uint loc_fccf6 = loc_fdb16 + loc_f7c78;
                vec3 loc_52a64;
                func_2ac1e(loc_fccf6, loc_52a64);
                loc_969e3 = loc_52a64;
            }
            else
            {
                loc_969e3 = vec3(0.0);
            }
            bool loc_e0f24;
            uint loc_94b5a;
            func_af205(loc_de454, loc_94b5a, loc_e0f24, loc_2ee36);
            vec3 loc_3a882;
            if (loc_e0f24)
            {
                uint loc_f2bf8 = loc_94b5a + loc_f7c78;
                vec3 loc_8c93d;
                func_2ac1e(loc_f2bf8, loc_8c93d);
                loc_3a882 = loc_8c93d;
            }
            else
            {
                loc_3a882 = vec3(0.0);
            }
            loc_39565 = loc_53b3e + mix(loc_969e3, loc_3a882, vec3(var_ed9af.PerGroupLerps[loc_74442].data));
        }
        vec3 loc_c8be4 = ((loc_2c21d * TransitioningAmbientScalar.x) + ((loc_53b3e + loc_13d4b) * (1.0 - TransitioningAmbientScalar.x))) * vec3(0.16666667163372039794921875);
        vec4 loc_48fd3 = vec4(loc_c8be4, 0.0039215688593685626983642578125);
        vec2 loc_cbcc5 = max(loc_48fd3.xy, loc_48fd3.zw);
        float loc_6ad36 = ceil(clamp(max(loc_cbcc5.x, loc_cbcc5.y), 0.0, 1.0) * 255.0) * 0.0039215688593685626983642578125;
        uvec4 loc_8d2c0 = uvec4(clamp(vec4(loc_c8be4 / vec3(loc_6ad36), loc_6ad36), vec4(0.0), vec4(1.0)) * 255.0);
        var_cba50.VoxelBuffer[loc_4a085 + loc_f7c78].data = ((loc_8d2c0.x | (loc_8d2c0.y << 8u)) | (loc_8d2c0.z << 16u)) | (loc_8d2c0.w << 24u);
    }
}
void main() {
    uvec3 GlobalInvocationID = gl_GlobalInvocationID;
    func_8e782();
}
