shader_type canvas_item;

uniform float time_scale : hint_range(0.1, 2.0) = 1.0;
uniform int particle_count : hint_range(10, 50) = 25;
uniform float particle_size : hint_range(0.001, 0.02) = 0.005;
uniform float particle_speed : hint_range(0.1, 1.0) = 0.3;
uniform vec3 particle_color : source_color = vec3(0.8, 1.0, 0.9);
uniform float particle_brightness : hint_range(0.1, 1.0) = 0.5;
uniform vec3 bg_color1 : source_color = vec3(0.1, 0.6, 0.55);
uniform vec3 bg_color2 : source_color = vec3(0.05, 0.8, 0.7);
uniform float bg_noise_strength : hint_range(0.0, 0.3) = 0.1;

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

float particle(vec2 uv, vec2 pos, float size) {
    float d = length(uv - pos);
    return smoothstep(size, size * 0.1, d);
}

void fragment() {
    vec2 uv = UV;
    
    vec3 bg_color = mix(bg_color1, bg_color2, uv.y);
    
    float bg_noise = noise(uv * 3.0 + TIME * time_scale * 0.1) * bg_noise_strength;
    bg_color += bg_noise;
    
    vec3 final_color = bg_color;
    
    for(int i = 0; i < particle_count; i++) {
        float fi = float(i);
        
        float speed_variation = 0.03 + random(vec2(fi, fi + 10.0)) * particle_speed;
        float offset_x = random(vec2(fi + 5.0, fi + 15.0)) * 2.0;
        float offset_y = random(vec2(fi + 20.0, fi + 25.0)) * 2.0;
        
        vec2 pos = vec2(
            mod(offset_x + TIME * time_scale * speed_variation, 1.0),
            mod(offset_y + TIME * time_scale * speed_variation * 0.7, 1.0)
        );
        
        float size = particle_size * (0.5 + random(vec2(fi + 30.0, fi + 35.0)) * 1.0);
        
        float brightness = particle_brightness + sin(TIME * time_scale * 2.0 + fi) * 0.2;
        brightness = max(brightness, 0.1);
        
        float p = particle(uv, pos, size);
        final_color += p * particle_color * brightness;
    }
    
    for(int i = 0; i < 8; i++) {
        float fi = float(i) + 100.0;
        
        float speed_variation = 0.2 + random(vec2(fi, fi + 10.0)) * 0.3;
        float offset_x = random(vec2(fi + 5.0, fi + 15.0)) * 2.0;
        float offset_y = random(vec2(fi + 20.0, fi + 25.0)) * 2.0;
        
        vec2 pos = vec2(
            mod(offset_x + TIME * time_scale * speed_variation, 1.0),
            mod(offset_y + TIME * time_scale * speed_variation * 0.5, 1.0)
        );
        
        float size = particle_size * (1.5 + random(vec2(fi + 30.0, fi + 35.0)) * 2.0);
        float brightness = particle_brightness * 0.6 + sin(TIME * time_scale * 1.5 + fi) * 0.15;
        brightness = max(brightness, 0.05);
        
        float p = particle(uv, pos, size);
        vec3 large_particle_color = vec3(0.6, 0.9, 1.0);
        final_color += p * large_particle_color * brightness;
    }
    
    COLOR = vec4(final_color, 1.0);
}