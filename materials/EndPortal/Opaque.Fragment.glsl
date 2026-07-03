#version 310 es

/*
* Available Macros:
*
* Passes:
* - OPAQUE_PASS (not used)
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
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 ViewPositionAndTime;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_ColorTexture;
uniform highp sampler2D s_ParallaxTexture;
centroid in highp vec2 v_colorUV;
in highp float v_encodedPlane;
in highp vec4 v_fog;
centroid in highp vec2 v_parallaxUV;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_1d0b7 = v_fog;
    highp vec4 var_73e16 = texture(s_ColorTexture, v_colorUV);
    highp vec4 var_bebe3 = texture(s_ParallaxTexture, v_parallaxUV);
    highp vec4 var_f8f23;
    if ((v_encodedPlane * 32.0) > 31.0)
    {
        var_f8f23 = vec4(v_fog.xyz * var_1d0b7.w, 1.0);
    }
    else
    {
        var_f8f23 = vec4((var_73e16.xyz * (var_bebe3.xyz * (1.0 - v_encodedPlane))).xyz * (1.0 - var_1d0b7.w), 0.0);
    }
    bgfx_FragColor = var_f8f23;
}
