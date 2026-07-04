#version 310 es

/*
* Available Macros:
*
* Passes:
* - CLUSTER_LIGHTS_PASS (not used)
* - CLUSTER_LIGHTS_MANHATTAN_PASS (not used)
* - FALLBACK_PASS (not used)
*
* ChangeMaxLightPerCluster:
* - CHANGE_MAX_LIGHT_PER_CLUSTER__HIGHER (not used)
* - CHANGE_MAX_LIGHT_PER_CLUSTER__LOWER (not used)
* - CHANGE_MAX_LIGHT_PER_CLUSTER__OFF (not used)
*
* Available Resources:
*
* Buffers:
* - layout(binding = 1, std430) buffer s_ExtendsBuffer { LightExtends s_Extends[]; };
* - layout(binding = 0, std430) buffer s_LightLookupArrayBuffer { LightData s_LightLookupArray[]; };
*
* Uniforms:
* - uniform vec4 CameraClusterWeight;
* - uniform vec4 CameraFarPlane;
* - uniform vec4 ClusterDimensions;
* - uniform vec4 ClusterNearFarWidthHeight;
* - uniform vec4 ClusterSize;
* - uniform mat4 InvViewMat;
* - uniform vec4 LightsPerCluster;
* - uniform mat4 ProjMat;
* - uniform mat4 ViewMat;
* - uniform vec4 WorldOrigin;
*/

void main() {
    gl_Position = vec4(0.0);
}
