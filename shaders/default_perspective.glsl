// varying vec4 vTestPosition;

#ifdef VERTEX
// attribute vec4 vTestPosition;

extern mat4 proj;

vec4 position(mat4 transProj, vec4 vPos) {
  // vPos.z = -0.5;
  return proj * vPos;
}
#endif

#ifdef PIXEL
vec4 effect(vec4 color, Image texture, vec2 uv, vec2 screen) {
  return Texel(texture, uv) * color;
}
#endif
