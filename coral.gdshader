shader_type canvas_item;

uniform float desaturate_strength = 0.5;
uniform float pollution_strength = 0.5;

void fragment(){
	vec4 orig_color = texture(TEXTURE, UV);
	float grey = (orig_color.r + orig_color.g + orig_color.b) / 3.0;
	vec4 grey_color = vec4(grey, grey, grey, 1.0);
	vec4 black_color = vec4(0, 0, 0, 1);
	if (orig_color.a > 0.0) {
		COLOR = mix(grey_color, orig_color, desaturate_strength);
	}
	//COLOR = mix(COLOR, black_color, pollution_strength);
}