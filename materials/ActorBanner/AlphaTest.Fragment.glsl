#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - DEPTH_ONLY_PASS (not used)
* - DEPTH_ONLY_OPAQUE_PASS (not used)
* - OPAQUE_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* Change_Color:
* - CHANGE_COLOR__MULTI (not used)
* - CHANGE_COLOR__OFF (not used)
*
* Emissive:
* - EMISSIVE__OFF (not used)
*
* Fancy:
* - FANCY__OFF (not used)
* - FANCY__ON (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* MaskedMultitexture:
* - MASKED_MULTITEXTURE__OFF (not used)
* - MASKED_MULTITEXTURE__ON (not used)
*
* Tinting:
* - TINTING__DISABLED
* - TINTING__ENABLED
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MatTexture;
* - uniform lowp sampler2D s_MatTexture1;
*
* Uniforms:
* - uniform vec4 ActorFPEpsilon;
* - uniform vec4 BannerColors[7];
* - uniform vec4 BannerUVOffsetsAndScales[7];
* - uniform vec4 BlockLightColor;
* - uniform mat4 Bones[8];
* - uniform vec4 ChangeColor;
* - uniform vec4 ColorBased;
* - uniform vec4 DitherParams;
* - uniform vec4 DitherParams2[3];
* - uniform vec4 DitheringEnabledToggle;
* - uniform vec4 FogColor;
* - uniform vec4 FogControl;
* - uniform vec4 HudOpacity;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MatColor;
* - uniform vec4 MultiplicativeTintColor;
* - uniform vec4 OverlayColor;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 TileLightColor;
* - uniform vec4 TileLightIntensity;
* - uniform vec4 TintedAlphaTestEnabled;
* - uniform vec4 UVAnimation;
* - uniform vec4 UseAlphaRewrite;
*/

precision mediump float;
precision highp int;
float var_238cd;
uniform highp mat4 u_invView;
uniform highp mat4 u_view;
uniform highp sampler2D s_MatTexture;
uniform highp vec4 ActorFPEpsilon;
uniform highp vec4 DitherParams2[3];
uniform highp vec4 DitherParams;
uniform highp vec4 DitheringEnabledToggle;
uniform highp vec4 HudOpacity;
in highp vec4 v_clipPosition;
#ifdef TINTING__ENABLED
in highp vec4 v_color0;
#endif
in highp vec4 v_fog;
in highp vec4 v_light;
centroid in highp vec4 v_texcoords;
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
#ifdef TINTING__ENABLED
    highp vec4 var_a3564 = v_color0;
    highp vec4 var_13038 = vec4(v_color0.xyz, var_a3564.w);
    highp vec4 var_1b1d9 = var_13038;
#endif
#ifdef TINTING__DISABLED
    highp vec4 var_bf6a8 = texture(s_MatTexture, v_texcoords.zw);
#endif
#ifdef TINTING__ENABLED
    highp vec4 var_45919 = texture(s_MatTexture, v_texcoords.zw);
    highp vec4 var_0ad11 = texture(s_MatTexture, v_texcoords.xy);
    var_45919.w = mix(var_0ad11.x * var_0ad11.w, var_0ad11.w, var_1b1d9.w);
    highp vec4 var_5fdbc = var_45919;
    highp vec3 var_f30a7 = var_5fdbc.xyz * var_13038.xyz;
    highp vec4 var_b626b = vec4(var_f30a7.x, var_f30a7.y, var_f30a7.z, var_5fdbc.w);
    var_45919 = var_b626b;
    highp vec4 var_bf6a8 = var_b626b;
#endif
    bool var_711f5 = var_bf6a8.w < ActorFPEpsilon.x;
    bool var_7df86;
    if (!var_711f5)
    {
        highp vec2 var_4be3d = DitherParams2[0].xy;
        bool var_63892;
        if (DitheringEnabledToggle.x != 0.0)
        {
            highp mat4 var_24edd = u_view;
            highp vec4 var_3267d = v_clipPosition;
            highp vec2 var_f4f10 = floor(((((v_clipPosition.xyz / vec3(var_3267d.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[0].z)) * DitherParams2[0].z;
            highp vec2 var_c55b8 = floor(var_f4f10 * 0.25);
            highp vec2 var_63b62 = floor(var_f4f10 * 0.5);
            highp vec2 var_5fe78 = floor(var_f4f10);
            var_63892 = smoothstep(var_4be3d.x, var_4be3d.y, dot(-normalize(vec4(var_24edd[0].z, var_24edd[1].z, var_24edd[2].z, var_238cd).xyz), v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz)) <= (((((((fract((var_c55b8.x * 0.5) + ((var_c55b8.y * var_c55b8.y) * 0.75)) * 0.25) + fract((var_63b62.x * 0.5) + ((var_63b62.y * var_63b62.y) * 0.75))) * 0.25) + fract((var_5fe78.x * 0.5) + ((var_5fe78.y * var_5fe78.y) * 0.75))) * 64.0) + 0.5) * 0.015625);
        }
        else
        {
            var_63892 = false;
        }
        var_7df86 = var_63892;
    }
    else
    {
        var_7df86 = var_711f5;
    }
    if (var_7df86)
    {
        discard;
    }
    highp vec3 var_7ad1c = var_bf6a8.xyz * v_light.xyz;
    highp vec4 var_a9e80 = vec4(var_7ad1c.x, var_7ad1c.y, var_7ad1c.z, var_bf6a8.w);
    var_a9e80.w *= HudOpacity.x;
    highp vec4 var_6ef7d = var_a9e80;
    highp vec4 var_8544b = v_fog;
    bgfx_FragColor = vec4(mix(vec4(var_a9e80.xyz, var_6ef7d.w).xyz, v_fog.xyz, vec3(var_8544b.w)), var_6ef7d.w);
}
