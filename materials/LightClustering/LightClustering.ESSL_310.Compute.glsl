#version 310 es

/*
* Available Macros:
*
* Passes:
* - CLUSTER_LIGHTS_PASS (not used)
* - FALLBACK_PASS (not used)
*/

#define shadow2D(_sampler, _coord)texture(_sampler, _coord)
#define shadow2DArray(_sampler, _coord)texture(_sampler, _coord)
#define shadow2DProj(_sampler, _coord)textureProj(_sampler, _coord)
struct NoopSampler {
    int noop;
};

struct NoopImage2D {
    int noop;
};

struct NoopImage3D {
    int noop;
};

struct rayQueryKHR {
    int noop;
};

struct accelerationStructureKHR {
    int noop;
};

uniform vec4 ClusterNearFarWidthHeight;
uniform vec4 CameraFarPlane;
uniform vec4 LightsPerCluster;
uniform vec4 ClusterDimensions;
uniform vec4 ClusterSize;
uvec3 LocalInvocationID;
uint LocalInvocationIndex;
uvec3 GlobalInvocationID;
uvec3 WorkGroupID;
struct LightData {
    float lookup;
};

struct LightCluster {
    int count;
};

struct LightDistance {
    float distance;
    int indexInLookUp;
};

struct LightExtends {
    vec4 min;
    vec4 max;
    vec4 viewPos;
    int index;
    int pad0;
    int pad1;
    int pad2;
};

struct VertexInput {
    float dummy;
};

struct VertexOutput {
    vec4 position;
};

struct FragmentInput {
    float dummy;
};

struct FragmentOutput {
    vec4 Color0;
};

layout(std430, binding = 1)buffer s_Extends { LightExtends Extends[]; };
layout(std430, binding = 0)buffer s_LightLookupArray { LightData LightLookupArray[]; };
float getClusterDepthByIndex(float index, float maxSlices, vec2 clusterNearFar) {
    float zNear = clusterNearFar.x;
    float zFar = clusterNearFar.y;
    float nearFarLog = log(zFar / zNear);
    float logDepth = nearFarLog * index / maxSlices + log(zNear);
    return exp(logDepth);
}
float getViewSpaceCoordByRatio(float clusterIndex, float clusterSize, float screenDim, float farPlaneDim, float planeRatio) {
    return ((clusterIndex * clusterSize - screenDim / 2.0f) / screenDim) * (farPlaneDim * planeRatio);
}
void ClusterLights() {
    float x = float(GlobalInvocationID.x);
    float y = float(GlobalInvocationID.y);
    float z = float(GlobalInvocationID.z);
    int lightCount = int(ClusterDimensions.w);
    int maxLights = int(LightsPerCluster.x);
    if (x >= ClusterDimensions.x || y >= ClusterDimensions.y || z >= ClusterDimensions.z) {
        return;
    }
    highp int idx = int(x + y * ClusterDimensions.x + z * ClusterDimensions.x * ClusterDimensions.y);
    highp int rangeStart = int(idx * maxLights);
    highp int rangeEnd = int(rangeStart + maxLights);
    float viewDepth = getClusterDepthByIndex(z + 0.5f, ClusterDimensions.z, ClusterNearFarWidthHeight.xy);
    float planeRatio = viewDepth / CameraFarPlane.z;
    float centerX = getViewSpaceCoordByRatio(x + 0.5f, ClusterSize.x, ClusterNearFarWidthHeight.z, CameraFarPlane.x, planeRatio);
    float centerY = getViewSpaceCoordByRatio(y + 0.5f, ClusterSize.y, ClusterNearFarWidthHeight.w, CameraFarPlane.y, planeRatio);
    vec3 center = vec3(centerX, centerY, - viewDepth);
    LightDistance distanceToCenter[64];
    int countResult = 0;
    for(int l = 0; l < lightCount; l ++ ) {
        LightExtends bound = Extends[l];
        if (z < bound.min.z || z > bound.max.z)continue;
        if (y < bound.min.y || y > bound.max.y)continue;
        if (x < bound.min.x || x > bound.max.x)continue;
        float curDistance = length(bound.viewPos.xyz - center);
        if (countResult >= maxLights && curDistance >= distanceToCenter[countResult - 1].distance) {
            continue;
        }
        int low = 0;
        int high = countResult;
        while(low < high) {
            int mid = (low + high) / 2;
            if (distanceToCenter[mid].distance < curDistance) {
                low = mid + 1;
            }
            else {
                high = mid;
            }
        }
        if (countResult < maxLights) {
            for(int j = countResult - 1; j >= low; j -- ) {
                distanceToCenter[j + 1] = distanceToCenter[j];
            }
            distanceToCenter[low].distance = curDistance;
            distanceToCenter[low].indexInLookUp = countResult;
            LightLookupArray[idx * maxLights + countResult].lookup = float(bound.index);
            countResult ++ ;
        }
        else {
            int insertPos = distanceToCenter[maxLights - 1].indexInLookUp;
            for(int j = maxLights - 2; j >= low; j -- ) {
                distanceToCenter[j + 1] = distanceToCenter[j];
            }
            distanceToCenter[low].distance = curDistance;
            distanceToCenter[low].indexInLookUp = insertPos;
            LightLookupArray[idx * maxLights + insertPos].lookup = float(bound.index);
        }
    }
    if (countResult < maxLights) {
        LightLookupArray[rangeStart + countResult].lookup = -1.0;
    }
}

layout(local_size_x = 4, local_size_y = 4, local_size_z = 4)in;
void main() {
    LocalInvocationID = gl_LocalInvocationID;
    LocalInvocationIndex = gl_LocalInvocationIndex;
    GlobalInvocationID = gl_GlobalInvocationID;
    WorkGroupID = gl_WorkGroupID;
    ClusterLights();
}

