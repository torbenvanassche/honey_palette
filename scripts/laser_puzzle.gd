@tool
extends Node3D

@export var beam_origin: Node3D
@export var door: Node3D
@export var door_collider: CollisionShape3D
@export var beam_mesh: MeshInstance3D
@export var recepticle: StaticBody3D
@export var puzzle_start: Interactable
@export var mirrors: Array[Rotator] = []

@export var max_bounces: int = 5
@export var max_distance: float = 1000.0
@export var laser_radius: float = 0.01

var is_started: bool = false

@export var is_solved: bool = false:
	set(value):
		is_solved = value
		if value and door and door_collider:
			door.visible = false
			door_collider.disabled = true

var last_positions: Array[Vector3] = []
var positions: Array[Vector3] = []

func _ready() -> void:
	if Engine.is_editor_hint():
		_calc_beam()
		_draw_beam()
	elif puzzle_start:
		puzzle_start.primary.connect(_trigger_puzzle_start)
	else:
		_trigger_puzzle_start()

func _trigger_puzzle_start() -> void:
	is_started = true

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		_calc_beam()
		_draw_beam()

func _physics_process(delta: float) -> void:
	if (beam_mesh.visible or is_solved) or Engine.is_editor_hint():
		_calc_beam()
		_draw_beam()

	if !Engine.is_editor_hint():
		if beam_origin and FileUtils.get_all_mesh_instances(beam_origin).size() > 0:
			var mesh_instance := FileUtils.get_all_mesh_instances(beam_origin)[0]
			beam_mesh.visible = !mesh_instance.get_instance_shader_parameter("is_invisible") and is_started

func _calc_beam() -> void:
	positions.clear()

	if !beam_origin:
		return

	var origin := beam_origin.global_position
	var direction := beam_origin.transform.basis.y.normalized()

	positions.append(origin)
	var space_state := get_world_3d().direct_space_state

	for i in max_bounces:
		var to := origin + direction * max_distance
		var ray_query := PhysicsRayQueryParameters3D.new()
		ray_query.from = origin
		ray_query.to = to
		if !Engine.is_editor_hint():
			ray_query.exclude = []  # Add actual exclusions if needed

		var result := space_state.intersect_ray(ray_query)

		if result and result.collider is StaticBody3D:
			var hit_point: Vector3 = result.position
			var hit_normal: Vector3 = result.normal
			var collider: StaticBody3D = result.collider

			positions.append(hit_point)

			if collider.is_in_group("Mirror"):
				direction = direction.bounce(hit_normal).normalized()
				origin = hit_point + direction * 0.01
			elif collider == recepticle:
				is_solved = true
				break
			else:
				break
		else:
			positions.append(to)
			break

func _draw_beam() -> void:
	if positions == last_positions:
		return

	last_positions = positions.duplicate()

	for child in beam_mesh.get_children():
		child.queue_free()

	for i in positions.size() - 1:
		var start: Vector3 = positions[i]
		var end: Vector3 = positions[i + 1]
		var segment: Node3D = _create_cylinder_between_points(start, end)
		beam_mesh.add_child(segment)
		segment.global_position = segment.get_meta("position") as Vector3

func _create_cylinder_between_points(start: Vector3, end: Vector3) -> Node3D:
	var segment := Node3D.new()

	var mesh_instance := MeshInstance3D.new()
	var cylinder_mesh := CylinderMesh.new()
	cylinder_mesh.top_radius = laser_radius
	cylinder_mesh.bottom_radius = laser_radius
	cylinder_mesh.height = start.distance_to(end)
	cylinder_mesh.radial_segments = 3
	mesh_instance.mesh = cylinder_mesh

	var mat := StandardMaterial3D.new()
	mat.emission_enabled = true
	mat.albedo_color = Color.RED
	mat.emission = Color.RED
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mesh_instance.set_surface_override_material(0, mat)

	var direction := end - start
	var midpoint := start + direction * 0.5
	segment.set_meta("position", midpoint)

	var up := Vector3.UP
	var axis := up.cross(direction.normalized())
	var angle := up.angle_to(direction.normalized())

	if axis.length() > 0:
		segment.rotation = Quaternion(axis.normalized(), angle).get_euler()

	segment.add_child(mesh_instance)
	return segment
