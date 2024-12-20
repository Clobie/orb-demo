shader_type canvas_item;
//render_mode unshaded;

uniform bool toggle = false;

void fragment() {
	if (toggle) {
		float avg = COLOR.r * 0.299 + COLOR.g * 0.587 + COLOR.b * 0.114;
		float r = COLOR.b;
		float g = COLOR.g;
		float b = COLOR.r;
		COLOR = vec4(r, g, b, COLOR.a);
	}
}
