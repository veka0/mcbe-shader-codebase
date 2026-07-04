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
* - uniform lowp sampler2D s_ShadowTexture;
*
* Uniforms:
* - uniform vec4 Ambient;
* - uniform vec4 LightAmbientColorAndIntensity;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MaterialID;
* - uniform vec4 ShadowFilterSize;
* - uniform vec4 ShadowTexel;
* - uniform mat4 ShadowTransform;
*/

precision mediump float;
precision highp int;
uniform highp mat4 u_view;
uniform highp sampler2D s_MatTexture;
uniform highp vec4 LightWorldSpaceDirection;
in highp vec2 v_texcoord0;
in highp vec3 v_viewSpaceNormal;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    bgfx_FragColor = vec4(vec3(0.20000000298023223876953125) + ((vec3(0.800000011920928955078125) * clamp(dot(v_viewSpaceNormal, -(u_view * vec4(LightWorldSpaceDirection.xyz, 0.0)).xyz), 0.0, 1.0)) * texture(s_MatTexture, v_texcoord0).xyz), 1.0);
}
