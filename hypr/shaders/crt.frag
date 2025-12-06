// The MIT License (MIT)

// Copyright (c) 2015 Wesley LaFerriere

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "GLSL-CRT"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

// EDITED FOR HYPRLAND BY: https://github.com/hyperdotbat

#ifdef GL_ES
#define LOWP lowp
    precision mediump float;
#else
    #define LOWP
#endif

#define CRT_CURVE_AMNTx 0.05
#define CRT_CURVE_AMNTy 0.05
#define SCAN_LINE_MULT 1250.0
#define CA 0.0005

uniform sampler2D tex;
varying vec2 v_texcoord;
//uniform float time;

vec4 texColor(vec2 uv) {
    float r = texture2D(tex, uv + vec2(+CA, 0.0)).r;
    float g = texture2D(tex, uv).g;
    float b = texture2D(tex, uv + vec2(-CA, 0.0)).b;
    return vec4(r, g, b, 1.0);
}

void main() {
	vec2 tc = vec2(v_texcoord.x, v_texcoord.y);

	// Distance from the center
	float dx = abs(0.5-tc.x);
	float dy = abs(0.5-tc.y);

	// Square it to smooth the edges
	dx *= dx;
	dy *= dy;

	tc.x -= 0.5;
	tc.x *= 1.0 + (dy * CRT_CURVE_AMNTx);
	tc.x += 0.5;

	tc.y -= 0.5;
	tc.y *= 1.0 + (dx * CRT_CURVE_AMNTy);
	tc.y += 0.5;

	// Get texel, and add in scanline if need be
	// vec4 cta = texture2D(tex, vec2(tc.x, tc.y));
	vec4 cta = texColor(tc);

	cta.rgb += sin(tc.y * SCAN_LINE_MULT) * 0.02;

    // moving scanline (requires damage_tracking off)
    // cta.rgb += sin(tc.y * SCAN_LINE_MULT + time * 10.0) * 0.02;
    // tc.x += sin(time * 2.0) * 0.001;

	// Cutoff
	if(tc.y > 1.0 || tc.x < 0.0 || tc.x > 1.0 || tc.y < 0.0)
		cta = vec4(0.0);

	// Apply
	gl_FragColor = cta;
}