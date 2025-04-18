class_name InventorySlot extends Node

@onready var image: TextureRect = $TextureRect;
@onready var text: Label = $TextureRect2/Label;

@export var tex: Texture2D;
@export var mask: Texture2D;
@export var color: Color = Color.WHITE;
@export var keybind: String;

var shader_material: ShaderMaterial;

func _ready() -> void:
	shader_material = (image.material as ShaderMaterial)
	shader_material.set_shader_parameter("base_texture", tex);
	shader_material.set_shader_parameter("mask_texture", mask);
	text.text = keybind;
	image.visible = false;
	
func tint(b: bool) -> void:
	shader_material.set_shader_parameter("tint_color", color if b else Color.WHITE_SMOKE);
	
func has_item() -> bool:
	return image.visible;
	
func remove_item() -> void:
	image.visible = false;
	remove_meta("id");
