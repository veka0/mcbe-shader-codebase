#version 310 es

/*
* Available Macros:
*
* Passes:
* - SSR_FILL_GAPS_PASS (not used)
* - SSR_GET_REFLECTED_COLOR_PASS (not used)
* - SSR_RAY_MARCH_PASS (not used)
* - SSR_RAY_MARCH_HZB_PASS (not used)
*
* ExtendedGapFill:
* - EXTENDED_GAP_FILL__OFF (not used)
* - EXTENDED_GAP_FILL__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_GbufferDepth;
* - uniform lowp sampler2D s_GbufferNormal;
* - uniform lowp usampler2D s_GbufferRoughness;
* - uniform lowp sampler2D s_HiZBuffer;
* - uniform lowp sampler2D s_InputTexture;
* - uniform lowp sampler2D s_PreviousReflectionBuffer;
* - uniform lowp sampler2D s_RasterColor;
*
* Uniforms:
* - uniform vec4 CameraData;
* - uniform vec4 HiZMipCount;
* - uniform vec4 HiZViewportDimensionsAndBufferDimensions;
* - uniform vec4 SSRFadingParamsAndThickness;
* - uniform vec4 SSRRayMarchingParams;
* - uniform vec4 SSRRoughnessCutoffParams;
* - uniform vec4 SSRTemporalAccumulationParams;
* - uniform vec4 ScreenSize;
* - uniform vec4 ScreenSpaceRayOffset;
* - uniform vec4 UnitPlaneExtents;
* - uniform vec4 ViewportScale;
*/

uniform vec4 ViewportScale;
in vec4 a_position;
in vec2 a_texcoord0;
out vec4 v_texcoord0;
void main() {
    vec4 var_c1461 = vec4(0.0);
    vec2 var_f32e0 = a_texcoord0 * ViewportScale.xy;
    var_c1461.x = var_f32e0.x;
    var_c1461.y = var_f32e0.y;
    var_c1461.z = a_texcoord0.x;
    var_c1461.w = a_texcoord0.y;
    v_texcoord0 = var_c1461;
    gl_Position = vec4((a_position.xy * 2.0) - vec2(1.0), 0.0, 1.0);
}
