class_name GameManager extends Node
static var instance: GameManager;

@export var player: Player;
@export var shaders: Array[ShaderMaterial] = [];
var unique_shaders: Array[ShaderMaterial] = [];

@export var tint_colors: Dictionary[String, Color];

var red_group: Array[MeshInstance3D] = [];
var green_group: Array[MeshInstance3D] = [];
var blue_group: Array[MeshInstance3D] = [];

@export var red_unlocked: bool = false;
@export var green_unlocked: bool = false;
@export var blue_unlocked: bool = false;

func _init() -> void:
	instance = self;

func _ready() -> void:
	for shader in shaders:
		shader.set_shader_parameter("show_default", false);
		shader.set_shader_parameter("tint", false);
		shader.set_shader_parameter("use_emission", false);
		
	for node in get_tree().get_nodes_in_group("tint_red"):
		red_group += FileUtils.get_all_mesh_instances(node)
	for node in get_tree().get_nodes_in_group("tint_green"):
		green_group += FileUtils.get_all_mesh_instances(node)
	for node in get_tree().get_nodes_in_group("tint_blue"):
		blue_group += FileUtils.get_all_mesh_instances(node)
		
	for node in red_group:
		node.set_instance_shader_parameter("tint_color", tint_colors["red"]);
		node.set_instance_shader_parameter("is_invisible", true);
	for node in green_group:
		node.set_instance_shader_parameter("tint_color", tint_colors["green"]);
		node.set_instance_shader_parameter("is_invisible", true);
	for node in blue_group:
		node.set_instance_shader_parameter("tint_color", tint_colors["blue"]);
		node.set_instance_shader_parameter("is_invisible", true);
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed(&"switch_blue") && blue_unlocked:
		tint(blue_group); 
	if Input.is_action_just_pressed(&"switch_green") && green_unlocked: 
		tint(green_group);
	if Input.is_action_just_pressed(&"switch_red") && red_unlocked: 
		tint(red_group);

func tint(meshes: Array[MeshInstance3D]) -> void:
	for mesh in meshes:
		mesh.set_instance_shader_parameter("color_mode", 2 if mesh.get_instance_shader_parameter("color_mode") == 0 else 0);
		mesh.set_instance_shader_parameter("is_invisible", false if mesh.get_instance_shader_parameter("color_mode") == 2 else true)
