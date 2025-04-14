extends Node3D

@export var beam_origin: Node3D;
@export var door: Node3D;
@export var beam_mesh: MeshInstance3D;
@export var recepticle: StaticBody3D; 

@export var mirrors: Array[MeshInstance3D] = [];

@export var max_bounces: int = 5;
@export var max_distance: float= 1000.0;
@export var laser_radius: float = 0.01;

var positions: Array[Vector3] = []

func _ready() -> void:	
	_draw();
	for mirror in mirrors:
		mirror.rotated.connect(_draw)
		
func _draw() -> void:
	_calc_beam()
	_draw_beam()

func _calc_beam() -> void:
	positions.clear()
	
	var origin := beam_origin.global_position
	var direction := beam_origin.transform.basis.y.normalized()
	
	positions.append(origin)
	
	var space_state := get_world_3d().direct_space_state
	
	for i in max_bounces:
		var to := origin + direction * max_distance
		var ray_query := PhysicsRayQueryParameters3D.new()
		ray_query.from = origin;
		ray_query.to = to;
		
		var result := space_state.intersect_ray(ray_query)
		
		if result && result.collider is StaticBody3D:
			var hit_point: Vector3 = result.position
			var hit_normal: Vector3 = result.normal
			var collider: StaticBody3D = result.collider
			
			positions.append(hit_point)
			
			if collider.is_in_group("Mirror"):
				direction = direction.bounce(hit_normal).normalized()
				origin = hit_point + direction * 0.01
			elif collider == recepticle:
				print("SOLVED")
			else:
				break
		else:
			positions.append(to)
			break
	
func _draw_beam() -> void:
	for child in beam_mesh.get_children():
		child.queue_free()

	for i in positions.size() - 1:
		var start: Vector3 = positions[i]
		var end: Vector3 = positions[i + 1]
		var segment: Node3D = _create_cylinder_between_points(start, end)
		beam_mesh.add_child(segment)
		segment.global_position = segment.get_meta("position") as Vector3;

func _create_cylinder_between_points(start: Vector3, end: Vector3) -> Node3D:
	var segment := Node3D.new()

	var mesh_instance := MeshInstance3D.new()
	var cylinder_mesh := CylinderMesh.new()
	cylinder_mesh.top_radius = laser_radius
	cylinder_mesh.bottom_radius = laser_radius
	cylinder_mesh.height = start.distance_to(end)
	cylinder_mesh.radial_segments = 3
	mesh_instance.mesh = cylinder_mesh

	# Material setup
	var mat := StandardMaterial3D.new()
	mat.emission_enabled = true
	mat.albedo_color = Color.RED
	mat.emission = Color.RED
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mesh_instance.set_surface_override_material(0, mat)

	# Positioning
	var direction := end - start
	var midpoint := start + direction * 0.5
	segment.set_meta("position", midpoint);
	
	var up := Vector3.UP
	var axis := up.cross(direction.normalized())
	var angle := up.angle_to(direction.normalized())

	if axis.length() > 0:
		segment.rotation = Quaternion(axis.normalized(), angle).get_euler()

	segment.add_child(mesh_instance)
	return segment
