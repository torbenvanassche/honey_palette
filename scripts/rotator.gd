extends Node3D

@onready var body: StaticBody3D = $StaticBody3D;
@export var rotate_increments: float = 1;
@export var rotation_axis: Vector3 = Vector3.UP;
signal rotated();

func _ready() -> void:
	body.add_to_group(&"Mirror")
	
func _physics_process(delta: float) -> void:
	self.rotate(rotation_axis, deg_to_rad(rotate_increments));
	rotated.emit();
