extends Node

func on_enable() -> void:
	var interactable: Interactable = get_meta("interactable");
	for mesh in interactable.meshes:
		mesh.visible = true;
		
	var connected := interactable.animation_player.get_signal_connection_list("animation_finished")
	for conn in connected:
		if conn.callable.is_valid():
			interactable.animation_player.disconnect("animation_finished", conn.callable)
	interactable.animation_player.play(interactable.animation_name);

func execute(btn_index: int) -> bool:
	var id: String = get_meta("id");
		
	GameManager.instance.ui.red.image.visible = true;
	GameManager.instance.ui.red.set_meta("id", id);
	GameManager.instance.red_unlocked = true;
	queue_free()
	return true
