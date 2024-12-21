shader_type canvas_item;
//render_mode unshaded;

uniform bool greyscale = false;
uniform bool dissolve = false;
uniform float dissolve_level : hint_range(0.0, 1.0) = 0.0;
uniform float alpha: hint_range(0.0, 1.0, 0.01) = 1.0;
uniform bool chroma_offset = false;
uniform float chroma_offset_value: hint_range(0.0, 10.0, 0.1) = 1.0;

float random(vec2 uv) {
	return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 438.5453);
}

void fragment() {
	vec4 color = COLOR;

	if (chroma_offset) {
		vec4 cr = texture(TEXTURE, UV);
		vec4 cg = texture(TEXTURE, vec2(UV.x + (chroma_offset_value * TEXTURE_PIXEL_SIZE.x), UV.y));
		vec4 cb = texture(TEXTURE, vec2(UV.x - (chroma_offset_value *  TEXTURE_PIXEL_SIZE.x), UV.y));
		color = vec4( cr.r, cg.g, cb.b, cr.a);
	}

	if (greyscale) {
		float avg = COLOR.r * 0.299 + COLOR.g * 0.587 + COLOR.b * 0.114;
		color = vec4(vec3(avg), alpha * color.a);
	}

	if (dissolve) {
		float size_x = float(textureSize(TEXTURE, 0).x);
		float size_y = float(textureSize(TEXTURE, 0).y);
		vec4 pixelColor = color;
		vec2 UVr = vec2(floor(UV.x * size_x) / size_x, floor(UV.y * size_y) / size_y);
		float visible = step(dissolve_level, random(UVr));
		color = vec4(pixelColor.r, pixelColor.g, pixelColor.b, min(visible, pixelColor.a));
	}

	color.a = color.a * alpha;
	COLOR = color;
}