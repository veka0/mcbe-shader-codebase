#version 310 es

/*
* Available Macros:
*
* Passes:
* - COMBINE_PASS (not used)
* - FALLBACK_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - layout(binding = 0, std430) buffer s_DirtyVolumeKeysBuffer { UintEntry s_DirtyVolumeKeys[]; };
* - layout(binding = 1, std430) buffer s_GpuEntryBufferBuffer { GpuVolumeEntry s_GpuEntryBuffer[]; };
* - layout(binding = 2, std430) buffer s_PerGroupLerpsBuffer { FloatEntry s_PerGroupLerps[]; };
* - layout(binding = 3, std430) buffer s_TransitioningGpuEntryBufferBuffer { GpuVolumeEntry s_TransitioningGpuEntryBuffer[]; };
* - layout(binding = 4, std430) buffer s_TransitioningVoxelBufferBuffer { VoxelNode s_TransitioningVoxelBuffer[]; };
* - layout(binding = 5, std430) buffer s_VoxelBufferBuffer { VoxelNode s_VoxelBuffer[]; };
*
* Uniforms:
* - uniform vec4 DirtyVolumeCount;
* - uniform vec4 GpuEntryBufferCapacity;
* - uniform vec4 TransitioningAmbientScalar;
* - uniform vec4 TransitioningGpuEntryBufferCapacity;
* - uniform vec4 TransitioningVolumesLayerCount;
*/

precision mediump float;
precision highp int;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    bgfx_FragData0 = vec4(0.0);
}
