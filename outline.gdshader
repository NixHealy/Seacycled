shader_type canvas_item;

uniform float red : hint_range(0, 1);
uniform float green : hint_range(0, 1);
uniform float blue : hint_range(0, 1);
uniform float alpha : hint_range(0, 1);

void fragment() {
	if (COLOR.a > 0.f) {
		COLOR = vec4(red, green, blue, alpha);
	}
}