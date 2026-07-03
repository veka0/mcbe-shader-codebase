#version 310 es

/*
* Available Macros:
*
* Passes:
* - CLUSTER_LIGHTS_PASS (not used)
* - FALLBACK_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - layout(binding = 1, std430) buffer s_ExtendsBuffer { LightExtends s_Extends[]; };
* - layout(binding = 0, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
*
* Uniforms:
* - uniform vec4 CameraFarPlane;
* - uniform vec4 ClusterDepthBounds;
* - uniform vec4 ClusterDimensions;
* - uniform vec4 ClusterNearFarWidthHeight;
* - uniform vec4 ClusterSize;
* - uniform vec4 LightsPerCluster;
*/

void main() {
    gl_Position = vec4(0.0);
}
