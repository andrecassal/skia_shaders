#version 300 es

precision highp float;
precision highp sampler2D;

in vec2 uv;
out vec4 out_color;

uniform vec2 u_resolution;
uniform float u_time;
uniform vec4 u_mouse;
uniform sampler2D u_textures[16];

vec4 foreground = vec4(1.0,0.0,0.0,1.0);
vec4 background = vec4(0.0,.0,1.0,1.0);

void main(){
    
    float t = u_time / 1.1;
    float len = length(uv.y);

    float p = step(len, t);

    out_color = mix(
        foreground,
        background,
        p
    );
}
