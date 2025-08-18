shader_type canvas_item;

uniform float red_offset : hint_range(-0.02, 0.02) = -0.005;
uniform float blue_offset : hint_range(-0.02, 0.02) = 0.005;
uniform bool animate_offset = true;
uniform float animation_speed : hint_range(0.1, 5.0) = 2.0;
uniform float animation_strength : hint_range(0.0, 0.01) = 0.003;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

void fragment() {
    vec2 uv = SCREEN_UV;
    
    float time_factor = 1.0;
    if (animate_offset) {
        time_factor = sin(TIME * animation_speed) * animation_strength + 1.0;
    }
    
    vec2 red_shift = vec2(red_offset * time_factor, 0.0);
    vec2 blue_shift = vec2(blue_offset * time_factor, 0.0);
    
    float red_channel = texture(SCREEN_TEXTURE, uv + red_shift).r;
    float green_channel = texture(SCREEN_TEXTURE, uv).g;
    float blue_channel = texture(SCREEN_TEXTURE, uv + blue_shift).b;
    
    vec3 final_color = vec3(red_channel, green_channel, blue_channel);
    
    COLOR = vec4(final_color, 1.0);
}