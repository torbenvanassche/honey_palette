shader_type canvas_item;

uniform sampler2D base_texture : source_color;
uniform sampler2D mask_texture : hint_default_white;
uniform vec4 tint_color : source_color = vec4(1.0, 0.2, 0.2, 1.0); // red tint by default
uniform float base_color_mix : hint_range(0.0, 1.0) = 0.0; // 0 = grayscale + tint, 1 = original color + tint

void fragment() {
    vec4 tex_color = texture(base_texture, UV);
    vec4 mask = texture(mask_texture, UV);

    // Grayscale conversion
    float gray = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));
    vec3 grayscale = vec3(gray);

    // Base between grayscale and original texture color
    vec3 base_mixed = mix(grayscale, tex_color.rgb, base_color_mix);

    // Mix tint color over the base_mixed using mask.r
    vec3 colorized = mix(base_mixed, tint_color.rgb, mask.r);

    // Final alpha blended using the mask
    float final_alpha = mix(tex_color.a, tint_color.a, mask.r);

    COLOR = vec4(colorized, final_alpha);
}
