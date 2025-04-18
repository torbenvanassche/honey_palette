extends Node

func execute(btn_index: int) -> void:
	var id: String = get_meta("id");
		
	GameManager.instance.ui.variant.image.visible = true;
	GameManager.instance.ui.variant.set_meta("id", id);
	queue_free()
