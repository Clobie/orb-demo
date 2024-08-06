shader_type canvas_item;
//render_mode unshaded;

uniform float darkness: hint_range(1.0, 10.0) = 2.5;

void fragment() {
	float avg = COLOR.r * 0.299 + COLOR.g * 0.587 + COLOR.b * 0.114;
	COLOR = vec4(vec3(avg) / darkness, COLOR.a);
}
