extends Node

@export var colors: Array[Color] = [Color("#ac432f")]
@export var shaders: Array[ShaderMaterial] = [];

func _ready() -> void:	
	#colors = FileUtils.get_colors_from_palette(shader_material.get_shader_parameter("albedo_texture"), 4, 8);
	apply_palette_to_shader()

func apply_palette_to_shader() -> void:
	for shader in shaders:
		shader.set_shader_parameter("filter_colors", colors)
		shader.set_shader_parameter("palette_size", colors.size())

func toggle_textures() -> void:
	for shader in shaders:
		shader.set_shader_parameter("force_texture", !shader.get_shader_parameter("force_texture"))
