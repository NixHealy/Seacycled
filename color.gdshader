shader_type canvas_item;

uniform vec3 new_color;
uniform bool active;

void fragment(){
	vec4 orig_color = texture(TEXTURE, UV);
	
	if (orig_color.a > 0.1 && active) {
		COLOR.rgb = new_color;
		COLOR.a = 1.f;
	}
}