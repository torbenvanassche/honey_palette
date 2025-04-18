class_name Interactable extends UniqueShaderInstance

signal primary();
signal clicked(button_index: int);

@export var animation_player: AnimationPlayer;
@export var can_interact: bool = false: 
	set(value):
		can_interact = value;
		if can_interact && script_node && script_node.has_method("on_enable"):
			script_node.on_enable();
@export var collider: Area3D;
@export var animation_name: String = &"trigger";
@export var interactable_id: String;
@export var emission: bool = false;
@export var follow_up_item: Interactable;
@export var once: bool = false;

@export var script_node: Node;

var last_button_index: int = 0;

func _ready() -> void:
	super()
	clicked.connect(_on_click);
	if animation_player:
		animation_player.animation_finished.connect(_execute.bind(last_button_index));
	collider.set_meta("interactable", self);
	
	if script_node:
		script_node.tree_exiting.connect(queue_free)
		script_node.set_meta("id", interactable_id);
		script_node.set_meta("interactable", self);
		if script_node.has_method("on_ready"):
			script_node.on_ready();
		
	if emission:
		force_emission();
	
func _on_click(btn_index: int) -> void:
	if !can_interact:
		return;
	last_button_index = btn_index;
	if animation_player && animation_player.has_animation(animation_name) && animation_player.animation_finished.has_connections():
		animation_player.play(animation_name)
	else:
		_execute("", last_button_index);
	
func _execute(animation_name: String = "", btn_index: int = 0) -> void:
	if btn_index == 0:
		primary.emit();
	
	if script_node && script_node.has_method("execute"):
		if script_node.execute(btn_index) && script_node.has_method("success"):
			if once:
				collider.queue_free()
			script_node.success(self);
