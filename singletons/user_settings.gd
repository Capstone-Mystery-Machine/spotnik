class_name UserSettings
extends RefCounted

signal setting_changed(
		setting_name: StringName,
		new_value: Variant,
		old_value: Variant,
)

# gdlint-ignore-next-line constant-name
const Gamma = {
	DEFAULT = 1.0,
	MIN = 0.5,
	MAX = 1.5,
}

enum MaxFPS {
	LOW = 30,
	HIGH = 60,
}

enum MeshQuality {
	LOW,
	MEDIUM,
	HIGH,
}

# gdlint-ignore-next-line constant-name
const ResolutionScale = {
	LOW = 0.5,
	MEDIUM = 0.75,
	HIGH = 1.0,
}

# gdlint-ignore-next-line constant-name
const SettingName = {
	ANISOTROPIC_FILTERING_QUALITY = &"rendering/engine/anisotropic_filtering_quality",
	ANTI_ALIASING_QUALITY = &"rendering/engine/anti_aliasing",
	BLOOM_ENABLED = &"rendering/environment/bloom_enabled",
	MAX_FPS = &"rendering/engine/max_fps",
	MESH_QUALITY = &"rendering/meshes/mesh_quality",
	GAMMA = &"rendering/environment/gamma",
	RESOLUTION_SCALE = &"rendering/engine/resolution_scale",
	SHADER_QUALITY = &"rendering/shaders/shader_quality",
	TEXTURE_FILTERING = &"rendering/engine/texture_filtering",
	TICK_RATE = &"physics/engine/tick_rate",
}

enum ShaderQuality {
	LOW,
	MEDIUM,
	HIGH,
}

enum TickRate {
	LOW = 15,
	MEDIUM = 30,
	HIGH = 60,
}

# gdlint-ignore-next-line constant-name
const SettingDefaultValue = {
	SettingName.ANISOTROPIC_FILTERING_QUALITY: Viewport.AnisotropicFiltering.ANISOTROPY_16X,
	SettingName.ANTI_ALIASING_QUALITY: Viewport.MSAA.MSAA_8X,
	SettingName.BLOOM_ENABLED: true,
	SettingName.MAX_FPS: MaxFPS.LOW,
	SettingName.MESH_QUALITY: MeshQuality.HIGH,
	SettingName.GAMMA: 1.0,
	SettingName.RESOLUTION_SCALE: ResolutionScale.HIGH,
	SettingName.SHADER_QUALITY: ShaderQuality.HIGH,
	SettingName.TEXTURE_FILTERING: \
	Viewport.DefaultCanvasItemTextureFilter.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST_WITH_MIPMAPS,
	SettingName.TICK_RATE: TickRate.HIGH,
}

static var instance: UserSettings = UserSettings.new()

static var _settings: Dictionary = { }


static func _on_setting_changed(
		setting_name: StringName,
		new_value: Variant,
		_old_value: Variant,
) -> void:
	match setting_name:
		SettingName.ANISOTROPIC_FILTERING_QUALITY:
			apply_anisotropic_filtering_quality(new_value)
		SettingName.ANTI_ALIASING_QUALITY:
			apply_anti_aliasing_quality(new_value)
		SettingName.MAX_FPS:
			apply_max_fps(new_value)
		SettingName.RESOLUTION_SCALE:
			apply_resolution_scale(new_value)
		SettingName.TEXTURE_FILTERING:
			apply_texture_filtering(new_value)
		SettingName.TICK_RATE:
			apply_tick_rate(new_value)


static func get_setting(setting_name: StringName, default_value: Variant = null) -> Variant:
	if _settings.has(setting_name):
		return _settings[setting_name]

	return default_value


static func set_setting(setting_name: StringName, value: Variant) -> void:
	var old_value = _settings.get(setting_name)

	_settings[setting_name] = value

	_on_setting_changed(setting_name, value, old_value)
	instance.setting_changed.emit(setting_name, value, old_value)


static func apply_anisotropic_filtering_quality(value: Variant = null) -> void:
	if value == null:
		value = get_anisotropic_filtering_quality()

	(Engine.get_main_loop() as SceneTree).root.anisotropic_filtering_level = value


static func apply_anti_aliasing_quality(value: Variant = null) -> void:
	if value == null:
		value = get_anti_aliasing_quality()

	(Engine.get_main_loop() as SceneTree).root.msaa_3d = value


static func apply_max_fps(value: Variant = null) -> void:
	if value == null:
		value = get_max_fps()

	Engine.max_fps = value


static func apply_resolution_scale(value: Variant = null) -> void:
	if value == null:
		value = get_resolution_scale()

	(Engine.get_main_loop() as SceneTree).root.scaling_3d_scale = value


static func apply_texture_filtering(value: Variant = null) -> void:
	if value == null:
		value = get_texture_filtering()

	(Engine.get_main_loop() as SceneTree) \
	.root.canvas_item_default_texture_filter = value


static func apply_tick_rate(value: Variant = null) -> void:
	if value == null:
		value = get_tick_rate()

	Engine.physics_ticks_per_second = value


static func get_anisotropic_filtering_quality() -> Viewport.AnisotropicFiltering:
	return get_setting(
		SettingName.ANISOTROPIC_FILTERING_QUALITY,
		SettingDefaultValue[SettingName.ANISOTROPIC_FILTERING_QUALITY],
	)


static func get_anti_aliasing_quality() -> Viewport.MSAA:
	return get_setting(
		SettingName.ANTI_ALIASING_QUALITY,
		SettingDefaultValue[SettingName.ANTI_ALIASING_QUALITY],
	)


static func get_max_fps() -> int:
	return get_setting(
		SettingName.MAX_FPS,
		SettingDefaultValue[SettingName.MAX_FPS],
	)


static func get_resolution_scale() -> float:
	return get_setting(
		SettingName.RESOLUTION_SCALE,
		SettingDefaultValue[SettingName.RESOLUTION_SCALE],
	)


static func get_texture_filtering() -> Viewport.DefaultCanvasItemTextureFilter:
	return get_setting(
		SettingName.TEXTURE_FILTERING,
		SettingDefaultValue[SettingName.TEXTURE_FILTERING],
	)


static func get_tick_rate() -> TickRate:
	return get_setting(
		SettingName.TICK_RATE,
		SettingDefaultValue[SettingName.TICK_RATE],
	)


static func set_anisotropic_filtering_quality(value: Viewport.AnisotropicFiltering) -> void:
	set_setting(SettingName.ANISOTROPIC_FILTERING_QUALITY, value)


static func set_anti_aliasing_quality(value: Viewport.MSAA) -> void:
	set_setting(SettingName.ANTI_ALIASING_QUALITY, value)


static func set_max_fps(value: int) -> void:
	set_setting(SettingName.MAX_FPS, value)


static func set_resolution_scale(value: float) -> void:
	set_setting(SettingName.RESOLUTION_SCALE, value)


static func set_texture_filtering(
		value: Viewport.DefaultCanvasItemTextureFilter,
) -> void:
	set_setting(SettingName.TEXTURE_FILTERING, value)


static func set_tick_rate(value: TickRate) -> void:
	set_setting(SettingName.TICK_RATE, value)
