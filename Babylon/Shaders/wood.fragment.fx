﻿#ifdef GL_ES
precision highp float;
#endif

varying vec2 vPosition;              
varying vec2 vUV;                    

uniform float ampScale;
uniform float ringScale;
uniform vec3 woodColor1;
uniform vec3 woodColor2;


float rand(vec2 n) {
	return fract(cos(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float noise(vec2 n) {
	const vec2 d = vec2(0.0, 1.0);
	vec2 b = floor(n), f = smoothstep(vec2(0.0), vec2(1.0), fract(n));
	return mix(mix(rand(b), rand(b + d.yx), f.x), mix(rand(b + d.xy), rand(b + d.yy), f.x), f.y);
}

float fbm(vec2 n) {
	float total = 0.0, amplitude = 1.0;
	for (int i = 0; i < 4; i++) {
		total += noise(n) * amplitude;
		n += n;
		amplitude *= 0.5;
	}
	return total;
}

void main(void) {

	vec2 positionWood = vPosition;
	float r = ringScale * sqrt(dot(positionWood.xy, positionWood.xy));
	r = r + fbm(vPosition);
	r = r - floor(r);
	r = smoothstep(0.0, 0.8, r) - smoothstep(0.8, 1.0, r);

	gl_FragColor = vec4(mix(woodColor1, woodColor2, r), 1.0);
}