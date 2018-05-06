#ifdef VERTEX
vec4 position(mat4 transProj, vec4 vPos) {
  return transProj * vPos;
}
#endif

#ifdef PIXEL
vec4 effect(vec4 color, Image texture, vec2 uv, vec2 screen) {
  vec4 c = Texel(texture, uv);
  if (distance(c, vec4(0., 1., 0., 1.)) < 0.5) {
    return color;
  } else {
    return c * vec4(1., 1., 1., color.a);
  }
}
#endif
