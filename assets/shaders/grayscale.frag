#pragma header

void main() {
    vec4 c = texture2D(bitmap, openfl_TextureCoordv);
    float g = (c.r + c.g + c.b) / 3.0;
    gl_FragColor = vec4(g, g, g, c.a);
}
