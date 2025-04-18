extends Node

@export var phial: MeshInstance3D;

func _ready() -> void:
	phial.visible = false;
	
func execute(btn_index: int) -> bool:
	var ui_slot := GameManager.instance.ui.variant;
	if ui_slot.has_meta("id") && ui_slot.get_meta("id") == "red_liquid_container":
		ui_slot.tint(true);
		ui_slot.remove_item();
		phial.visible = true;
		return true;
	return false;
		
func success(interactable: Interactable) -> void:
	interactable.follow_up_item.can_interact = true;
	interactable.follow_up_item.force_emission();
	interactable.force_emission()
