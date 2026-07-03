#version 310 es

/*
* Available Macros:
*
* Passes:
* - SSR_FILL_GAPS_PASS (not used)
* - SSR_GET_REFLECTED_COLOR_PASS (not used)
* - SSR_RAY_MARCH_PASS (not used)
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
* - uniform lowp sampler2D s_GbufferRoughness;
* - uniform lowp sampler2D s_InputTexture;
* - uniform lowp sampler2D s_RasterColor;
*
* Uniforms:
* - uniform vec4 CameraData;
* - uniform vec4 RenderMode;
* - uniform vec4 SSRFadingParamsAndThickness;
* - uniform vec4 SSRRayMarchingParams;
* - uniform vec4 SSRRoughnessCutoffParams;
* - uniform vec4 ScreenSize;
* - uniform vec4 UnitPlaneExtents;
*/

in vec4 a_position;
in vec2 a_texcoord0;
out vec2 v_texcoord0;
void main() {
    vec2 var_8e808 = a_texcoord0;
    v_texcoord0 = vec2(var_8e808.x, var_8e808.y);
    gl_Position = vec4((a_position.xy * 2.0) - vec2(1.0), 0.0, 1.0);
}
