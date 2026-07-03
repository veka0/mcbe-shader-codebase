#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_PASS (not used)
* - OPAQUE_PASS (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* Available Resources:
*
* Uniforms:
* - uniform vec4 Ambient;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MatColor;
* - uniform vec4 MaterialID;
*/

precision mediump float;
precision highp int;
uniform highp mat4 u_view;
uniform highp vec4 LightWorldSpaceDirection;
uniform highp vec4 MatColor;
in highp vec3 v_viewSpaceNormal;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    bgfx_FragColor = vec4(vec3(0.20000000298023223876953125) + ((vec3(0.800000011920928955078125) * clamp(dot(v_viewSpaceNormal, -(u_view * vec4(LightWorldSpaceDirection.xyz, 0.0)).xyz), 0.0, 1.0)) * MatColor.xyz), MatColor.w);
}
