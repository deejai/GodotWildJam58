shader_type spatial;

void fragment() {
	vec2 uv_corner = vec3(UV, 0.0).xy;
	vec3 top = mix(vec3(0.0, 0.6, 0.12), vec3(0.0, 0.5, 0.1), uv_corner.x);
	vec3 bottom = mix(vec3(0.45, 1.0, 0.0), vec3(0.6, 1.0, 0.0), uv_corner.x);
	ALBEDO = mix(top, bottom, uv_corner.y);
}
