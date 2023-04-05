shader_type canvas_item;

uniform sampler2D gradient;
uniform sampler2D noice1;
uniform sampler2D noice2;
uniform sampler2D stars;
uniform float speed;

float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}

vec2 scrolling(vec2 scroll, vec2 uv)
{
	vec2 pos = uv + (TIME * speed) * scroll;
	pos.x = abs(pos.x - float(int(pos.x)));
	pos.y = abs(pos.y - float(int(pos.y)));
	return pos;
}

void fragment() {
	vec2 pos = scrolling(vec2(0.003, 0.002137) * 5.1, UV);
	vec2 pos2 = scrolling(vec2(-0.010, 0.0220) * 5.1, UV);
	vec4 n1 = texture(noice1, pos);
	vec4 n2 = texture(noice2, pos2);
	n1 *= n2;
	vec4 grad = texture(gradient, n1.gb);
	COLOR *= grad;
//	if(random(UV) > 0.999)
//	{
//		COLOR.rgb = vec3(1.0, 1.0, 1.0);
//	}
}
