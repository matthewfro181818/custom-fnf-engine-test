#pragma header

uniform float time;

void main() {
	vec2 uv = openfl_TextureCoordv;

	// Slight distortion
	uv.y += sin(uv.x * 40.0 + time * 6.0) * 0.003;

	// Scanlines
	float scanline = sin(uv.y * 720.0) * 0.08;

	vec4 color = texture2D(bitmap, uv);
	color -= scanline;

	gl_FragColor = color;
}
