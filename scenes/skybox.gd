@tool
extends Node3D
## Spherical skybox with a projected layered projected panorama textures via
## [MeshInstance3D] instances with [SphereMesh] meshes.

## Represents the resource containing all skybox visual and simulation settings.
@export var settings: SkyboxSettings:
	set(value):
		settings = value
		if is_node_ready():
			_connect_all_signals()
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
		material.set_shader_parameter("carving_intensity", settings.nebulae_carving_intensity)
		material.set_shader_parameter("carving_noise_texture", settings.nebulae_carving_noise_texture)
		material.set_shader_parameter("carving_scale", settings.nebulae_carving_scale)
		material.set_shader_parameter("carving_speed", settings.nebulae_carving_speed)
		material.set_shader_parameter("flow_intensity", settings.nebulae_flow_intensity)
		material.set_shader_parameter("flow_speed", settings.nebulae_flow_speed)


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

	if twinkle_effect_settings != null:
		material.set_shader_parameter("twinkle_frequency", twinkle_effect_settings.frequency)
		material.set_shader_parameter("twinkle_intensity", twinkle_effect_settings.intensity)
		material.set_shader_parameter("twinkle_speed", twinkle_effect_settings.speed)


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


func _connect_resource_signal(resource: Resource, callable: Callable):
	if resource != null and not resource.changed.is_connected(callable):
		resource.changed.connect(callable)


func _connect_all_signals():
	if settings == null:
		return

	_connect_resource_signal(settings, _on_settings_resource_changed)

	_connect_resource_signal(settings.nebulae_near_material, _update_nebulae_materials)
	_connect_resource_signal(settings.nebulae_mid_material, _update_nebulae_materials)
	_connect_resource_signal(settings.nebulae_far_material, _update_nebulae_materials)

	_connect_resource_signal(settings.stars_field_near_material, _update_stars_field_materials)
	_connect_resource_signal(settings.stars_field_far_material, _update_stars_field_materials)

	_connect_resource_signal(settings.stars_point_near_material, _update_stars_point_materials)
	_connect_resource_signal(settings.stars_point_mid_material, _update_stars_point_materials)
	_connect_resource_signal(settings.stars_point_far_material, _update_stars_point_materials)

	_connect_resource_signal(settings.stars_point_near_twinkle, _update_stars_point_materials)
	_connect_resource_signal(settings.stars_point_mid_twinkle, _update_stars_point_materials)
	_connect_resource_signal(settings.stars_point_far_twinkle, _update_stars_point_materials)


func _on_settings_resource_changed():
	_connect_all_signals()
	_update_all()


func _ready() -> void:
	_connect_all_signals()
	_update_all()


func _process(delta: float) -> void:
	if Engine.is_editor_hint() or settings == null:
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
