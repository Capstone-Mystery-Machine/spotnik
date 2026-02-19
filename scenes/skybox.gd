@tool
extends Node3D
## Spherical skybox with a projected with a projected panorama texture.

@export_group("Texture Settings")

# Represents the texture that is applied to the interior of the skybox.
@export var panorama_texture: Texture2D:
	set(value):
		panorama_texture = value
		if is_node_ready():
			_update_panorama_texture()

@export_group("Projection Settings")

## Represents how far out the skybox's `MeshInstance3D`'s `SphereMesh` is projected
## from its center of mass.
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var projection_radius: float = 1.0:
	set(value):
		projection_radius = value
		if is_node_ready():
			_update_projection_radius()

@onready var meshInstance3D: MeshInstance3D = $MeshInstance3D


## Updates the child `MeshInstance3D` node's panorama texture settings based on
## the exported variable.
func _update_panorama_texture():
	var sphere_mesh = meshInstance3D.mesh as SphereMesh

	if !sphere_mesh:
		push_error("bad dispatch to 'Skybox._update_panorama_texture' (child node 'MeshInstance3D.mesh' is not 'SphereMesh')")
		return

	var material = meshInstance3D.get_active_material(0) as StandardMaterial3D

	if !material:
		push_error("bad dispatch to 'Skybox._update_panorama_texture' (child node 'MeshInstance3D.get_active_material(0)' is not 'StandardMaterial3D')")
		return

	material.albedo_texture = panorama_texture


## Updates the child `MeshInstance3D` node's projection radius settings based on
## the exported variable.
func _update_projection_radius():
	var sphere_mesh = meshInstance3D.mesh as SphereMesh

	if !sphere_mesh:
		push_error("bad dispatch to 'Skybox._update_projection_radius' (child node 'MeshInstance3D.mesh' is not 'SphereMesh')")
		return

	sphere_mesh.radius = projection_radius
	sphere_mesh.height = projection_radius * 2


func _ready() -> void:
	_update_panorama_texture()
	_update_projection_radius()
