#version 310 es

/*
* Available Macros:
*
* Passes:
* - CUSTOM_PASS_BASED_ON_OPAQUE_PASS (not used)
* - DEPTH_ONLY_PASS (not used)
* - OPAQUE_PASS (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MatTexture;
*
* Uniforms:
* - uniform vec4 Ambient;
* - uniform vec4 LightAmbientColorAndIntensity;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MaterialID;
*/

precision mediump float;
precision highp int;
uniform highp mat4 u_view;
uniform highp sampler2D s_MatTexture;
uniform highp vec4 LightAmbientColorAndIntensity;
uniform highp vec4 LightDiffuseColorAndIlluminance;
uniform highp vec4 LightWorldSpaceDirection;
in highp vec2 v_texcoord0;
in highp vec3 v_viewSpaceNormal;
in highp vec4 v_viewSpacePosition;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec3 var_15e80 = LightDiffuseColorAndIlluminance.xyz * LightDiffuseColorAndIlluminance.w;
    highp vec3 var_50265 = normalize(v_viewSpaceNormal);
    highp vec3 var_587f9 = normalize(-(u_view * vec4(LightWorldSpaceDirection.xyz, 0.0)).xyz);
    bgfx_FragColor = vec4(texture(s_MatTexture, v_texcoord0).xyz * (((LightAmbientColorAndIntensity.xyz * LightAmbientColorAndIntensity.w) + (var_15e80 * clamp(dot(var_50265, var_587f9), 0.0, 1.0))) + (var_15e80 * clamp(0.17050254344940185546875 * pow(clamp(dot(var_50265, normalize(var_587f9 + normalize(-v_viewSpacePosition.xyz))), 0.0, 1.0), 0.4554755687713623046875), 0.0, 1.0))), 1.0);
}
