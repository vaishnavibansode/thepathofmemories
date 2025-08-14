shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture;
uniform vec4 water_color : source_color;
uniform sampler2D wave_noise : repeat_enable;
uniform float wave_strength = 0.03; // Controls how strong the ripples are
uniform float wave_speed = 0.05;   // Controls how fast the ripples move
uniform float reflection_strength = 0.8; // How strong the reflection appears (0.0 - 1.0)
uniform float distortion_intensity = 0.05; // How much the background is distorted by waves
uniform float edge_fade_power = 2.0; // Controls the fade at the top edge of the water

void fragment() {
    // Offset the noise sampling for a more varied look, and to break up patterns
    vec2 noise_uv = UV * 2.0; // Make the noise pattern smaller relative to UV
    vec2 water_wave_offset = (texture(wave_noise, noise_uv + TIME * wave_speed).rg - 0.5) * wave_strength;

    // Calculate the UV for sampling the screen texture
    // The Y-axis is flipped for reflection: SCREEN_UV.y - UV.y
    // The 'water_wave_offset' introduces the ripple distortion
    vec2 uv = vec2(SCREEN_UV.x, SCREEN_UV.y - UV.y * reflection_strength) + water_wave_offset * distortion_intensity;

    // Sample the background color at the calculated UV
    vec4 screen_content_color = texture(screen_texture, uv);

    // --- Reflection Blending & Depth Effect ---

    // Original mix_value based on vertical position within the CanvasItem (UV.y)
    // 1.0 at the top (UV.y=0), 0.0 at the bottom (UV.y=1)
    float base_mix_value = 1.0 - UV.y;

    // Enhance contrast of reflected content for shimmer (less prominent for deeper water)
    float avg_screen_color = (screen_content_color.r + screen_content_color.g + screen_content_color.b) / 3.0;
    avg_screen_color = pow(avg_screen_color, 1.8); // Slightly higher power for more contrast

    // Add averaged screen color to mix_value. Brighter parts reflect more clearly.
    float final_mix_factor = base_mix_value + avg_screen_color;

    // Apply edge fade: make the top edge of the water more opaque (more water_color)
    // pow(UV.y, edge_fade_power) will be close to 0 at the top (UV.y=0) and 1 at the bottom (UV.y=1)
    // 1.0 - pow(UV.y, edge_fade_power) will be 1 at the top and 0 at the bottom
    float edge_fade = 1.0 - pow(UV.y, edge_fade_power);
    final_mix_factor = clamp(final_mix_factor * edge_fade, 0.0, 1.0); // Clamp to prevent going out of bounds

    // Mix the base water color with the reflected screen content
    // Use the final_mix_factor to control the blend.
    // A higher final_mix_factor means more of the reflected screen content.
    COLOR = mix(water_color, screen_content_color, final_mix_factor);

    // Optional: Add a subtle alpha fade at the bottom of the water (if you want it to gradually disappear)
    // COLOR.a *= (1.0 - UV.y * 0.2); // Fade out by 20% towards the bottom
}