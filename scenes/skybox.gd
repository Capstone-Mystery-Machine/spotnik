@tool
extends Node3D
## Spherical skybox with a projected layered projected panorama textures via
## [MeshInstance3D] instances with [SphereMesh] meshes.

## Represents the resource containing all skybox visual and simulation settings.
@export var settings: SkyboxSettings:
	set(value):
		_disconnect_resources()
		settings = value
		_connect_resources()
		if is_node_ready():
			_update_all()

@onready var _void_layer_mesh: MeshInstance3D = $VoidLayerMesh
@onready var _stars_layer_far_field_mesh: MeshInstance3D = $StarsLayerFarFieldMesh
@onready var _stars_layer_near_field_mesh: MeshInstance3D = $StarsLayerNearFieldMesh
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
			"bad dispatch to 'Skybox._apply_radius' (child node '"
			+ node_name + ".mesh' is not 'SphereMesh')",
		)
		return

	sphere_mesh.radius = radius
	sphere_mesh.height = radius * 2


# Applies an exported texture setting to a child mesh layer.
func _apply_texture(mesh_instance: MeshInstance3D, texture_2d: Texture2D, node_name: String):
	var sphere_mesh = mesh_instance.mesh as SphereMesh

	if !sphere_mesh:
		push_error(
			"bad dispatch to 'Skybox._apply_texture' (child node '"
			+ node_name + ".mesh' is not 'SphereMesh')",
		)
		return

	var material = sphere_mesh.material

	if !material:
		push_error(
			"bad dispatch to 'Skybox._apply_texture' (child node '"
			+ node_name + ".mesh.material' is empty)",
		)
		return

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
			"bad dispatch to 'Skybox._apply_nebulae_material' (child node '"
			+ node_name + ".mesh.material' is not 'ShaderMaterial')",
		)
		return

	if skybox_layer_material != null:
		material.set_shader_parameter("albedo", skybox_layer_material.albedo_color)
		material.set_shader_parameter("emission", skybox_layer_material.emission_color)
		material.set_shader_parameter("emission_energy", skybox_layer_material.emission_energy)

	if settings != null:
		material.set_shader_parameter("dissolve_intensity", settings.nebulae_dissolve_intensity)
		material.set_shader_parameter("dissolve_noise_texture", settings.nebulae_dissolve_noise_texture)
		material.set_shader_parameter("dissolve_scale", settings.nebulae_dissolve_scale)
		material.set_shader_parameter("dissolve_speed", settings.nebulae_dissolve_speed)
		material.set_shader_parameter("dissolve_warp_intensity", settings.nebulae_dissolve_warp_intensity)
		material.set_shader_parameter("flow_intensity", settings.nebulae_flow_intensity)
		material.set_shader_parameter("flow_speed", settings.nebulae_flow_speed)


# Applies exported settings to the star field shaders.
func _apply_stars_field_material(
		mesh_instance: MeshInstance3D,
		texture_2d: Texture2D,
		skybox_layer_material: SkyboxLayerMaterial,
		node_name: String,
):
	_apply_texture(mesh_instance, texture_2d, node_name)

	var material = mesh_instance.mesh.material

	if not material is StandardMaterial3D:
		push_error(
			"bad dispatch to 'Skybox._apply_stars_field_material' (child node '"
			+ node_name + ".mesh.material' is not 'StandardMaterial3D')",
		)
		return

	if skybox_layer_material != null:
		var hdr_color = skybox_layer_material.emission_color * skybox_layer_material.emission_energy
		hdr_color.a = skybox_layer_material.albedo_color.a

		material.albedo_color = hdr_color


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
			"bad dispatch to 'Skybox._apply_stars_point_material' (child node '"
			+ node_name + ".mesh.material' is not 'ShaderMaterial')",
		)
		return

	if skybox_layer_material != null:
		material.set_shader_parameter("albedo", skybox_layer_material.albedo_color)
		material.set_shader_parameter("emission", skybox_layer_material.emission_color)
		material.set_shader_parameter("emission_energy", skybox_layer_material.emission_energy)

	if settings != null:
		material.set_shader_parameter("color_palette", settings.stars_point_color_palette)

	if twinkle_effect_settings != null:
		material.set_shader_parameter("twinkle_frequency", twinkle_effect_settings.frequency)
		material.set_shader_parameter("twinkle_intensity", twinkle_effect_settings.intensity)
		material.set_shader_parameter("twinkle_speed", twinkle_effect_settings.speed)


# Updates the nebulae mesh layer's materials based on the exported variables.
func _update_nebulae_materials():
	if settings == null:
		return

	_apply_nebulae_material(
		_nebulae_layer_near_mesh,
		settings.nebulae_texture,
		settings.nebulae_near_material,
		"NebulaeLayerNearMesh",
	)

	_apply_nebulae_material(
		_nebulae_layer_mid_mesh,
		settings.nebulae_texture,
		settings.nebulae_mid_material,
		"NebulaeLayerMidMesh",
	)

	_apply_nebulae_material(
		_nebulae_layer_far_mesh,
		settings.nebulae_texture,
		settings.nebulae_far_material,
		"NebulaeLayerFarMesh",
	)


# Updates the star mesh layer's materials based on the exported variables.
func _update_stars_field_materials():
	if settings == null:
		return

	_apply_stars_field_material(
		_stars_layer_near_field_mesh,
		settings.stars_field_texture,
		settings.stars_field_near_material,
		"StarsLayerNearFieldMesh",
	)

	_apply_stars_field_material(
		_stars_layer_far_field_mesh,
		settings.stars_field_texture,
		settings.stars_field_far_material,
		"StarsLayerFarFieldMesh",
	)


# Updates the star mesh layer's materials based on the exported variables.
func _update_stars_point_materials():
	if settings == null:
		return

	_apply_stars_point_material(
		_stars_layer_near_mesh,
		settings.stars_point_texture,
		settings.stars_point_near_material,
		settings.stars_point_near_twinkle,
		"StarsLayerNearMesh",
	)

	_apply_stars_point_material(
		_stars_layer_mid_mesh,
		settings.stars_point_texture,
		settings.stars_point_mid_material,
		settings.stars_point_mid_twinkle,
		"StarsLayerMidMesh",
	)

	_apply_stars_point_material(
		_stars_layer_far_mesh,
		settings.stars_point_texture,
		settings.stars_point_far_material,
		settings.stars_point_far_twinkle,
		"StarsLayerFarMesh",
	)


## Updates the child nodes' projection radius settings based on the exported variable.
func _update_projection_radius():
	if settings == null:
		return

	var nebulae_mid_radius = settings.projection_radius * settings.nebulae_displacement_multiplier
	var nebulae_far_radius = nebulae_mid_radius * settings.nebulae_displacement_multiplier

	var stars_near_radius = nebulae_far_radius * settings.stars_point_radius_multiplier
	var stars_mid_radius = stars_near_radius * settings.stars_point_displacement_multiplier
	var stars_far_radius = stars_mid_radius * settings.stars_point_displacement_multiplier

	var stars_field_near_radius = stars_far_radius * settings.stars_point_radius_multiplier
	var stars_field_far_radius = stars_field_near_radius * settings.stars_point_displacement_multiplier

	var void_radius = stars_field_far_radius * settings.void_radius_multiplier

	_apply_radius(
		_nebulae_layer_near_mesh,
		settings.projection_radius,
		"NebulaeLayerNearMesh",
	)

	_apply_radius(
		_nebulae_layer_mid_mesh,
		nebulae_mid_radius,
		"NebulaeLayerMidMesh",
	)

	_apply_radius(
		_nebulae_layer_far_mesh,
		nebulae_far_radius,
		"NebulaeLayerFarMesh",
	)

	_apply_radius(
		_stars_layer_near_mesh,
		stars_near_radius,
		"StarsLayerNearMesh",
	)

	_apply_radius(
		_stars_layer_mid_mesh,
		stars_mid_radius,
		"StarsLayerMidMesh",
	)

	_apply_radius(
		_stars_layer_far_mesh,
		stars_far_radius,
		"StarsLayerFarMesh",
	)

	_apply_radius(
		_stars_layer_near_field_mesh,
		stars_field_near_radius,
		"StarsLayerNearFieldMesh",
	)

	_apply_radius(
		_stars_layer_far_field_mesh,
		stars_field_far_radius,
		"StarsLayerFarFieldMesh",
	)

	_apply_radius(
		_void_layer_mesh,
		void_radius,
		"VoidLayerMesh",
	)


func _update_all():
	_update_nebulae_materials()
	_update_stars_point_materials()
	_update_stars_field_materials()
	_update_projection_radius()


# Connects a resource's property_changed signal.
func _connect_resource(resource: Resource):
	if resource != null and not resource.property_changed.is_connected(_on_property_changed):
		resource.property_changed.connect(_on_property_changed)


# Disconnects a resource's property_changed signal.
func _disconnect_resource(resource: Resource):
	if resource != null and resource.property_changed.is_connected(_on_property_changed):
		resource.property_changed.disconnect(_on_property_changed)


# Sets up all reactivity signals.
func _connect_resources():
	if settings == null:
		return

	_connect_resource(settings)
	_connect_resource(settings.nebulae_near_material)
	_connect_resource(settings.nebulae_mid_material)
	_connect_resource(settings.nebulae_far_material)
	_connect_resource(settings.stars_field_near_material)
	_connect_resource(settings.stars_field_far_material)
	_connect_resource(settings.stars_point_near_material)
	_connect_resource(settings.stars_point_mid_material)
	_connect_resource(settings.stars_point_far_material)
	_connect_resource(settings.stars_point_near_twinkle)
	_connect_resource(settings.stars_point_mid_twinkle)
	_connect_resource(settings.stars_point_far_twinkle)


# Clears all reactivity signals.
func _disconnect_resources():
	if settings == null:
		return

	_disconnect_resource(settings)
	_disconnect_resource(settings.nebulae_near_material)
	_disconnect_resource(settings.nebulae_mid_material)
	_disconnect_resource(settings.nebulae_far_material)
	_disconnect_resource(settings.stars_field_near_material)
	_disconnect_resource(settings.stars_field_far_material)
	_disconnect_resource(settings.stars_point_near_material)
	_disconnect_resource(settings.stars_point_mid_material)
	_disconnect_resource(settings.stars_point_far_material)
	_disconnect_resource(settings.stars_point_near_twinkle)
	_disconnect_resource(settings.stars_point_mid_twinkle)
	_disconnect_resource(settings.stars_point_far_twinkle)


# Responds to setting and sub-resource changes.
func _on_property_changed(property_name: StringName) -> void:
	match property_name:
		&"nebulae_texture", &"nebulae_dissolve_intensity", &"nebulae_dissolve_noise_texture", &"nebulae_dissolve_scale", &"nebulae_dissolve_speed", &"nebulae_dissolve_warp_intensity", &"nebulae_flow_intensity", &"nebulae_flow_speed":
			_update_nebulae_materials()
		&"stars_field_texture":
			_update_stars_field_materials()
		&"stars_point_texture", &"stars_point_color_palette":
			_update_stars_point_materials()
		&"projection_radius", &"nebulae_displacement_multiplier", &"stars_point_radius_multiplier", &"stars_point_displacement_multiplier", &"stars_field_radius_multiplier", &"stars_field_displacement_multiplier", &"void_radius_multiplier":
			_update_projection_radius()
		&"albedo_color", &"emission_color", &"emission_energy":
			_update_nebulae_materials()
			_update_stars_field_materials()
			_update_stars_point_materials()
		&"frequency", &"intensity", &"speed":
			_update_stars_point_materials()
		&"nebulae_near_material", &"nebulae_mid_material", &"nebulae_far_material":
			_disconnect_resources()
			_connect_resources()
			_update_nebulae_materials()
		&"stars_field_near_material", &"stars_field_far_material":
			_disconnect_resources()
			_connect_resources()
			_update_stars_field_materials()
		&"stars_point_near_material", &"stars_point_mid_material", &"stars_point_far_material", &"stars_point_near_twinkle", &"stars_point_mid_twinkle", &"stars_point_far_twinkle":
			_disconnect_resources()
			_connect_resources()
			_update_stars_point_materials()


func _ready() -> void:
	_connect_resources()
	_update_all()


func _process(delta: float) -> void:
	if settings == null:
		return

	var stars_field_far_speed = settings.rotation_speed * settings.stars_field_far_speed_multiplier
	var stars_field_near_speed = stars_field_far_speed * settings.stars_field_near_speed_multiplier
	var stars_point_far_speed = stars_field_near_speed * settings.stars_point_far_speed_multiplier
	var stars_point_mid_speed = stars_point_far_speed * settings.stars_point_mid_speed_multiplier
	var stars_point_near_speed = stars_point_mid_speed * settings.stars_point_near_speed_multiplier
	var nebulae_speed = stars_point_near_speed * settings.nebulae_speed_multiplier

	_void_layer_mesh.rotate_y(settings.rotation_speed * delta)
	_stars_layer_far_field_mesh.rotate_y(stars_field_far_speed * delta)
	_stars_layer_near_field_mesh.rotate_y(stars_field_near_speed * delta)
	_stars_layer_far_mesh.rotate_y(stars_point_far_speed * delta)
	_stars_layer_mid_mesh.rotate_y(stars_point_mid_speed * delta)
	_stars_layer_near_mesh.rotate_y(stars_point_near_speed * delta)
	_nebulae_layer_near_mesh.rotate_y(nebulae_speed * delta)
