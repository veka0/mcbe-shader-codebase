#version 310 es

/*
* Available Macros:
*
* Passes:
* - DO_CHECKERBOARDING_PASS (not used)
* - FALLBACK_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_ColorMetalnessInput;
* - uniform lowp sampler2D s_ColorMetalnessOutput;
* - uniform lowp sampler2D s_EmissiveLinearRoughnessInput;
* - uniform lowp sampler2D s_EmissiveLinearRoughnessOutput;
* - uniform lowp sampler2D s_LowPrecisionWorldPositionInput;
* - uniform lowp sampler2D s_LowPrecisionWorldPositionOutput;
* - uniform lowp sampler2D s_NormalInput;
* - uniform lowp sampler2D s_NormalOutput;
* - uniform lowp sampler2D s_PlaneIDInput;
* - uniform lowp sampler2D s_PlaneIDOutput;
* - uniform lowp sampler2D s_ViewDirectionAndSplitMaskInput;
* - uniform lowp sampler2D s_ViewDirectionAndSplitMaskOutput;
* - uniform lowp sampler2D s_WorldPositionInput;
* - uniform lowp sampler2D s_WorldPositionOutput;
*
* Uniforms:
* - uniform vec4 OtherSideOffset;
*/

precision mediump float;
precision highp int;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    bgfx_FragColor = vec4(0.0);
}
