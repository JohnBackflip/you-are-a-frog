shader_type canvas_item;
uniform float width : hint_range(0.0, 30.0) = 2.0;
uniform vec4 outline_color : source_color = vec4(1.0);

void fragment() {
	float size = width * fwidth(UV.x);
	vec4 col = texture(TEXTURE, UV);
	float alpha = col.a;
	alpha += texture(TEXTURE, UV + vec2(0.0, size)).a;
	alpha += texture(TEXTURE, UV + vec2(0.0, -size)).a;
	alpha += texture(TEXTURE, UV + vec2(size, 0.0)).a;
	alpha += texture(TEXTURE, UV + vec2(-size, 0.0)).a;
	
	if (col.a < 0.1) {
		COLOR = vec4(outline_color.rgb, clamp(alpha, 0.0, 1.0));
	} else {
		COLOR = col;
	}
}