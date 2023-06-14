shader_type spatial;

// Controls the scale of the noise function
uniform sampler2D sky_texture;

void fragment() {
	ALBEDO = texture(sky_texture, UV).rgb;
}
