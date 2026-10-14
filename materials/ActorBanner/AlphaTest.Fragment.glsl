#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - DEPTH_ONLY_ALPHA_TEST_PASS (not used)
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
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
#ifdef TINTING__DISABLED
    highp vec4 var_569e6 = texture(s_MatTexture, v_texcoords.zw);
#endif
#ifdef TINTING__ENABLED
    highp vec4 var_cc5d0 = texture(s_MatTexture, v_texcoords.zw);
    highp vec4 var_e035a = texture(s_MatTexture, v_texcoords.xy);
    var_cc5d0.w = mix(var_e035a.x * var_e035a.w, var_e035a.w, v_color0.w);
    highp vec4 var_e3828 = var_cc5d0;
    highp vec3 var_4a912 = var_e3828.xyz * vec4(v_color0.xyz, v_color0.w).xyz;
    var_cc5d0.x = var_4a912.x;
    var_cc5d0.y = var_4a912.y;
    var_cc5d0.z = var_4a912.z;
    highp vec4 var_569e6 = var_cc5d0;
#endif
    bool var_711f5 = var_569e6.w < ActorFPEpsilon.x;
    bool var_7df86;
    if (!var_711f5)
    {
        highp vec2 var_4be3d = DitherParams2[0].xy;
        bool var_63892;
        if (DitheringEnabledToggle.x != 0.0)
        {
            highp mat4 var_24edd = u_view;
            highp vec2 var_52d56 = floor(((((v_clipPosition.xyz / vec3(v_clipPosition.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[0].z)) * DitherParams2[0].z;
            highp vec2 var_c55b8 = floor(var_52d56 * 0.25);
            highp vec2 var_63b62 = floor(var_52d56 * 0.5);
            highp vec2 var_5fe78 = floor(var_52d56);
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
    highp vec4 var_a244b = var_569e6;
    highp vec3 var_279b1 = var_569e6.xyz * v_light.xyz;
    var_a244b.x = var_279b1.x;
    var_a244b.y = var_279b1.y;
    var_a244b.z = var_279b1.z;
    highp vec4 var_414c0 = var_a244b;
    var_414c0.w *= HudOpacity.x;
    highp vec4 var_1d587 = var_414c0;
    highp vec4 var_4b012 = vec4(var_414c0.xyz, var_1d587.w);
    highp vec4 var_72c1b = var_4b012;
    highp vec3 var_c6e56 = mix(var_4b012.xyz, v_fog.xyz, vec3(v_fog.w));
    var_72c1b.x = var_c6e56.x;
    var_72c1b.y = var_c6e56.y;
    var_72c1b.z = var_c6e56.z;
    bgfx_FragData0 = var_72c1b;
}
