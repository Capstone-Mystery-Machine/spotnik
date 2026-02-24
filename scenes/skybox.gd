@tool
extends Node3D
## Spherical skybox with a projected layered projected panorama textures via
## [MeshInstance3D] instances with [SphereMesh] meshes.

@export_group("Materials Settings")

@export_subgroup("Void Settings")

## Represents the texture applied to the background void layer.
@export var void_texture: Texture2D:
	set(value):
		void_texture = value
		if is_node_ready():
			_update_void_texture()

@export_subgroup("Nebulae Settings")

## Represents the texture applied to the nebulae layers.
@export var nebulae_texture: Texture2D:
	set(value):
		nebulae_texture = value
		if is_node_ready():
			_update_nebulae_materials()

## Represents the material settings applied to the near nebulae layer.
@export var nebulae_near_material: SkyboxLayerMaterial = SkyboxLayerMaterial.new(
	Color(0, 0, 0, 0.4),
	Color(0.05, 0.05, 0.01, 1.0),
	0.5,
)

## Represents the material settings applied to the mid nebulae layer.
@export var nebulae_mid_material: SkyboxLayerMaterial = SkyboxLayerMaterial.new(
	Color(0, 0, 0, 0.65),
	Color(0.15, 0.1, 0.2, 1.0),
	0.75,
)

## Represents the material settings applied to the far nebulae layer.
@export var nebulae_far_material: SkyboxLayerMaterial = SkyboxLayerMaterial.new(
	Color(0, 0, 0, 0.75),
	Color(0.01, 0.01, 0.25, 1.0),
	0.95,
)

@export_subgroup("Stars Settings")

## Represents the texture applied to the near stars layer.
@export var stars_point_texture: NoiseTexture2D:
	set(value):
		stars_point_texture = value
		if is_node_ready():
			_update_stars_point_materials()

## Represents the texture applied to the field stars layer.
@export var stars_field_texture: Texture2D:
	set(value):
		stars_field_texture = value
		if is_node_ready():
			_update_stars_point_materials()

## Represents the material settings applied to the near stars layer.
@export var stars_point_near_material: SkyboxLayerMaterial = SkyboxLayerMaterial.new(
	Color(0, 0, 0, 0.9),
	Color(0, 0, 0, 1.0),
	2.0,
)

## Represents the material settings applied to the mid stars layer.
@export var stars_point_mid_material: SkyboxLayerMaterial = SkyboxLayerMaterial.new(
	Color(0, 0, 0, 0.75),
	Color(0, 0, 0, 1.0),
	1.75,
)

## Represents the material settings applied to the far stars layer.
@export var stars_point_far_material: SkyboxLayerMaterial = SkyboxLayerMaterial.new(
	Color(0, 0, 0, 0.5),
	Color(0, 0, 0, 1.0),
	1.5,
)

## Represents the material settings applied to the field stars layer.
@export var stars_field_material: SkyboxLayerMaterial = SkyboxLayerMaterial.new(
	Color(0, 0, 0, 0.6),
	Color(0.15, 0.15, 0.15, 1.0),
	2.0,
)

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
@export_range(-2.0, 2.0, 0.00001) var stars_point_far_speed_multiplier: float = 1.0

## Represents the rotation speed multiplier applied to the stars mid layer, based on
## the stars far layer's computed speed.
@export_range(-2.0, 2.0, 0.00001) var stars_point_mid_speed_multiplier: float = 1.005

## Represents the rotation speed multiplier applied to the stars near layer, based on
## the stars mid layer's computed speed.
@export_range(-2.0, 2.0, 0.00001) var stars_point_near_speed_multiplier: float = 1.01

## Represents the rotation speed multiplier applied to the nebulae layers, based
## on the stars layer's computed speed.
@export_range(-2.0, 2.0, 0.00001) var nebulae_speed_multiplier: float = 0.99

@export_group("Nebulae Effects Settings")

## Represents how much of the nebulae opacity is removed by the carving noise.
@export_range(0.0, 1.0, 0.01) var nebulae_carving_intensity: float = 0.65:
	set(value):
		nebulae_carving_intensity = value
		if is_node_ready():
			_update_nebulae_materials()

## Represents the 3D noise texture used to carve out the nebulae volume.
@export var nebulae_carving_noise_texture: Texture3D:
	set(value):
		nebulae_carving_noise_texture = value
		if is_node_ready():
			_update_nebulae_materials()

## Represents the size of the noise pattern used for carving.
@export var nebulae_carving_scale: float = 2.5:
	set(value):
		nebulae_carving_scale = value
		if is_node_ready():
			_update_nebulae_materials()

## Represents how fast the 3D noise moves to carve out the nebulae.
@export var nebulae_carving_speed: float = 0.08:
	set(value):
		nebulae_carving_speed = value
		if is_node_ready():
			_update_nebulae_materials()

## Represents the strength of the swirling flow map distortion.
@export var nebulae_flow_intensity: float = 0.04:
	set(value):
		nebulae_flow_intensity = value
		if is_node_ready():
			_update_nebulae_materials()

## Represents how fast the flow map distortion moves.
@export var nebulae_flow_speed: float = 0.02:
	set(value):
		nebulae_flow_speed = value
		if is_node_ready():
			_update_nebulae_materials()

@export_group("Star Field Effects Settings")

## Represents the color tint applied to the background star layer.
@export var stars_field_background_color_tint: Color = Color(0.8, 0.8, 1.0, 1.0):
	set(value):
		stars_field_background_color_tint = value
		if is_node_ready():
			_update_stars_point_materials()

## Represents how much the background star layer is dimmed.
@export_range(0.0, 1.0, 0.001) var stars_field_background_dimming: float = 0.15:
	set(value):
		stars_field_background_dimming = value
		if is_node_ready():
			_update_stars_point_materials()

## Represents the horizontal shift offset for the background star layer.
@export_range(0.0, 1.0, 0.001) var stars_field_background_horizontal_shift: float = 0.33:
	set(value):
		stars_field_background_horizontal_shift = value
		if is_node_ready():
			_update_stars_point_materials()

@export_group("Twinkle Effect Settings")

## Represents the twinkle settings applied to the near stars layer.
@export var stars_point_near_twinkle: TwinkleEffectSettings = TwinkleEffectSettings.new(0.3, 800.0, 2.0)

## Represents the twinkle settings applied to the mid stars layer.
@export var stars_point_mid_twinkle: TwinkleEffectSettings = TwinkleEffectSettings.new(0.6, 1500.0, 2.0)

## Represents the twinkle settings applied to the far stars layer.
@export var stars_point_far_twinkle: TwinkleEffectSettings = TwinkleEffectSettings.new(0.9, 2500.0, 4.0)

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


# Applies exported settings to the nebulae shaders.
func _apply_nebulae_material(
		mesh_instance: MeshInstance3D,
		texture_2d: Texture2D,
		skybox_layer_material: SkyboxLayerMaterial,
		node_name: String,
):
	_apply_texture(mesh_instance, texture_2d, node_name)

	var material = mesh_instance.mesh.material

	if not material is ShaderMaterial:
		push_error(
			"bad dispatch to 'Skybox._apply_nebulae_material' (child node '" + node_name +
			".mesh.material' is not 'ShaderMaterial')",
		)
		return

	if skybox_layer_material != null:
		material.set_shader_parameter("albedo", skybox_layer_material.albedo_color)
		material.set_shader_parameter("emission", skybox_layer_material.emission_color)
		material.set_shader_parameter("emission_energy", skybox_layer_material.emission_energy)

	material.set_shader_parameter("carving_intensity", nebulae_carving_intensity)
	material.set_shader_parameter("carving_noise_texture", nebulae_carving_noise_texture)
	material.set_shader_parameter("carving_scale", nebulae_carving_scale)
	material.set_shader_parameter("carving_speed", nebulae_carving_speed)
	material.set_shader_parameter("flow_intensity", nebulae_flow_intensity)
	material.set_shader_parameter("flow_speed", nebulae_flow_speed)


# Applies exported settings to the star field shaders.
func _apply_stars_field_material(
		mesh_instance: MeshInstance3D,
		texture_2d: Texture2D,
		skybox_layer_material: SkyboxLayerMaterial,
		background_color_tint: Color,
		background_dimming: float,
		background_horizontal_shift: float,
		node_name: String,
):
	_apply_texture(mesh_instance, texture_2d, node_name)

	var material = mesh_instance.mesh.material

	if not material is ShaderMaterial:
		push_error(
			"bad dispatch to 'Skybox._apply_stars_field_material' (child node '" + node_name +
			".mesh.material' is not 'ShaderMaterial')",
		)
		return

	if skybox_layer_material != null:
		material.set_shader_parameter("albedo", skybox_layer_material.albedo_color)
		material.set_shader_parameter("emission", skybox_layer_material.emission_color)
		material.set_shader_parameter("emission_energy", skybox_layer_material.emission_energy)

	material.set_shader_parameter("background_horizontal_shift", background_horizontal_shift)
	material.set_shader_parameter("background_dimming", background_dimming)
	material.set_shader_parameter("background_color_tint", background_color_tint)


# Applies exported settings to the point star shaders.
func _apply_stars_point_material(
		mesh_instance: MeshInstance3D,
		texture_2d: Texture2D,
		skybox_layer_material: SkyboxLayerMaterial,
		twinkle_effect_settings: TwinkleEffectSettings,
		node_name: String,
):
	_apply_texture(mesh_instance, texture_2d, node_name)

	var material = mesh_instance.mesh.material

	if not material is ShaderMaterial:
		push_error(
			"bad dispatch to 'Skybox._apply_stars_point_material' (child node '" + node_name +
			".mesh.material' is not 'ShaderMaterial')",
		)
		return

	if skybox_layer_material != null:
		material.set_shader_parameter("albedo", skybox_layer_material.albedo_color)
		material.set_shader_parameter("emission", skybox_layer_material.emission_color)
		material.set_shader_parameter("emission_energy", skybox_layer_material.emission_energy)

	if twinkle_effect_settings != null:
		material.set_shader_parameter("twinkle_frequency", twinkle_effect_settings.frequency)
		material.set_shader_parameter("twinkle_intensity", twinkle_effect_settings.intensity)
		material.set_shader_parameter("twinkle_speed", twinkle_effect_settings.speed)


# Updates the nebulae mesh layer's materials based on the exported variables.
func _update_nebulae_materials():
	_apply_nebulae_material(
		_nebulae_layer_near_mesh,
		nebulae_texture,
		nebulae_near_material,
		"NebulaeLayerNearMesh",
	)

	_apply_nebulae_material(
		_nebulae_layer_mid_mesh,
		nebulae_texture,
		nebulae_mid_material,
		"NebulaeLayerMidMesh",
	)

	_apply_nebulae_material(
		_nebulae_layer_far_mesh,
		nebulae_texture,
		nebulae_far_material,
		"NebulaeLayerFarMesh",
	)


# Updates the star mesh layer's materials based on the exported variables.
func _update_stars_field_materials():
	_apply_stars_field_material(
		_stars_layer_field_mesh,
		stars_field_texture,
		stars_field_material,
		stars_field_background_color_tint,
		stars_field_background_dimming,
		stars_field_background_horizontal_shift,
		"StarsLayerFieldMesh",
	)


# Updates the star mesh layer's materials based on the exported variables.
func _update_stars_point_materials():
	_apply_stars_point_material(
		_stars_layer_near_mesh,
		stars_point_texture,
		stars_point_near_material,
		stars_point_near_twinkle,
		"StarsLayerNearMesh",
	)

	_apply_stars_point_material(
		_stars_layer_mid_mesh,
		stars_point_texture,
		stars_point_mid_material,
		stars_point_mid_twinkle,
		"StarsLayerMidMesh",
	)

	_apply_stars_point_material(
		_stars_layer_far_mesh,
		stars_point_texture,
		stars_point_far_material,
		stars_point_far_twinkle,
		"StarsLayerFarMesh",
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
	if nebulae_near_material != null:
		nebulae_near_material.changed.connect(_update_nebulae_materials)
	if nebulae_mid_material != null:
		nebulae_mid_material.changed.connect(_update_nebulae_materials)
	if nebulae_far_material != null:
		nebulae_far_material.changed.connect(_update_nebulae_materials)

	if stars_field_material != null:
		stars_field_material.changed.connect(_update_stars_field_materials)

	if stars_point_near_material != null:
		stars_point_near_material.changed.connect(_update_stars_point_materials)
	if stars_point_mid_material != null:
		stars_point_mid_material.changed.connect(_update_stars_point_materials)
	if stars_point_far_material != null:
		stars_point_far_material.changed.connect(_update_stars_point_materials)

	if stars_point_near_twinkle != null:
		stars_point_near_twinkle.changed.connect(_update_stars_point_materials)
	if stars_point_mid_twinkle != null:
		stars_point_mid_twinkle.changed.connect(_update_stars_point_materials)
	if stars_point_far_twinkle != null:
		stars_point_far_twinkle.changed.connect(_update_stars_point_materials)

	_update_nebulae_materials()
	_update_stars_point_materials()
	_update_stars_field_materials()
	_update_void_texture()
	_update_projection_radius()


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	var stars_field_speed = rotation_speed * stars_field_speed_multiplier
	var stars_point_far_speed = stars_field_speed * stars_point_far_speed_multiplier
	var stars_point_mid_speed = stars_point_far_speed * stars_point_mid_speed_multiplier
	var stars_point_near_speed = stars_point_mid_speed * stars_point_near_speed_multiplier
	var nebulae_speed = stars_point_near_speed * nebulae_speed_multiplier

	_void_layer_mesh.rotate_y(rotation_speed * delta)
	_stars_layer_field_mesh.rotate_y(stars_field_speed * delta)
	_stars_layer_far_mesh.rotate_y(stars_point_far_speed * delta)
	_stars_layer_mid_mesh.rotate_y(stars_point_mid_speed * delta)
	_stars_layer_near_mesh.rotate_y(stars_point_near_speed * delta)
	_nebulae_layer_near_mesh.rotate_y(nebulae_speed * delta)
