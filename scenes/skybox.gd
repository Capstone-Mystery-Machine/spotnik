@tool
extends Node3D
## Spherical skybox with a projected with a projected panorama texture.

@export_group("Projection Settings")

## Represents how far out the skybox's `MeshInstance3D`'s `SphereMesh` is projected
## from its center of mass.
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var projection_radius: float = 1.0:
	set(value):
		projection_radius = value
		if is_node_ready():
			_update_mesh_instance_3d()

@onready var meshInstance3D: MeshInstance3D = $MeshInstance3D


## Updates the child `MeshInstance3D` node's settings based on the exported
## variables.
func _update_mesh_instance_3d():
	var sphere_mesh = meshInstance3D.mesh as SphereMesh

	if sphere_mesh:
		sphere_mesh.radius = projection_radius
		sphere_mesh.height = projection_radius * 2
		return

	push_error("bad dispatch to 'Skybox._update_mesh' ('MeshInstance3D.mesh' is not 'SphereMesh')")


func _ready() -> void:
	_update_mesh_instance_3d()
