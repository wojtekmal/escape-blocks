shader_type canvas_item;

uniform float zoom = 1.0;
uniform vec2 direction = vec2(1.0, 0.5);
uniform float speed = 0.3;

void fragment() {
	vec2 pos = UV / zoom + direction * TIME * speed * zoom * zoom;
	pos.x = mod(pos.x, 1.0);
	pos.y = mod(pos.y, 1.0);
	COLOR = texture(TEXTURE, pos);
}
