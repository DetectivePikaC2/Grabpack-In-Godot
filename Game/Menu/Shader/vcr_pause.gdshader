/* License CC BY-NC-SA 4.0 Deed */
/* https://creativecommons.org/licenses/by-nc-sa/4.0/ */
/* Fork of Ryk's VCR distortion shader */
/* https://www.shadertoy.com/view/ldjGzV */

shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture, filter_linear_mipmap, repeat_disable;

group_uniforms Image;
uniform float curvature: hint_range(0., 10., .01) = 2.;
uniform float skip: hint_range(0., 1., .01) = 1.;
uniform float image_flicker: hint_range(0., 1., .01) = 1.;

group_uniforms Vignette;
uniform float vignette_flicker_speed: hint_range(0., 2., .01) = 1.;
uniform float vignette_strength: hint_range(0., 2., 0.01) = 1.;

group_uniforms Scanlines;
uniform float small_scanlines_speed: hint_range(0., 10., .01) = 1.;
uniform float small_scanlines_proximity: hint_range(.01, 2., .01) = 1.;
uniform float small_scanlines_opacity: hint_range(0.01, 5., .01) = 1.;
uniform float scanlines_opacity: hint_range(0., 2., .01) = 1.;
uniform float scanlines_speed: hint_range(0., 5., .01) = 1.;
uniform float scanline_thickness: hint_range(0., .6, .01) = 0.5;
uniform float scanlines_spacing: hint_range(0.3, 3., .01) = 1.;

group_uniforms Noise;
uniform sampler2D noise_texture: filter_linear_mipmap, repeat_enable;

float noise(vec2 p, vec2 uv)
{
	float s = texture(noise_texture,vec2(1.*TIME,2.*TIME)*8. + p*1.).x;
	s *= s;
	return s;
}

float onOff(float a, float b, float c)
{
	return step(c, sin(TIME + a*cos(TIME*b)));
}

float ramp(float y, float start, float end)
{
	float inside = step(start,y) - step(end,y);
	float fact = (y-start)/(end-start)*inside;
	return (1.-fact) * inside;
}

float stripes(vec2 uv)
{
	float noi = noise(uv*vec2(0.5,1.) + vec2(1.,3.), uv)*scanlines_opacity;
	return ramp(mod(uv.y*4.*scanlines_spacing + TIME*scanlines_speed/(2.*scanlines_spacing)+sin(TIME*scanlines_speed + sin(TIME*scanlines_speed*0.63*scanlines_spacing)),1.),scanline_thickness,.6)*noi;
}

vec3 getVideo(vec2 uv)
{
	vec2 look = uv;
	float window = 1./(1.+20.*(look.y-mod(TIME/4.,1.))*(look.y-mod(TIME/4.,1.)))*image_flicker;
	look.x = look.x + sin(look.y*10. + TIME)/50.*onOff(4.,4.,.3)*(1.+cos(TIME*80.))*window;
	float vShift = 0.4*onOff(2.,3.,.9)*(sin(TIME)*sin(TIME*20.)+(0.5 + 0.1*sin(TIME*200.)*cos(TIME)))*skip;
	look.y = mod(look.y + vShift, 1.);
	vec3 video = texture(screen_texture,look).xyz;
	return video;
}

vec2 screenDistort(vec2 uv)
{
	uv -= vec2(.5,.5);
	uv = uv*1.2*(1./1.2+curvature*uv.x*uv.x*uv.y*uv.y);
	uv += vec2(.5,.5);
	return uv;
}

void fragment()
{
	vec2 uv = FRAGCOORD.xy / (1.0 / SCREEN_PIXEL_SIZE).xy;
	uv = screenDistort(uv);
	vec3 video = getVideo(uv);
	float vigAmt = 3.+.3*sin(TIME*vignette_flicker_speed+1. + 5.*cos(TIME*5.*vignette_flicker_speed+1.));
	vigAmt *= vignette_strength;
	float vignette = (1.-vigAmt*(uv.y-.5)*(uv.y-.5))*(1.-vigAmt*(uv.x-.5)*(uv.x-.5));

	video += stripes(uv);
	video += noise(uv*2., uv)/2.;
	video *= vignette;
	video *= (12./small_scanlines_opacity+mod(uv.y*30.*small_scanlines_proximity+TIME*small_scanlines_speed,1.))/13.*small_scanlines_opacity;

	COLOR = vec4(video,1.0);
}