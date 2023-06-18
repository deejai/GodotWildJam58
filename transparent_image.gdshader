shader_type spatial;

// Controls the scale of the noise function
uniform sampler2D image;

void fragment() {
	ALBEDO = texture(image, UV).rgb;
	ALPHA = texture(image, UV).a;
}
