#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - OPAQUE_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* SampleMatTexture:
* - SAMPLE_MAT_TEXTURE__OFF
* - SAMPLE_MAT_TEXTURE__ON
*
* TransformUV0:
* - TRANSFORM_UV0__OFF (not used)
* - TRANSFORM_UV0__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MatTexture;
*
* Uniforms:
* - uniform vec4 LightDirectionAndIntensity;
* - uniform vec4 MatColor;
* - uniform mat4 UV0Transform;
*/

precision mediump float;
precision highp int;
#ifdef SAMPLE_MAT_TEXTURE__ON
uniform highp sampler2D s_MatTexture;
#endif
uniform highp vec4 MatColor;
in highp vec4 v_color0;
#ifdef SAMPLE_MAT_TEXTURE__ON
in highp vec2 v_texcoord0;
#endif
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
#ifdef SAMPLE_MAT_TEXTURE__OFF
    bgfx_FragData0 = MatColor * v_color0;
#endif
#ifdef SAMPLE_MAT_TEXTURE__ON
    bgfx_FragData0 = (MatColor * texture(s_MatTexture, v_texcoord0)) * v_color0;
#endif
}
