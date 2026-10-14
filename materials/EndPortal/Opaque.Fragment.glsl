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
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec4 var_bf7cf = texture(s_ColorTexture, v_colorUV);
    highp vec4 var_66903 = var_bf7cf;
    highp vec3 var_1dca6 = var_bf7cf.xyz * (texture(s_ParallaxTexture, v_parallaxUV).xyz * (1.0 - v_encodedPlane));
    var_66903.x = var_1dca6.x;
    var_66903.y = var_1dca6.y;
    var_66903.z = var_1dca6.z;
    if ((v_encodedPlane * 32.0) > 31.0)
    {
        var_66903 = vec4(v_fog.xyz * v_fog.w, 1.0);
    }
    else
    {
        var_66903 = vec4(var_66903.xyz * (1.0 - v_fog.w), 0.0);
    }
    bgfx_FragData0 = var_66903;
}
