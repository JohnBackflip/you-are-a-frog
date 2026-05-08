shader_type canvas_item;

uniform vec4 target_color : source_color;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    float mask = 1.0 - tex_color.r; 
    COLOR = vec4(target_color.rgb, mask * tex_color.a);
}