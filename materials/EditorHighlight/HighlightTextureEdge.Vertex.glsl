#version 310 es

/*
* Available Macros:
*
* Passes:
* - HIGHLIGHT_PASS (not used)
* - HIGHLIGHT_TEXTURE_EDGE_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_HighlightTextureColor;
* - uniform lowp sampler2D s_HighlightTextureDepth;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform lowp sampler2D s_SceneTextureColor;
* - uniform lowp sampler2D s_SceneTextureDepth;
* - uniform lowp sampler2D s_SelectedBlocksOverlayTexture;
*
* Uniforms:
* - uniform vec4 BlockEdgeColor;
* - uniform vec4 BlockEdgeThickness;
* - uniform vec4 CameraPosition;
* - uniform vec4 HiddenBlocksAlpha;
* - uniform vec4 HighlightAlpha;
* - uniform vec4 HighlightColor;
* - uniform mat4 InverseProjView;
* - uniform vec4 OutlineColor;
* - uniform vec4 OutlineWidth;
* - uniform vec4 OverlayTextureStretch;
* - uniform vec4 PreExposureEnabled;
* - uniform vec4 ScreenSize;
*/

in vec3 a_position;
in vec2 a_texcoord0;
out vec2 v_texcoord0;
void main() {
    vec4 var_ef43d = vec4(a_position, 1.0);
    vec2 var_ef197 = vec2(((var_ef43d.xy * 2.0) - vec2(1.0)).x, 1.0 - ((var_ef43d.xy * 2.0) - vec2(1.0)).y);
    v_texcoord0 = a_texcoord0;
    gl_Position = vec4(var_ef197.x, var_ef197.y, var_ef43d.z, var_ef43d.w);
}
