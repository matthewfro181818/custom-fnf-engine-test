#pragma header

void main() {
    vec4 c = texture2D(bitmap, openfl_TextureCoordv);
    gl_FragColor = vec4(1.0 - c.rgb, c.a);
}
