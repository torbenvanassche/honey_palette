extends Node

@export var is_locked: bool = false;

@export var material_locked: ShaderMaterial;
@export var material_open: ShaderMaterial;
var door_mesh: MeshInstance3D;

func _ready() -> void:
	door_mesh = FileUtils.get_all_mesh_instances($SM_Bld_Base_Wall_Door_01/SM_Bld_Door_Single_Frame_01/SM_Bld_Door_Single_01)[0];
	door_mesh.mesh.surface_set_material(0, material_locked if is_locked else material_open);
