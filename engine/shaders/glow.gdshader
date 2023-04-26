shader_type canvas_item;

uniform sampler2D gradient;
uniform sampler2D noise1;
uniform sampler2D noise2;

void fragment() {
	vec4 def = texture(TEXTURE, UV);
	float grayscale = (def.r + def.g + def.b) / 3.0;
//	def.rgb = vec3(grayscale, grayscale, grayscale);
	vec4 noice1 = texture(noise1, vec2(mod(UV.x + TIME * -0.01, 1.0), mod(UV.y + TIME * -0.07, 1.0)));
	vec4 noice2 = texture(noise2, vec2(mod(UV.x - TIME * 0.07, 1.0), mod(UV.y - TIME * 0.1, 1.0)));
	float pos = mod(UV.x + UV.y + TIME * 0.1, 1.0);
	float pos1 = noice1.r * noice2.r;
	vec4 gcol = texture(gradient, vec2(pos1, pos1));
	COLOR.rgb = (def.rgb + gcol.rgb * 3.0) / 4.0;
}
