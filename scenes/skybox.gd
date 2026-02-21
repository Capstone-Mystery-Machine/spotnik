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

@export_group("Nebulae Settings")

## Represents the texture applied to the nebulae layers.
@export var nebulae_texture: Texture2D:
	set(value):
		nebulae_texture = value
		if is_node_ready():
			_update_nebulae_materials()

@export_subgroup("Near Nebulae")

## Represents the base albedo color and transparency applied to the near nebulae layer.
@export var nebulae_near_albedo_color: Color = Color(0, 0, 0, 0.4):
	set(value):
		nebulae_near_albedo_color = value
		if is_node_ready():
			_update_nebulae_materials()

## Represents the glowing emission color applied to the near nebulae layer.
@export var nebulae_near_emission_color: Color = Color(0.05, 0.05, 0.01, 1.0):
	set(value):
		nebulae_near_emission_color = value
		if is_node_ready():
			_update_nebulae_materials()

## Represents the brightness multiplier for the emission color applied to the near
## nebulae layer.
@export var nebulae_near_emission_energy: float = 0.5:
	set(value):
		nebulae_near_emission_energy = value
		if is_node_ready():
			_update_nebulae_materials()

@export_subgroup("Mid Nebulae")

## Represents the base albedo color and transparency applied to the mid nebulae layer.
@export var nebulae_mid_albedo_color: Color = Color(0, 0, 0, 0.65):
	set(value):
		nebulae_mid_albedo_color = value
		if is_node_ready():
			_update_nebulae_materials()

## Represents the glowing emission color applied to the mid nebulae layer.
@export var nebulae_mid_emission_color: Color = Color(0.15, 0.1, 0.2, 1.0):
	set(value):
		nebulae_mid_emission_color = value
		if is_node_ready():
			_update_nebulae_materials()

## Represents the brightness multiplier for the emission color applied to the mid
## nebulae layer.
@export var nebulae_mid_emission_energy: float = 0.75:
	set(value):
		nebulae_mid_emission_energy = value
		if is_node_ready():
			_update_nebulae_materials()

@export_subgroup("Far Nebulae")

## Represents the base albedo color and transparency applied to the far nebulae layer.
@export var nebulae_far_albedo_color: Color = Color(0, 0, 0, 0.75):
	set(value):
		nebulae_far_albedo_color = value
		if is_node_ready():
			_update_nebulae_materials()

## Represents the glowing emission color applied to the far nebulae layer.
@export var nebulae_far_emission_color: Color = Color(0.01, 0.01, 0.25, 1.0):
	set(value):
		nebulae_far_emission_color = value
		if is_node_ready():
			_update_nebulae_materials()

## Represents the brightness multiplier for the emission color applied to the far
## nebulae layer.
@export var nebulae_far_emission_energy: float = 0.95:
	set(value):
		nebulae_far_emission_energy = value
		if is_node_ready():
			_update_nebulae_materials()

@export_group("Stars Settings")

@export_subgroup("Field Stars")

## Represents the texture applied to the field stars layer.
@export var stars_field_texture: Texture2D:
	set(value):
		stars_field_texture = value
		if is_node_ready():
			_update_stars_materials()

## Represents the base albedo color and transparency applied to the field stars layer.
@export var stars_field_albedo_color: Color = Color(0, 0, 0, 0.35):
	set(value):
		stars_field_albedo_color = value
		if is_node_ready():
			_update_stars_materials()

## Represents the glowing emission color applied to the field stars layer.
@export var stars_field_emission_color: Color = Color(0, 0, 0, 1.0):
	set(value):
		stars_field_emission_color = value
		if is_node_ready():
			_update_stars_materials()

## Represents the brightness multiplier for the emission color applied to the field
## stars layer.
@export var stars_field_emission_energy: float = 2.0:
	set(value):
		stars_field_emission_energy = value
		if is_node_ready():
			_update_stars_materials()

@export_subgroup("Near Stars")

## Represents the texture applied to the near stars layer.
@export var stars_near_texture: Texture2D:
	set(value):
		stars_near_texture = value
		if is_node_ready():
			_update_stars_materials()

## Represents the base albedo color and transparency applied to the near stars layer.
@export var stars_near_albedo_color: Color = Color(0, 0, 0, 0.9):
	set(value):
		stars_near_albedo_color = value
		if is_node_ready():
			_update_stars_materials()

## Represents the glowing emission color applied to the near stars layer.
@export var stars_near_emission_color: Color = Color(0, 0, 0, 1.0):
	set(value):
		stars_near_emission_color = value
		if is_node_ready():
			_update_stars_materials()

## Represents the brightness multiplier for the emission color applied to the near
## stars layer.
@export var stars_near_emission_energy: float = 2.0:
	set(value):
		stars_near_emission_energy = value
		if is_node_ready():
			_update_stars_materials()

@export_subgroup("Mid Stars")

## Represents the texture applied to the mid stars layer.
@export var stars_mid_texture: Texture2D:
	set(value):
		stars_mid_texture = value
		if is_node_ready():
			_update_stars_materials()

## Represents the base albedo color and transparency applied to the mid stars layer.
@export var stars_mid_albedo_color: Color = Color(0, 0, 0, 0.75):
	set(value):
		stars_mid_albedo_color = value
		if is_node_ready():
			_update_stars_materials()

## Represents the glowing emission color applied to the mid stars layer.
@export var stars_mid_emission_color: Color = Color(0, 0, 0, 1.0):
	set(value):
		stars_mid_emission_color = value
		if is_node_ready():
			_update_stars_materials()

## Represents the brightness multiplier for the emission color applied to the mid
## stars layer.
@export var stars_mid_emission_energy: float = 1.75:
	set(value):
		stars_mid_emission_energy = value
		if is_node_ready():
			_update_stars_materials()

@export_subgroup("Far Stars")

## Represents the texture applied to the far stars layer.
@export var stars_far_texture: Texture2D:
	set(value):
		stars_far_texture = value
		if is_node_ready():
			_update_stars_materials()

## Represents the base albedo color and transparency applied to the far stars layer.
@export var stars_far_albedo_color: Color = Color(0, 0, 0, 0.5):
	set(value):
		stars_far_albedo_color = value
		if is_node_ready():
			_update_stars_materials()

## Represents the glowing emission color applied to the far stars layer.
@export var stars_far_emission_color: Color = Color(0, 0, 0, 1.0):
	set(value):
		stars_far_emission_color = value
		if is_node_ready():
			_update_stars_materials()

## Represents the brightness multiplier for the emission color applied to the far
## stars layer.
@export var stars_far_emission_energy: float = 1.5:
	set(value):
		stars_far_emission_energy = value
		if is_node_ready():
			_update_stars_materials()

@export_group("Projection Settings")

## Represents how far out the skybox's `MeshInstance3D`'s `SphereMesh` is projected
## from its center of mass.
@export_range(0.0, 1000.0, 0.00001, "suffix:m") var projection_radius: float = 1.0:
	set(value):
		projection_radius = value
		if is_node_ready():
			_update_projection_radius()

## Represents the radius multiplier applied to the nebulae mid and far layers,
## based on the near layer's computed projection radius.
@export_range(1.0, 2.0, 0.00001) var nebulae_volume_multiplier: float = 1.1:
	set(value):
		nebulae_volume_multiplier = value
		if is_node_ready():
			_update_projection_radius()

## Represents the radius multiplier applied to the stars mesh layer, based on the
## projection radius.
@export_range(1.0, 2.0, 0.00001) var stars_radius_multiplier: float = 1.0125:
	set(value):
		stars_radius_multiplier = value
		if is_node_ready():
			_update_projection_radius()

## Represents the radius multiplier applied to the stars mid and far layers,
## based on the previous star layer's computed projection radius.
@export_range(1.0, 2.0, 0.00001) var stars_separation_multiplier: float = 1.25:
	set(value):
		stars_separation_multiplier = value
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
@export_range(-0.1, 0.1, 0.00001, "suffix:rad/s") var rotation_speed: float = 0.00025

## Represents the rotation speed multiplier applied to the stars field layer, based on
## the base rotation speed.
@export_range(-2.0, 2.0, 0.00001) var stars_field_speed_multiplier: float = 1.0

## Represents the rotation speed multiplier applied to the stars far layer, based on
## the base rotation speed.
@export_range(-2.0, 2.0, 0.00001) var stars_far_speed_multiplier: float = 1.0

## Represents the rotation speed multiplier applied to the stars mid layer, based on
## the stars far layer's computed speed.
@export_range(-2.0, 2.0, 0.00001) var stars_mid_speed_multiplier: float = 1.005

## Represents the rotation speed multiplier applied to the stars near layer, based on
## the stars mid layer's computed speed.
@export_range(-2.0, 2.0, 0.00001) var stars_near_speed_multiplier: float = 1.01

## Represents the rotation speed multiplier applied to the nebulae layers, based
## on the stars layer's computed speed.
@export_range(-2.0, 2.0, 0.00001) var nebulae_speed_multiplier: float = 0.99

@export_group("Twinkle Settings")

@export_subgroup("Near Stars")

## Represents the intensity of the twinkle effect applied to the near stars layer.
@export_range(0.0, 1.0, 0.001) var stars_near_twinkle_intensity: float = 0.3:
	set(value):
		stars_near_twinkle_intensity = value
		if is_node_ready():
			_update_stars_materials()

## Represents the spatial density of the twinkle pattern on the near stars layer.
## Higher values make stars twinkle independently.
@export_range(0.0, 5000.0, 1.0) var stars_near_twinkle_frequency: float = 800.0:
	set(value):
		stars_near_twinkle_frequency = value
		if is_node_ready():
			_update_stars_materials()

## Represents the pulsing speed of the twinkle effect on the near stars layer.
@export_range(0.0, 20.0, 0.001) var stars_near_twinkle_speed: float = 2.0:
	set(value):
		stars_near_twinkle_speed = value
		if is_node_ready():
			_update_stars_materials()

@export_subgroup("Mid Stars")

## Represents the intensity of the twinkle effect applied to the mid stars layer.
@export_range(0.0, 1.0, 0.001) var stars_mid_twinkle_intensity: float = 0.6:
	set(value):
		stars_mid_twinkle_intensity = value
		if is_node_ready():
			_update_stars_materials()

## Represents the spatial density of the twinkle pattern on the mid stars layer.
## Higher values make stars twinkle independently.
@export_range(0.0, 5000.0, 1.0) var stars_mid_twinkle_frequency: float = 1500.0:
	set(value):
		stars_mid_twinkle_frequency = value
		if is_node_ready():
			_update_stars_materials()

## Represents the pulsing speed of the twinkle effect on the mid stars layer.
@export_range(0.0, 20.0, 0.001) var stars_mid_twinkle_speed: float = 2.0:
	set(value):
		stars_mid_twinkle_speed = value
		if is_node_ready():
			_update_stars_materials()

@export_subgroup("Far Stars")

## Represents the intensity of the twinkle effect applied to the far stars layer.
@export_range(0.0, 1.0, 0.001) var stars_far_twinkle_intensity: float = 0.9:
	set(value):
		stars_far_twinkle_intensity = value
		if is_node_ready():
			_update_stars_materials()

## Represents the spatial density of the twinkle pattern on the far stars layer.
## Higher values make stars twinkle independently.
@export_range(0.0, 5000.0, 1.0) var stars_far_twinkle_frequency: float = 2500.0:
	set(value):
		stars_far_twinkle_frequency = value
		if is_node_ready():
			_update_stars_materials()

## Represents the pulsing speed of the twinkle effect on the far stars layer.
@export_range(0.0, 20.0, 0.001) var stars_far_twinkle_speed: float = 4.0:
	set(value):
		stars_far_twinkle_speed = value
		if is_node_ready():
			_update_stars_materials()

@onready var _void_layer_mesh: MeshInstance3D = $VoidLayerMesh
@onready var _stars_layer_field_mesh: MeshInstance3D = $StarsLayerFieldMesh
@onready var _stars_layer_far_mesh: MeshInstance3D = $StarsLayerFarMesh
@onready var _stars_layer_mid_mesh: MeshInstance3D = $StarsLayerMidMesh
@onready var _stars_layer_near_mesh: MeshInstance3D = $StarsLayerNearMesh
@onready var _nebulae_layer_near_mesh: MeshInstance3D = $NebulaeLayerNearMesh
@onready var _nebulae_layer_mid_mesh: MeshInstance3D = $NebulaeLayerNearMesh/NebulaeLayerMidMesh
@onready var _nebulae_layer_far_mesh: MeshInstance3D = $NebulaeLayerNearMesh/NebulaeLayerFarMesh


# Applies an exported radius setting to a child mesh layer.
func _apply_radius(mesh_instance: MeshInstance3D, radius: float, node_name: String):
	var sphere_mesh = mesh_instance.mesh as SphereMesh

	if !sphere_mesh:
		push_error(
			"bad dispatch to 'Skybox._apply_radius' (child node '" + node_name +
			".mesh' is not 'SphereMesh')",
		)
		return

	if sphere_mesh.resource_path != "":
		sphere_mesh = sphere_mesh.duplicate()
		mesh_instance.mesh = sphere_mesh

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

	var material = sphere_mesh.material

	if !material:
		push_error(
			"bad dispatch to 'Skybox._apply_texture' (child node '" + node_name +
			".mesh.material' is empty)",
		)
		return

	if material.resource_path != "":
		material = material.duplicate()
		sphere_mesh.material = material

	if material is StandardMaterial3D:
		material.albedo_texture = texture_2d
		if mesh_instance != _void_layer_mesh:
			material.emission_texture = texture_2d

	elif material is ShaderMaterial:
		material.set_shader_parameter("texture_albedo", texture_2d)
		material.set_shader_parameter("texture_emission", texture_2d)


# Applies exported settings to the field star shaders.
func _apply_field_material(
		mesh_instance: MeshInstance3D,
		texture_2d: Texture2D,
		albedo: Color,
		emission: Color,
		energy: float,
		node_name: String,
):
	_apply_texture(mesh_instance, texture_2d, node_name)

	var material = mesh_instance.mesh.material

	if material is ShaderMaterial:
		material.set_shader_parameter("albedo", albedo)
		material.set_shader_parameter("emission", emission)
		material.set_shader_parameter("emission_energy", energy)


# Applies exported settings to the nebulae shaders.
func _apply_nebulae_material(
		mesh_instance: MeshInstance3D,
		texture_2d: Texture2D,
		albedo: Color,
		emission: Color,
		energy: float,
		node_name: String,
):
	_apply_texture(mesh_instance, texture_2d, node_name)

	var material = mesh_instance.mesh.material

	if material is ShaderMaterial:
		material.set_shader_parameter("albedo", albedo)
		material.set_shader_parameter("emission", emission)
		material.set_shader_parameter("emission_energy", energy)


# Applies exported settings to the star shaders.
func _apply_star_material(
		mesh_instance: MeshInstance3D,
		texture_2d: Texture2D,
		albedo: Color,
		emission: Color,
		energy: float,
		twinkle_frequency: float,
		twinkle_intensity: float,
		twinkle_speed: float,
		node_name: String,
):
	_apply_texture(mesh_instance, texture_2d, node_name)

	var material = mesh_instance.mesh.material

	if material is ShaderMaterial:
		material.set_shader_parameter("albedo", albedo)
		material.set_shader_parameter("emission", emission)
		material.set_shader_parameter("emission_energy", energy)
		material.set_shader_parameter("twinkle_frequency", twinkle_frequency)
		material.set_shader_parameter("twinkle_intensity", twinkle_intensity)
		material.set_shader_parameter("twinkle_speed", twinkle_speed)


# Updates the nebulae mesh layer's materials based on the exported variables.
func _update_nebulae_materials():
	_apply_nebulae_material(
		_nebulae_layer_near_mesh,
		nebulae_texture,
		nebulae_near_albedo_color,
		nebulae_near_emission_color,
		nebulae_near_emission_energy,
		"NebulaeLayerNearMesh",
	)

	_apply_nebulae_material(
		_nebulae_layer_mid_mesh,
		nebulae_texture,
		nebulae_mid_albedo_color,
		nebulae_mid_emission_color,
		nebulae_mid_emission_energy,
		"NebulaeLayerMidMesh",
	)

	_apply_nebulae_material(
		_nebulae_layer_far_mesh,
		nebulae_texture,
		nebulae_far_albedo_color,
		nebulae_far_emission_color,
		nebulae_far_emission_energy,
		"NebulaeLayerFarMesh",
	)


# Updates the star mesh layer's materials based on the exported variables.
func _update_stars_materials():
	_apply_star_material(
		_stars_layer_near_mesh,
		stars_near_texture,
		stars_near_albedo_color,
		stars_near_emission_color,
		stars_near_emission_energy,
		stars_near_twinkle_frequency,
		stars_near_twinkle_intensity,
		stars_near_twinkle_speed,
		"StarsLayerNearMesh",
	)

	_apply_star_material(
		_stars_layer_mid_mesh,
		stars_mid_texture,
		stars_mid_albedo_color,
		stars_mid_emission_color,
		stars_mid_emission_energy,
		stars_mid_twinkle_frequency,
		stars_mid_twinkle_intensity,
		stars_mid_twinkle_speed,
		"StarsLayerMidMesh",
	)

	_apply_star_material(
		_stars_layer_far_mesh,
		stars_far_texture,
		stars_far_albedo_color,
		stars_far_emission_color,
		stars_far_emission_energy,
		stars_far_twinkle_frequency,
		stars_far_twinkle_intensity,
		stars_far_twinkle_speed,
		"StarsLayerFarMesh",
	)

	_apply_field_material(
		_stars_layer_field_mesh,
		stars_field_texture,
		stars_field_albedo_color,
		stars_field_emission_color,
		stars_field_emission_energy,
		"StarsLayerFieldMesh",
	)


# Updates the void mesh layer's texture settings based on the exported variable.
func _update_void_texture():
	_apply_texture(_void_layer_mesh, void_texture, "VoidLayerMesh")


## Updates the child nodes' projection radius settings based on the exported variable.
func _update_projection_radius():
	var nebulae_mid_radius = projection_radius * nebulae_volume_multiplier
	var nebulae_far_radius = nebulae_mid_radius * nebulae_volume_multiplier

	var stars_near_radius = nebulae_far_radius * stars_radius_multiplier
	var stars_mid_radius = stars_near_radius * stars_separation_multiplier
	var stars_far_radius = stars_mid_radius * stars_separation_multiplier
	var stars_field_radius = stars_far_radius * stars_separation_multiplier

	var void_radius = stars_field_radius * void_radius_multiplier

	_apply_radius(_nebulae_layer_near_mesh, projection_radius, "NebulaeLayerNearMesh")
	_apply_radius(_nebulae_layer_mid_mesh, nebulae_mid_radius, "NebulaeLayerMidMesh")
	_apply_radius(_nebulae_layer_far_mesh, nebulae_far_radius, "NebulaeLayerFarMesh")

	_apply_radius(_stars_layer_near_mesh, stars_near_radius, "StarsLayerNearMesh")
	_apply_radius(_stars_layer_mid_mesh, stars_mid_radius, "StarsLayerMidMesh")
	_apply_radius(_stars_layer_far_mesh, stars_far_radius, "StarsLayerFarMesh")
	_apply_radius(_stars_layer_field_mesh, stars_field_radius, "StarsLayerFieldMesh")

	_apply_radius(_void_layer_mesh, void_radius, "VoidLayerMesh")


func _ready() -> void:
	_update_nebulae_materials()
	_update_stars_materials()
	_update_void_texture()
	_update_projection_radius()


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	var stars_field_speed = rotation_speed * stars_field_speed_multiplier
	var stars_far_speed = stars_field_speed * stars_far_speed_multiplier
	var stars_mid_speed = stars_far_speed * stars_mid_speed_multiplier
	var stars_near_speed = stars_mid_speed * stars_near_speed_multiplier
	var nebulae_speed = stars_near_speed * nebulae_speed_multiplier

	_void_layer_mesh.rotate_y(rotation_speed * delta)
	_stars_layer_field_mesh.rotate_y(stars_field_speed * delta)
	_stars_layer_far_mesh.rotate_y(stars_far_speed * delta)
	_stars_layer_mid_mesh.rotate_y(stars_mid_speed * delta)
	_stars_layer_near_mesh.rotate_y(stars_near_speed * delta)
	_nebulae_layer_near_mesh.rotate_y(nebulae_speed * delta)
