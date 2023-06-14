shader_type spatial;

// Controls the scale of the noise function
uniform sampler2D ground_texture;
uniform sampler2D noise;

void fragment() {
	ALBEDO = texture(ground_texture, -UV).rgb;
}

void vertex() {
  vec2 uv = VERTEX.xy / 2.0 + 0.5;
  float height = 0.015 * texture(noise, uv).x;

  // Calculate distance from the center.
  float dist = distance(uv, vec2(0.5, 0.5));

  // Adjust edgeSmooth for a steeper falloff towards the edges.
  // The third parameter controls the sharpness of the falloff.
  float edgeSmooth = pow(1.0 - dist, 3.0); // Adjust power for desired falloff

  // Apply the factor to the height.
  VERTEX.z += height * edgeSmooth;
}
