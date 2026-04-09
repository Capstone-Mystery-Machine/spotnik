@tool
extends Node3D

@export_range(0.0, 90.0) var max_polar_angle_degrees: float = 30.0

@onready var planet_mesh: MeshInstance3D = %PlanetMeshInstance3D

@onready var ping_tweener_x: TweenerX = %PingTweenerX

var _active_ping: Vector4 = Vector4.ZERO

var _shader_material: ShaderMaterial:
	get():
		if is_node_ready() and planet_mesh:
			return planet_mesh.get_active_material(0) as ShaderMaterial

		return null


func _on_tweener_progress_changed(new_progress: float, old_progress: float) -> void:
	if new_progress < old_progress:
		_refresh_ping_position()

	_active_ping.w = new_progress

	if _shader_material:
		RenderingServer.material_set_param(
			_shader_material.get_rid(),
			"ping_data",
			_active_ping,
		)


func _calculate_camera_facing_local_point(current_camera: Camera3D) -> Vector4:
	var horizontal_angle = randf() * 2.0 * PI

	var min_bias = cos(deg_to_rad(max_polar_angle_degrees))
	var vertical_bias = randf_range(min_bias, 1.0)
	var vertical_angle = acos(vertical_bias)

	var point_on_sphere = Vector3(
		sin(vertical_angle) * cos(horizontal_angle),
		sin(vertical_angle) * sin(horizontal_angle),
		cos(vertical_angle),
	)

	var world_direction = current_camera.global_transform.basis * point_on_sphere
	var local_ping_epicenter = planet_mesh.global_transform.basis.inverse() * world_direction

	return Vector4(
		local_ping_epicenter.x,
		local_ping_epicenter.y,
		local_ping_epicenter.z,
		0.0,
	)


func _refresh_ping_position() -> void:
	var camera = get_viewport().get_camera_3d()
	if camera:
		_active_ping = _calculate_camera_facing_local_point(camera)


func _ready() -> void:
	ping_tweener_x.progress_changed.connect(_on_tweener_progress_changed)

	_refresh_ping_position()
