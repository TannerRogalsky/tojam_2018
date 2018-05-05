#ifdef VERTEX
vec4 position(mat4 transProj, vec4 vPos) {
  return transProj * vPos;
}
#endif

#ifdef PIXEL
#define PI 3.14

uniform vec2 resolution;

//sample from the 1D distance map
float sample(Image texture, vec2 coord, float r) {
  return step(r, Texel(texture, coord).r);
  // return smoothstep(r, r + 0.01, Texel(texture, coord).r);
  // return Texel(texture, coord).r;
}

vec4 effect(vec4 color, Image texture, vec2 uv, vec2 screen) {
  //rectangular to polar
  vec2 norm = uv * 2.0 - 1.0;
  float theta = atan(norm.y, norm.x);
  float r = length(norm);
  float coord = (theta + PI) / (2.0*PI);

  //the tex coord to sample our 1D lookup texture
  //always 0.0 on y axis
  vec2 tc = vec2(coord, 0.0);

  //the center tex coord, which gives us hard shadows
  float center = sample(texture, tc, r);

  //we multiply the blur amount by our distance from center
  //this leads to more blurriness as the shadow "fades away"
  float blur = (1./resolution.x) * smoothstep(0., 1., r);

  //now we use a simple gaussian blur
  // float sum = center;// * (1.0 + dFdx(center));
  // sum = center + max(dFdx(center), dFdx(1.0 - center)) * 0.2;
  float sum = 0.0;

  sum += sample(texture, vec2(tc.x - 4.0*blur, tc.y), r) * 0.05;
  sum += sample(texture, vec2(tc.x - 3.0*blur, tc.y), r) * 0.09;
  sum += sample(texture, vec2(tc.x - 2.0*blur, tc.y), r) * 0.12;
  sum += sample(texture, vec2(tc.x - 1.0*blur, tc.y), r) * 0.15;

  sum += center * 0.16;

  sum += sample(texture, vec2(tc.x + 1.0*blur, tc.y), r) * 0.15;
  sum += sample(texture, vec2(tc.x + 2.0*blur, tc.y), r) * 0.12;
  sum += sample(texture, vec2(tc.x + 3.0*blur, tc.y), r) * 0.09;
  sum += sample(texture, vec2(tc.x + 4.0*blur, tc.y), r) * 0.05;

  //sum of 1.0 -> in light, 0.0 -> in shadow

  //multiply the summed amount by our distance, which gives us a radial falloff
  //then multiply by vertex (light) color
  return color * vec4(vec3(1.0), sum);
}
#endif
