shader_type canvas_item;

//uniform vec2 pos1 = vec2(0.35, 0.35);
uniform vec2 pos1 = vec2(0.40, 0.40);
//uniform vec2 pos1 = vec2(0.30, 0.50);
uniform float w1 = 1.0;
uniform float k1 = 100.0;
uniform float A1 = 0.5;

//uniform vec2 pos2 = vec2(0.65, 0.65);
uniform vec2 pos2 = vec2(0.6, 0.6);
//uniform vec2 pos2 = vec2(0.70, 0.5);
uniform float w2 = 1.0;
uniform float k2 = 100.0;
uniform float A2 = 0.5;

uniform sampler2D gradient;

void fragment() {
	float x1 = sqrt((UV.x-pos1.x) * (UV.x - pos1.x) + (UV.y - pos1.y) * (UV.y - pos1.y));
	float x2 = sqrt((UV.x-pos2.x) * (UV.x - pos2.x) + (UV.y - pos2.y) * (UV.y - pos2.y));
	float wave1 = A1 * sin(w1 * TIME - k1 * x1);
	float wave2 = A2 * sin(w2 * TIME - k2 * x2);
	float waveSum = wave1 + wave2;
	vec4 color = vec4(waveSum, waveSum, waveSum, waveSum) + 0.5;
//	color.r = wave2 + 0.5;
	COLOR = color;
}
