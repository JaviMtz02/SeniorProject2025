shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(1.0);
uniform float glow_strength : hint_range(0.0, 1.0) = 0.3;
void fragment() {
	COLOR = texture(TEXTURE, UV);
	if (glow_strength > 0.0){
		COLOR.rgb += glow_color.rgb * glow_strength;
	}
}

