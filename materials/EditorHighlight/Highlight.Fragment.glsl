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

precision mediump float;
precision highp int;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    bgfx_FragColor = vec4(0.0);
}
