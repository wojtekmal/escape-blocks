shader_type canvas_item;

uniform vec4 u_color : source_color = vec4(.0, 1.0, .0, 1.0);
uniform bool rgb;

uniform float strength: hint_range(0., 1.) = 0.5;
uniform float speed: hint_range(0., 10.) = 0.5;
uniform float angle: hint_range(0., 360.) = 45.;

void fragment() {
	if(!rgb)
	{
		vec4 color = u_color;
		vec4 pixelColor = texture(TEXTURE, UV);
		float brightness = (pixelColor.r + pixelColor.g + pixelColor.b) / 3.0;
		vec4 grayScale = vec4(brightness, brightness, brightness, 1.0 - pixelColor.a);
		COLOR = color * pixelColor;
	}
	else if(2 == 1)
	{
		vec4 pixelColor = texture(TEXTURE, UV);
//		vec4 color = vec4(sin(TIME * 0,5)
//		COLOR = color;
		COLOR.rgb *= pixelColor.rgb;
		COLOR.r = (sin(TIME*2.0) + 1.0) * 0.5;
		COLOR.g = (sin(TIME*2.0 + PI) + 1.0) * 0.5;
		COLOR.b = (sin(TIME*2.0 + PI * 1.5) + 1.0) * 0.5;
	}
	else
	{
		
	float hue = SCREEN_UV.x * cos(radians(angle)) - SCREEN_UV.y * sin(radians(angle));
	hue = fract(hue + fract(TIME  * speed));
	float x = 1. - abs(mod(hue / (1./ 6.), 2.) - 1.);
	vec3 rainbow;
	if(hue < 1./6.){
		rainbow = vec3(1., x, 0.);
	} else if (hue < 1./3.) {
		rainbow = vec3(x, 1., 0);
	} else if (hue < 0.5) {
		rainbow = vec3(0, 1., x);
	} else if (hue < 2./3.) {
		rainbow = vec3(0., x, 1.);
	} else if (hue < 5./6.) {
		rainbow = vec3(x, 0., 1.);
	} else {
		rainbow = vec3(1., 0., x);
	}
	vec4 color = texture(TEXTURE, UV);
	COLOR = mix(color, vec4(rainbow, color.a), strength);
	}
}

