#pragma header

uniform float strength;

void main() {
    vec2 uv = openfl_TextureCoordv;
    vec4 baseColor = texture2D(bitmap, uv);

    vec4 blur = vec4(0.0);

    float offset = 0.003 * strength;

    blur += texture2D(bitmap, uv + vec2( offset,  0.0));
    blur += texture2D(bitmap, uv + vec2(-offset,  0.0));
    blur += texture2D(bitmap, uv + vec2( 0.0,  offset));
    blur += texture2D(bitmap, uv + vec2( 0.0, -offset));

    blur /= 4.0;

    gl_FragColor = baseColor + blur * strength;
}
