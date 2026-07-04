#version 310 es

/*
* Available Macros:
*
* Passes:
* - FORCE_FORWARD_PBR_OPAQUE_PASS (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_ColorTexture;
* - uniform lowp sampler2D s_ParallaxTexture;
*
* Uniforms:
* - uniform vec4 EndPortalEmissiveMultiplierAndDesaturation;
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 ViewPositionAndTime;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_ColorTexture;
uniform highp sampler2D s_ParallaxTexture;
uniform highp vec4 EndPortalEmissiveMultiplierAndDesaturation;
centroid in highp vec2 v_colorUV;
in highp float v_encodedPlane;
in highp vec4 v_fog;
centroid in highp vec2 v_parallaxUV;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_1d0b7 = v_fog;
    highp vec4 var_73e16 = texture(s_ColorTexture, v_colorUV);
    highp vec4 var_bebe3 = texture(s_ParallaxTexture, v_parallaxUV);
    highp vec4 var_516bb;
    if ((v_encodedPlane * 32.0) > 31.0)
    {
        var_516bb = vec4(v_fog.xyz * var_1d0b7.w, 1.0);
    }
    else
    {
        var_516bb = vec4((var_73e16.xyz * (var_bebe3.xyz * (1.0 - v_encodedPlane))).xyz * (1.0 - var_1d0b7.w), 0.0);
    }
    highp vec4 var_b6fe8 = var_516bb;
    highp vec4 var_fa666 = vec4(pow(max(var_516bb.xyz, vec3(0.0)), vec3(2.2000000476837158203125)), var_b6fe8.w);
    highp vec3 var_4b784 = var_fa666.xyz;
    highp vec3 var_9b998 = var_fa666.xyz + (mix(var_4b784, vec3(dot(var_4b784, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))), vec3(EndPortalEmissiveMultiplierAndDesaturation.y)) * EndPortalEmissiveMultiplierAndDesaturation.x);
    bgfx_FragColor = vec4(var_9b998.x, var_9b998.y, var_9b998.z, var_fa666.w);
}
