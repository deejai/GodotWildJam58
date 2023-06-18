shader_type spatial;

uniform vec3 color = vec3(0.5, 0.5, 0.5);
uniform float alpha = 1.0;
uniform float progress = 0.5;

void fragment() {
	if(1.0 - UV.y <= progress) {
		ALBEDO = color;
		ALPHA = alpha;
	}
	else {
		ALPHA = 0.15;
	}
}
