class_name UniqueShaderInstance extends Node3D

@export var tint_id: String = "UNSET";
var meshes: Array[MeshInstance3D] = [];
var enabled: bool = false;

func _ready() -> void:
	meshes = FileUtils.get_all_mesh_instances(self);
	if tint_id != "UNSET":
		self.add_to_group("tint_" + tint_id);

func force_emission() -> void:
	for mesh in meshes:
		mesh.set_instance_shader_parameter("use_emission", true)
