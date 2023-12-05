# Overview
This repository contains vanilla Minecraft: Bedrock Edition GLSL shaders.

Shader code is auto-generated with **COMING SOON** using material.bin files extracted from Android MCBE version.
## Branches
Different editions are divided into separate branches
- `main` - release versions
- `preview` - preview versions
## Accuracy
Generated code is usually accurate, however sometimes the tool is unable to generate exact macro condition, in that case it will use the best approximation it could find and insert a comment just before macro condition, which will look like this:
```glsl
// Approximation, matches 44 cases out of 48
#if defined(SEASONS__ON) && !defined(DEPTH_ONLY_OPAQUE_PASS) && !defined(DEPTH_ONLY_PASS) && !defined(TRANSPARENT_PBR_PASS)
vec3 vec3_splat(float _x) { return vec3(_x, _x, _x); }
#endif
```
which means the following macro condition is accurate for 44 shader variants out of the total 48 available in material.bin file.
