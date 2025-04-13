extends Node3D

@export var door: Node3D;
@export var beam: RayCast3D;

const MAX_BOUNCES = 5
const MAX_DISTANCE = 1000.0
