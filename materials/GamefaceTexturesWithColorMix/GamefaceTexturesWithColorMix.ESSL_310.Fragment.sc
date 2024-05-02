/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*/

$input v_additional, v_color, v_screenPosition
struct NoopSampler {
    int noop;
};

vec4 textureSample(mediump sampler2D _sampler, vec2 _coord) {
    return texture(_sampler, _coord);
}
vec4 textureSample(mediump sampler3D _sampler, vec3 _coord) {
    return texture(_sampler, _coord);
}
vec4 textureSample(mediump samplerCube _sampler, vec3 _coord) {
    return texture(_sampler, _coord);
}
vec4 textureSample(mediump sampler2D _sampler, vec2 _coord, float _lod) {
    return textureLod(_sampler, _coord, _lod);
}
vec4 textureSample(mediump sampler3D _sampler, vec3 _coord, float _lod) {
    return textureLod(_sampler, _coord, _lod);
}
vec4 textureSample(mediump sampler2DArray _sampler, vec3 _coord) {
    return texture(_sampler, _coord);
}
vec4 textureSample(mediump sampler2DArray _sampler, vec3 _coord, float _lod) {
    return textureLod(_sampler, _coord, _lod);
}
vec4 textureSample(NoopSampler noopsampler, vec2 _coord) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec3 _coord) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec2 _coord, float _lod) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec3 _coord, float _lod) {
    return vec4(0, 0, 0, 0);
}
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

uniform vec4 PrimProps0;
uniform mat4 Transform;
vec4 ViewRect;
mat4 Proj;
mat4 View;
vec4 ViewTexel;
mat4 InvView;
mat4 InvProj;
mat4 ViewProj;
mat4 InvViewProj;
mat4 PrevViewProj;
mat4 WorldArray[4];
mat4 World;
mat4 WorldView;
mat4 WorldViewProj;
vec4 PrevWorldPosOffset;
vec4 AlphaRef4;
float AlphaRef;
struct VertexInput {
    vec4 additional;
    vec4 color;
    vec4 position;
};

struct VertexOutput {
    vec4 position;
    vec4 additional;
    vec4 color;
    vec4 screenPosition;
};

struct FragmentInput {
    vec4 additional;
    vec4 color;
    vec4 screenPosition;
};

struct FragmentOutput {
    vec4 Color0;
};

SAMPLER2D_AUTOREG(s_Texture0);
SAMPLER2D_AUTOREG(s_Texture1);
float Lum(vec3 color) {
    return 0.3 * color.r + 0.59 * color.g + 0.11 * color.b;
}
vec3 ClipColor(vec3 color) {
    float L = Lum(color);
    float fmin = min(min(color.r, color.g), color.b);
    float fmax = max(max(color.r, color.g), color.b);
    if (fmin < 0.0)
    {
        color = L + (((color - L) * L) / (L - fmin));
    }
    if (fmax > 1.0)
    {
        color = L + (((color - L) * (1.0 - L)) / (fmax - L)); // Attention!
    }
    return color;
}
vec3 SetLum(vec3 color, float lum) {
    float d = lum - Lum(color);
    color += d;
    return ClipColor(color);
}
float Sat(vec3 color) {
    return max(max(color.r, color.g), color.b) -
    min(min(color.r, color.g), color.b);
}
vec3 SetSatInner(vec3 color, float sat) {
    if (color.z > color.x)
    {
        color.y = (((color.y - color.x) * sat) / (color.z - color.x));
        color.z = sat;
    }
    else
    {
        color.yz = vec2(0.0, 0.0);
    }
    return vec3(0.0, color.y, color.z);
}
vec3 SetSat(vec3 color, float sat) {
    if (color.r <= color.g)
    {
        if (color.g <= color.b)
        {
            color.rgb = SetSatInner(color.rgb, sat);
        }
        else if (color.r <= color.b)
        {
            color.rbg = SetSatInner(color.rbg, sat);
        }
        else
        {
            color.brg = SetSatInner(color.brg, sat);
        }
    }
    else if (color.r <= color.b)
    {
        color.grb = SetSatInner(color.grb, sat);
    }
    else if (color.g <= color.b)
    {
        color.gbr = SetSatInner(color.gbr, sat);
    }
    else
    {
        color.bgr = SetSatInner(color.bgr, sat);
    }
    return color;
}
vec3 ColorMixScreen(vec3 backdrop, vec3 source) {
    return backdrop + source - backdrop * source;
}
vec3 ColorMixMultiply(vec3 backdrop, vec3 source) {
    return backdrop * source;
}
vec3 ColorMixHardLight(vec3 backdrop, vec3 source) {
    vec3 coef = step(0.5, source);
    return mix(ColorMixScreen(backdrop, 2.0 * source - 1.0),
    ColorMixMultiply(backdrop, 2.0 * source), coef);
}
vec3 ColorMixSoftLight(vec3 backdrop, vec3 source) {
    vec3 diffuseBCoef = step(0.25, backdrop);
    vec3 diffuseB = mix(sqrt(backdrop),
    ((16.0 * backdrop - 12.0) * backdrop + 4.0) * backdrop,
diffuseBCoef);
vec3 coef = step(0.5, source);
return mix(backdrop + (2.0 * source - 1.0) * (diffuseB - backdrop), // Attention!
backdrop - (1.0 - 2.0 * source) * backdrop * (1.0 - backdrop),
coef);
}
vec3 BlendFunction(vec3 backdrop, vec3 source, int mode) {
if (mode == 0)
{
return source;
}
else if (mode == 1)
{
return ColorMixMultiply(backdrop, source);
}
else if (mode == 2)
{
return ColorMixScreen(backdrop, source);
}
else if (mode == 3)
{
return ColorMixHardLight(source, backdrop);
}
else if (mode == 4)
{
return min(source, backdrop);
}
else if (mode == 5)
{
return max(source, backdrop);
}
else if (mode == 6)
{
return min(backdrop / max(1.0 - source, 0.0001), 1.0);
}
else if (mode == 7)
{
return 1.0 - min((1.0 - backdrop) / max(source, 0.0001), 1.0);
}
else if (mode == 8)
{
return ColorMixHardLight(backdrop, source);
}
else if (mode == 9)
{
return ColorMixSoftLight(backdrop, source);
}
else if (mode == 10)
{
return abs(backdrop - source);
}
else if (mode == 11)
{
return backdrop + source - 2.0 * backdrop * source;
}
else if (mode == 12)
{
return SetLum(SetSat(source, Sat(backdrop)), Lum(backdrop));
}
else if (mode == 13)
{
return SetLum(SetSat(backdrop, Sat(source)), Lum(backdrop));
}
else if (mode == 14)
{
return SetLum(source, Lum(backdrop));
}
else if (mode == 15)
{
return SetLum(backdrop, Lum(source));
}
else if (mode == 16)
{
return min(source + backdrop, 1.0);
}
else
{
return vec3(0.0, 0.0, 0.0);
}
}
void Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
vec2 uvBackdrop = (vec2((fragInput.additional.zw).x, 1.0 - (fragInput.additional.zw).y));
vec2 uvSource = (vec2((fragInput.additional.xy).x, 1.0 - (fragInput.additional.xy).y));
vec4 backdrop = textureSample(s_Texture1, uvBackdrop);
vec4 source = textureSample(s_Texture0, uvSource) * fragInput.color.a;
vec3 backdropUnprem = backdrop.rgb / max(backdrop.a, 0.0001);
vec3 sourceUnprem = source.rgb / max(source.a, 0.0001);
vec4 result =
(1.0 - backdrop.a) * source +
source.a * backdrop.a * vec4(
clamp(BlendFunction(backdropUnprem, sourceUnprem, int(PrimProps0.x)), 0.0, 1.0), 1.0) +
(1.0 - source.a) * backdrop;
fragOutput.Color0 = result;
}
void main() {
FragmentInput fragmentInput;
FragmentOutput fragmentOutput;
fragmentInput.additional = v_additional;
fragmentInput.color = v_color;
fragmentInput.screenPosition = v_screenPosition;
fragmentOutput.Color0 = vec4(0, 0, 0, 0);
ViewRect = u_viewRect;
Proj = u_proj;
View = u_view;
ViewTexel = u_viewTexel;
InvView = u_invView;
InvProj = u_invProj;
ViewProj = u_viewProj;
InvViewProj = u_invViewProj;
PrevViewProj = u_prevViewProj;
{
    WorldArray[0] = u_model[0];
    WorldArray[1] = u_model[1];
    WorldArray[2] = u_model[2];
    WorldArray[3] = u_model[3];
}
World = u_model[0];
WorldView = u_modelView;
WorldViewProj = u_modelViewProj;
PrevWorldPosOffset = u_prevWorldPosOffset;
AlphaRef4 = u_alphaRef4;
AlphaRef = u_alphaRef4.x;
Frag(fragmentInput, fragmentOutput);
gl_FragColor = fragmentOutput.Color0;
}

