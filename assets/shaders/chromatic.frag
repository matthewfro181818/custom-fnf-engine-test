#pragma header

uniform float offset;

void main() {
    vec2 uv = openfl_TextureCoordv;

    float o = offset;

    float r = texture2D(bitmap, uv + vec2( o, 0.0)).r;
    float g = texture2D(bitmap, uv                ).g;
    float b = texture2D(bitmap, uv + vec2(-o, 0.0)).b;

    gl_FragColor = vec4(r, g, b, 1.0);
}
