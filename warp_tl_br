#version 300 es

precision highp float;
precision highp sampler2D;

in vec2 uv;
out vec4 out_color;

uniform vec2 u_resolution;
uniform float u_time;
uniform vec4 u_mouse;
uniform sampler2D u_textures[16];

#include <lygia/animation/easing/quadratic>
#include <lygia/animation/easing/exponential>


void main(void) {
    float pos = u_mouse.x / u_resolution.x;

    float progress = quadraticOut(pos);

    vec2 st = gl_FragCoord.xy * (1.0/u_resolution.xy);

    //invert from the top
    st.y = 1. - st.y;
    
    //makes # close to zero = zero, and close to 1 = 1
    float s = sin(progress);

    float t = smoothstep(progress, progress+s, (st.x+st.y)/2.0);    

    float ea = exponentialOut(progress);
    vec2 uv1 = uv - ((1. - ea) * .3);
    vec2 uv2 = uv - (ea * 0.3);
    
    out_color = mix(
        texture(u_textures[0],vec2(uv.x, uv1.y + t)),
        texture(u_textures[1],vec2(uv.x, uv2.y + (1. - t))),
        t
    );
}
