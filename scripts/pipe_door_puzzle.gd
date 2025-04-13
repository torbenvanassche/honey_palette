extends Node

@export var broken_door_material: ShaderMaterial;
@export var fixed_door_material: ShaderMaterial;

@onready var door: MeshInstance3D = $SM_Bld_Door_Single_Frame_01/SM_Bld_Door_Single_01/SM_Bld_Door_Single_01_Door_01;

func _ready() -> void:
	door.set_surface_override_material(0, fixed_door_material)
	
