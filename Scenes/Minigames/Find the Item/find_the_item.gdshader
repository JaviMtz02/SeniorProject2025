shader_type canvas_item;

uniform vec2 light_position;
uniform float light_radius = 100.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = SCREEN_UV * vec2(SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y, 1.0);
	float dist = distance(uv, light_position);
	float mask = smoothstep(light_radius, light_radius - 10.0, dist);
	COLOR = vec4(vec3(0.0), 1.0 - mask);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
