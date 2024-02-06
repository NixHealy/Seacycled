shader_type canvas_item;

uniform float desaturate_strength = 0.5;

void fragment(){
	vec4 orig_color = texture(TEXTURE, UV);
	float grey = (orig_color.r + orig_color.g + orig_color.b) / 3.0;
	vec4 grey_color = vec4(grey, grey, grey, 1.0);
	COLOR = mix(grey_color, orig_color, desaturate_strength);
}