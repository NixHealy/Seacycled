shader_type canvas_item;

void fragment() {
	if (COLOR.a > 0.f) {
		COLOR = vec4(1.0, 1.0, 1.0, 1.0);
	}
}