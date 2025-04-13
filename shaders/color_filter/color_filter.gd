extends Node

@export var colors: Array[Color] = [Color("#ac432f")]
@export var shaders: Array[ShaderMaterial] = [];

func _ready() -> void:
	for shader in shaders:
		shader.set_shader_parameter("use_emission", shader.get_shader_parameter("emission_texture"))
		shader.set_shader_parameter("force_texture", false)
		shader.set_shader_parameter("use_emission", false)
	apply_palette_to_shader()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed(&"switch_material_mode"): 
		toggle_textures()

func apply_palette_to_shader() -> void:
	for shader in shaders:
		shader.set_shader_parameter("filter_colors", colors)
		shader.set_shader_parameter("palette_size", colors.size())

func toggle_textures() -> void:
	for shader in shaders:
		shader.set_shader_parameter("force_texture", !shader.get_shader_parameter("force_texture"))
		shader.set_shader_parameter("use_emission", shader.get_shader_parameter("emission_texture") && shader.get_shader_parameter("force_texture"))
		shader.set_shader_parameter("tint_as_emission", !shader.get_shader_parameter("emission_texture"))
