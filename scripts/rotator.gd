class_name Rotator extends Node3D

@onready var body: StaticBody3D = $SM_Prop_Satellite_01/SM_Prop_Satellite_01_Arm_01/SM_Prop_Satellite_01_Dish_01/StaticBody3D;
@onready var rotator: Node3D = $SM_Prop_Satellite_01/SM_Prop_Satellite_01_Arm_01/SM_Prop_Satellite_01_Dish_01;
@onready var clickable: Interactable = $SM_Prop_Satellite_01/SM_Prop_Satellite_01_Arm_01/SM_Prop_Satellite_01_Dish_01/Area3D;

@export var rotate_increments: float = 45;
@export var rotation_axis: Vector3 = Vector3.UP;
signal rotated();

func _ready() -> void:
	body.add_to_group(&"Mirror")
	clickable.primary.connect(_rotate);
	
	var rand_increments: int = randi_range(1, int(360 / rotate_increments) - 2)
	rotator.rotate(rotation_axis, deg_to_rad(rotate_increments * rand_increments))
	
func _rotate() -> void:
	rotator.rotate(rotation_axis, deg_to_rad(rotate_increments));
	rotated.emit();
