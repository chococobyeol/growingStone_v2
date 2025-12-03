shader_type canvas_item;

uniform vec3 base_color : source_color = vec3(0.4, 0.4, 0.45);
uniform vec3 accent_color : source_color = vec3(0.6, 0.5, 0.3);
uniform float roughness : hint_range(0.0, 1.0) = 0.5;

float random (vec2 uv) {
    return fract(sin(dot(uv.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise (vec2 uv) {
    vec2 i = floor(uv);
    vec2 f = fract(uv);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void fragment() {
    vec2 center = vec2(0.5, 0.5);
    float dist = distance(UV, center);
    
    if (dist > 0.45) {
        COLOR.a = 0.0;
    } else {
        float n = noise(UV * (5.0 + roughness * 10.0));
        vec3 final_color = mix(base_color, accent_color, n * roughness);
        float shadow = smoothstep(0.45, 0.2, dist); 
        COLOR.rgb = final_color * shadow;
        COLOR.a = 1.0;
    }
}