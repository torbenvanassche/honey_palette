class_name GameManager extends Node
static var instance: GameManager;

@export var player: Player;

func _ready() -> void:
	instance = self;
