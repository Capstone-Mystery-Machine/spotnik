class_name UserSettings
extends RefCounted

signal setting_changed(
		setting_name: Array[StringName],
		new_value: Variant,
		old_value: Variant,
)

const PATH_CONFIG_FILE: StringName = &"user://user_settings.ini"

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
	ANISOTROPIC_FILTERING_QUALITY = [&"rendering", &"anisotropic_filtering_quality"],
	ANTI_ALIASING_QUALITY = [&"rendering", &"anti_aliasing"],
	BLOOM_ENABLED = [&"rendering", &"bloom_enabled"],
	MAX_FPS = [&"rendering", &"max_fps"],
	MESH_QUALITY = [&"rendering", &"mesh_quality"],
	GAMMA = [&"rendering", &"gamma"],
	RESOLUTION_SCALE = [&"rendering", &"resolution_scale"],
	SHADER_QUALITY = [&"rendering", &"shader_quality"],
	TEXTURE_FILTERING = [&"rendering", &"texture_filtering"],
	TICK_RATE = [&"physics", &"tick_rate"],
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
	SettingName.ANISOTROPIC_FILTERING_QUALITY: Viewport.AnisotropicFiltering.ANISOTROPY_DISABLED,
	SettingName.ANTI_ALIASING_QUALITY: Viewport.MSAA.MSAA_8X,
	SettingName.BLOOM_ENABLED: false,
	SettingName.MAX_FPS: MaxFPS.LOW,
	SettingName.MESH_QUALITY: MeshQuality.LOW,
	SettingName.GAMMA: 1.0,
	SettingName.RESOLUTION_SCALE: ResolutionScale.LOW,
	SettingName.SHADER_QUALITY: ShaderQuality.LOW,
	SettingName.TEXTURE_FILTERING: \
	Viewport.DefaultCanvasItemTextureFilter.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST,
	SettingName.TICK_RATE: TickRate.LOW,
}

enum QualityProfile {
	LOW,
	MEDIUM,
	HIGH,
}

const QualityProfileSettings = {
	QualityProfile.LOW: {
		SettingName.ANISOTROPIC_FILTERING_QUALITY: Viewport.AnisotropicFiltering.ANISOTROPY_DISABLED,
		SettingName.ANTI_ALIASING_QUALITY: Viewport.MSAA.MSAA_DISABLED,
		SettingName.BLOOM_ENABLED: false,
		SettingName.MAX_FPS: MaxFPS.LOW,
		SettingName.MESH_QUALITY: MeshQuality.LOW,
		SettingName.RESOLUTION_SCALE: ResolutionScale.LOW,
		SettingName.SHADER_QUALITY: ShaderQuality.LOW,
		SettingName.TEXTURE_FILTERING: \
		Viewport.DefaultCanvasItemTextureFilter.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST,
		SettingName.TICK_RATE: TickRate.LOW,
	},
	QualityProfile.MEDIUM: {
		SettingName.ANISOTROPIC_FILTERING_QUALITY: Viewport.AnisotropicFiltering.ANISOTROPY_4X,
		SettingName.ANTI_ALIASING_QUALITY: Viewport.MSAA.MSAA_4X,
		SettingName.BLOOM_ENABLED: true,
		SettingName.MAX_FPS: MaxFPS.HIGH,
		SettingName.MESH_QUALITY: MeshQuality.MEDIUM,
		SettingName.RESOLUTION_SCALE: ResolutionScale.MEDIUM,
		SettingName.SHADER_QUALITY: ShaderQuality.MEDIUM,
		SettingName.TEXTURE_FILTERING: \
		Viewport.DefaultCanvasItemTextureFilter.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_LINEAR,
		SettingName.TICK_RATE: TickRate.MEDIUM,
	},
	QualityProfile.HIGH: {
		SettingName.ANISOTROPIC_FILTERING_QUALITY: Viewport.AnisotropicFiltering.ANISOTROPY_16X,
		SettingName.ANTI_ALIASING_QUALITY: Viewport.MSAA.MSAA_8X,
		SettingName.BLOOM_ENABLED: true,
		SettingName.MAX_FPS: MaxFPS.HIGH,
		SettingName.MESH_QUALITY: MeshQuality.HIGH,
		SettingName.RESOLUTION_SCALE: ResolutionScale.HIGH,
		SettingName.SHADER_QUALITY: ShaderQuality.HIGH,
		SettingName.TEXTURE_FILTERING: \
		Viewport.DefaultCanvasItemTextureFilter.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_LINEAR_WITH_MIPMAPS,
		SettingName.TICK_RATE: TickRate.HIGH,
	},
}

static var instance: UserSettings = UserSettings.new()

static var _settings: ConfigFile = ConfigFile.new()


static func _on_setting_changed(
		setting_name: Array[StringName],
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


static func get_setting(setting_name: Array[StringName], default_value: Variant = null) -> Variant:
	if _settings.has_section_key(setting_name[0], setting_name[1]):
		return _settings.get_value(setting_name[0], setting_name[1])

	return default_value


static func set_setting(setting_name: Array[StringName], value: Variant) -> void:
	var old_value = get_setting(setting_name)
	_settings.set_value(setting_name[0], setting_name[1], value)

	_on_setting_changed(setting_name, value, old_value)
	instance.setting_changed.emit(setting_name, value, old_value)


static func apply_all() -> void:
	apply_anisotropic_filtering_quality()
	apply_anti_aliasing_quality()
	apply_max_fps()
	apply_resolution_scale()
	apply_texture_filtering()
	apply_tick_rate()


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


static func get_quality_profile() -> Variant:
	for quality_profile in QualityProfile.values():
		var profile_settings = QualityProfileSettings[quality_profile]
		var is_profile = true

		for setting_name in profile_settings:
			var profile_value = profile_settings[setting_name]
			var stored_value = get_setting(setting_name, SettingDefaultValue[setting_name])

			if stored_value != profile_value:
				is_profile = false
				break

		if is_profile:
			return quality_profile

	return null


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


static func load() -> Error:
	return _settings.load(PATH_CONFIG_FILE)


static func save() -> Error:
	return _settings.save(PATH_CONFIG_FILE)


static func set_anisotropic_filtering_quality(value: Viewport.AnisotropicFiltering) -> void:
	set_setting(SettingName.ANISOTROPIC_FILTERING_QUALITY, value)


static func set_anti_aliasing_quality(value: Viewport.MSAA) -> void:
	set_setting(SettingName.ANTI_ALIASING_QUALITY, value)


static func set_max_fps(value: int) -> void:
	set_setting(SettingName.MAX_FPS, value)


static func set_quality_profile(quality_profile: QualityProfile) -> void:
	var profile_settings = QualityProfileSettings[quality_profile]

	for setting_name in profile_settings:
		var profile_value = profile_settings[setting_name]

		set_setting(setting_name, profile_value)


static func set_resolution_scale(value: float) -> void:
	set_setting(SettingName.RESOLUTION_SCALE, value)


static func set_texture_filtering(
		value: Viewport.DefaultCanvasItemTextureFilter,
) -> void:
	set_setting(SettingName.TEXTURE_FILTERING, value)


static func set_tick_rate(value: TickRate) -> void:
	set_setting(SettingName.TICK_RATE, value)
