#pragma header

uniform float strength;

void main() {
    vec2 uv = openfl_TextureCoordv;
    vec4 color = texture2D(bitmap, uv);

    float dist = distance(uv, vec2(0.5));
    float dark = smoothstep(0.3, strength + 0.3, dist);

    gl_FragColor = color * (1.0 - dark);
}
