// grayscale.frag
// grayscale with 0.8 intensity
#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D tex;
varying vec2 v_texcoord;

void main() {
    vec4 color = texture2D(tex, v_texcoord);
    float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    vec3 finalColor = mix(color.rgb, vec3(gray), 0.8);
    gl_FragColor = vec4(finalColor, color.a);
}

