extends Node

@export var enable_lights: Array[Node3D];

func on_enable() -> void:
	for light in enable_lights:
		for l in FileUtils.get_all_mesh_instances(light):
			l.set_instance_shader_parameter("use_emission", true);
			
func execute(btn_index: int) -> bool:
	return true;
	
func success(interactable: Interactable) -> void:
	interactable.follow_up_item.can_interact = true;
	interactable.follow_up_item.force_emission();
	interactable.force_emission()
