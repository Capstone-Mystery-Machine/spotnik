@tool
extends Node3D
## Spherical skybox with a projected layered projected panorama textures via
## [MeshInstance3D] instances with [SphereMesh] meshes.

@export_group("Texture Settings")

## Represents the texture applied to the background void layer.
@export var void_texture: Texture2D:
	set(value):
		void_texture = value
		if is_node_ready():
			_update_void_texture()

## Represents the texture applied to the middle nebulae layer.
@export var nebulae_texture: Texture2D:
	set(value):
		nebulae_texture = value
		if is_node_ready():
			_update_nebulae_texture()

## Represents the texture applied to the foreground stars layer.
@export var stars_texture: Texture2D:
	set(value):
		stars_texture = value
		if is_node_ready():
			_update_stars_texture()

@export_group("Projection Settings")

## Represents how far out the skybox's `MeshInstance3D`'s `SphereMesh` is projected
## from its center of mass.
@export_range(0.0, 1000.0, 0.00001, "suffix:m") var projection_radius: float = 1.0:
	set(value):
		projection_radius = value
		if is_node_ready():
			_update_projection_radius()

## Represents the radius multiplier applied to the stars mesh layer, based on the
## projection radius.
@export_range(1.0, 2.0, 0.00001) var stars_radius_multiplier: float = 1.0125:
	set(value):
		stars_radius_multiplier = value
		if is_node_ready():
			_update_projection_radius()

## Represents the radius multiplier applied to the void mesh layer, based on the
## stars layer's computed projection radius.
@export_range(1.0, 2.0, 0.00001) var void_radius_multiplier: float = 1.0125:
	set(value):
		void_radius_multiplier = value
		if is_node_ready():
			_update_projection_radius()

@export_group("Simulation Settings")

## Represents the base rotation speed applied to the void layer.
@export_range(-0.1, 0.1, 0.00001, "suffix:rad/s") var rotation_speed: float = 0.002

## Represents the rotation speed multiplier applied to the nebulae layer, based
## on the stars layer's computed speed.
@export_range(-2.0, 2.0, 0.00001) var nebulae_speed_multiplier: float = 1.1

## Represents the rotation speed multiplier applied to the stars layer, based on
## the base rotation speed.
@export_range(-2.0, 2.0, 0.00001) var stars_speed_multiplier: float = 1.1

@onready var _void_layer_mesh: MeshInstance3D = $VoidLayerMesh
@onready var _nebulae_layer_mesh: MeshInstance3D = $NebulaeLayerMesh
@onready var _stars_layer_mesh: MeshInstance3D = $StarsLayerMesh


# Applies an exported radius setting to a child mesh layer.
func _apply_radius(mesh_instance: MeshInstance3D, radius: float, node_name: String):
	var sphere_mesh = mesh_instance.mesh as SphereMesh

	if !sphere_mesh:
		push_error(
			"bad dispatch to 'Skybox._apply_radius' (child node '" + node_name +
			".mesh' is not 'SphereMesh')",
		)
		return

	sphere_mesh.radius = radius
	sphere_mesh.height = radius * 2


# Applies an exported texture setting to a child mesh layer.
func _apply_texture(mesh_instance: MeshInstance3D, texture_2d: Texture2D, node_name: String):
	var sphere_mesh = mesh_instance.mesh as SphereMesh

	if !sphere_mesh:
		push_error(
			"bad dispatch to 'Skybox._apply_texture' (child node '" + node_name + ".mesh' "
			+ "is not 'SphereMesh')",
		)
		return

	var material = mesh_instance.get_surface_override_material(0) as StandardMaterial3D

	if !material:
		var base_material = mesh_instance.get_active_material(0) as StandardMaterial3D

		if !base_material:
			push_error(
				"bad dispatch to 'Skybox._apply_texture' (child node '" + node_name +
				".get_active_material(0)' is not 'StandardMaterial3D')",
			)
			return

		material = base_material.duplicate()
		mesh_instance.set_surface_override_material(0, material)

	if mesh_instance == _void_layer_mesh:
		material.albedo_texture = texture_2d
		return

	material.emission_texture = texture_2d


# Updates the nebulae mesh layer's texture settings based on the exported variable.
func _update_nebulae_texture():
	_apply_texture(_nebulae_layer_mesh, nebulae_texture, "NebulaeLayerMesh")


# Updates the star mesh layer's texture settings based on the exported variable.
func _update_stars_texture():
	_apply_texture(_stars_layer_mesh, stars_texture, "StarsLayerMesh")


# Updates the void mesh layer's texture settings based on the exported variable.
func _update_void_texture():
	_apply_texture(_void_layer_mesh, void_texture, "VoidLayerMesh")


## Updates the child nodes' projection radius settings based on the exported variable.
func _update_projection_radius():
	var stars_radius = projection_radius * stars_radius_multiplier
	var void_radius = stars_radius * void_radius_multiplier

	_apply_radius(_nebulae_layer_mesh, projection_radius, "NebulaeLayerMesh")
	_apply_radius(_stars_layer_mesh, stars_radius, "StarsLayerMesh")
	_apply_radius(_void_layer_mesh, void_radius, "VoidLayerMesh")


func _ready() -> void:
	_update_nebulae_texture()
	_update_stars_texture()
	_update_void_texture()
	_update_projection_radius()


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	var stars_speed = rotation_speed * stars_speed_multiplier
	var nebulae_speed = stars_speed * nebulae_speed_multiplier

	_void_layer_mesh.rotate_y(rotation_speed * delta)
	_stars_layer_mesh.rotate_y(stars_speed * delta)
	_nebulae_layer_mesh.rotate_y(nebulae_speed * delta)
