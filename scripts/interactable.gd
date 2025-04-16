class_name Interactable extends UniqueShaderInstance

signal primary();
signal clicked(button_index: int);

@export var animation_player: AnimationPlayer;
@export var collider: Area3D;
@export var animation_name: String = &"trigger";
@export var once: bool;

var last_button_index: int = 0;

func _ready() -> void:
	super()
	clicked.connect(_on_click, ConnectFlags.CONNECT_ONE_SHOT if once else 0);
	if animation_player:
		animation_player.animation_finished.connect(_execute.bind(last_button_index));
	collider.set_meta("interactable", self);
	
func _on_click(btn_index: int) -> void:
	last_button_index = btn_index;
	if animation_player:
		animation_player.play(animation_name)
	else:
		_execute("", last_button_index);
	
func _execute(animation_name: String = "", btn_index: int = 0) -> void:
	if btn_index == 0:
		primary.emit();
		
	if once:
		for c in collider.get_children(false):
			if c is CollisionShape3D:
				c.disabled = true;
