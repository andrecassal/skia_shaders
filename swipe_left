#version 300 es

precision highp float;
precision highp sampler2D;

in vec2 uv;
out vec4 out_color;


#include <lygia/animation/easing/circularOut>


uniform vec2 u_resolution;
uniform float u_time;
uniform vec4 u_mouse;
uniform sampler2D u_textures[16];

vec4 getFromColor(vec2 uv){
    return texture(u_textures[0], uv);
}
vec4 getToColor(vec2 uv){
    return texture(u_textures[1], uv);
}


vec4 shadow_colour = vec4(0.,0.,0.,.6);
float shadow_height = 0.075;
float bounces = .0;

const float PI = 3.14159265358;
const float progress = 0.;


vec4 transition (vec2 uv) {
  float progress = circularOut(u_mouse.x / u_resolution.x);

  float x = (abs(cos(progress))) * (1.0 - progress);
  float d = uv.x - x;

  return mix(
    mix(
      getToColor(uv),
      shadow_colour,
      step(d, shadow_height) * (1. - mix(
        ((d / shadow_height) * shadow_colour.a) + (1.0 - shadow_colour.a),
        1.0,
        smoothstep(0.95, 1., progress) // fade-out the shadow at the end
      ))
    ),
    getFromColor(vec2(uv.x+ (1.0 - x), uv.y)),
    step(d, 0.0)
  );
}


void main(){
    out_color = transition(uv);
}
