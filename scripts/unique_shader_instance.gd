class_name UniqueShaderInstance extends Node3D

@export var tint_id: String = "UNSET";
var meshes: Array[MeshInstance3D] = [];
var enabled: bool = false;

func _ready() -> void:	
	meshes = FileUtils.get_all_mesh_instances(self);
	self.add_to_group("tint_" + tint_id);
