@tool
extends Node3D

@export_group("Projection Settings")

@export var projection_radius: float = 1.0:
	set(value):
		projection_radius = value
		if is_node_ready():
			_update_mesh()

@onready var meshInstance3D: MeshInstance3D = $MeshInstance3D


func _update_mesh():
	var sphere_mesh = meshInstance3D.mesh as SphereMesh

	if sphere_mesh:
		sphere_mesh.radius = projection_radius
		sphere_mesh.height = projection_radius * 2
		return

	push_error("bad dispatch to 'Skybox._update_mesh' ('MeshInstance3D.mesh' is not 'SphereMesh')")


func _ready() -> void:
	_update_mesh()
