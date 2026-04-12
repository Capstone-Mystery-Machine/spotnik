@tool
extends Node3D

@export var target_node: Node3D

@onready var planet_mesh: MeshInstance3D = %PlanetMeshInstance3D

var _last_local_position: Vector3 = Vector3.ZERO

var _shader_material: ShaderMaterial:
	get():
		if is_node_ready() and planet_mesh:
			return planet_mesh.get_active_material(0) as ShaderMaterial
		return null


func _process(_delta: float) -> void:
	if not is_node_ready() or not _shader_material:
		return

	var surface_direction = Vector3.ZERO
	var surface_velocity = Vector3.ZERO

	if target_node and target_node.has_method("get_target_node"):
		var tracked_node: Node3D = target_node.get_target_node()

		if tracked_node:
			var local_position \
			= planet_mesh.global_transform.affine_inverse() \
			* tracked_node.global_position

			surface_direction = local_position.normalized()

			if _last_local_position != Vector3.ZERO:
				var move_delta = local_position - _last_local_position

				if move_delta.length_squared() > 0.000001:
					surface_velocity = move_delta.normalized()

			_last_local_position = local_position

	RenderingServer.material_set_param(
		_shader_material.get_rid(),
		"surface_direction",
		surface_direction,
	)

	RenderingServer.material_set_param(
		_shader_material.get_rid(),
		"surface_velocity",
		surface_velocity,
	)
