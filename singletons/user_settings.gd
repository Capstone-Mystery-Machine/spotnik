class_name UserSettings
extends RefCounted

signal setting_changed(
		setting_name: Array,
		new_value: Variant,
		old_value: Variant,
)

const PATH_USER_SETTINGS_FILE: StringName = &"user://user_settings.ini"

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

# gdlint-ignore-next-line constant-name
const ResolutionScale = {
	LOW = 0.5,
	MEDIUM = 0.75,
	HIGH = 1.0,
}

# gdlint-ignore-next-line constant-name
const SettingName = {
	ANISOTROPIC_FILTERING_QUALITY = ["rendering", "anisotropic_filtering_quality"],
	ANTI_ALIASING_QUALITY = ["rendering", "anti_aliasing"],
	BLOOM_ENABLED = ["rendering", "bloom_enabled"],
	INPUT_MODE = ["input", "input_mode"],
	MAX_FPS = ["rendering", "max_fps"],
	GAMMA = ["rendering", "gamma"],
	RESOLUTION_SCALE = ["rendering", "resolution_scale"],
	TEXTURE_FILTERING = ["rendering", "texture_filtering"],
	TICK_RATE = ["physics", "tick_rate"],
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
	SettingName.INPUT_MODE: null,
	SettingName.MAX_FPS: MaxFPS.LOW,
	SettingName.GAMMA: Gamma.DEFAULT,
	SettingName.RESOLUTION_SCALE: ResolutionScale.LOW,
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
		SettingName.RESOLUTION_SCALE: ResolutionScale.LOW,
		SettingName.TEXTURE_FILTERING: \
		Viewport.DefaultCanvasItemTextureFilter.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST,
		SettingName.TICK_RATE: TickRate.LOW,
	},
	QualityProfile.MEDIUM: {
		SettingName.ANISOTROPIC_FILTERING_QUALITY: Viewport.AnisotropicFiltering.ANISOTROPY_4X,
		SettingName.ANTI_ALIASING_QUALITY: Viewport.MSAA.MSAA_4X,
		SettingName.BLOOM_ENABLED: true,
		SettingName.MAX_FPS: MaxFPS.HIGH,
		SettingName.RESOLUTION_SCALE: ResolutionScale.MEDIUM,
		SettingName.TEXTURE_FILTERING: \
		Viewport.DefaultCanvasItemTextureFilter.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_LINEAR,
		SettingName.TICK_RATE: TickRate.MEDIUM,
	},
	QualityProfile.HIGH: {
		SettingName.ANISOTROPIC_FILTERING_QUALITY: Viewport.AnisotropicFiltering.ANISOTROPY_16X,
		SettingName.ANTI_ALIASING_QUALITY: Viewport.MSAA.MSAA_8X,
		SettingName.BLOOM_ENABLED: true,
		SettingName.MAX_FPS: MaxFPS.HIGH,
		SettingName.RESOLUTION_SCALE: ResolutionScale.HIGH,
		SettingName.TEXTURE_FILTERING: \
		Viewport.DefaultCanvasItemTextureFilter.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_LINEAR_WITH_MIPMAPS,
		SettingName.TICK_RATE: TickRate.HIGH,
	},
}

static var _instance: UserSettings

static var instance: UserSettings:
	get:
		if _instance == null:
			_instance = UserSettings.new()

		return _instance

static var _settings: ConfigFile = ConfigFile.new()

static var anisotropic_filtering_quality: Viewport.AnisotropicFiltering:
	get:
		return get_setting(
			SettingName.ANISOTROPIC_FILTERING_QUALITY,
			SettingDefaultValue[SettingName.ANISOTROPIC_FILTERING_QUALITY],
		)
	set(value):
		set_setting(SettingName.ANISOTROPIC_FILTERING_QUALITY, value)

static var anti_aliasing_quality: Viewport.MSAA:
	get:
		return get_setting(
			SettingName.ANTI_ALIASING_QUALITY,
			SettingDefaultValue[SettingName.ANTI_ALIASING_QUALITY],
		)
	set(value):
		set_setting(SettingName.ANTI_ALIASING_QUALITY, value)

static var input_mode: InputX.InputMode:
	get:
		return get_setting(
			SettingName.INPUT_MODE,
			SettingDefaultValue[SettingName.INPUT_MODE],
		)
	set(value):
		set_setting(SettingName.INPUT_MODE, value)

static var gamma: float:
	get:
		return get_setting(
			SettingName.GAMMA,
			SettingDefaultValue[SettingName.GAMMA],
		)
	set(value):
		set_setting(SettingName.GAMMA, value)

static var max_fps: int:
	get:
		return get_setting(
			SettingName.MAX_FPS,
			SettingDefaultValue[SettingName.MAX_FPS],
		)
	set(value):
		set_setting(SettingName.MAX_FPS, value)

static var quality_profile: Variant:
	get:
		for search_quality_profile in QualityProfile.values():
			var profile_settings = QualityProfileSettings[search_quality_profile]
			var is_profile = true

			for setting_name in profile_settings:
				var profile_value = profile_settings[setting_name]
				var stored_value = get_setting(setting_name, SettingDefaultValue[setting_name])

				if stored_value != profile_value:
					is_profile = false
					break

			if is_profile:
				return search_quality_profile

		return null
	set(value):
		var profile_settings = QualityProfileSettings[value]

		for setting_name in profile_settings:
			var profile_value = profile_settings[setting_name]

			set_setting(setting_name, profile_value)

static var resolution_scale: float:
	get:
		return get_setting(
			SettingName.RESOLUTION_SCALE,
			SettingDefaultValue[SettingName.RESOLUTION_SCALE],
		)
	set(value):
		set_setting(SettingName.RESOLUTION_SCALE, value)

static var texture_filtering: Viewport.DefaultCanvasItemTextureFilter:
	get:
		return get_setting(
			SettingName.TEXTURE_FILTERING,
			SettingDefaultValue[SettingName.TEXTURE_FILTERING],
		)
	set(value):
		set_setting(SettingName.TEXTURE_FILTERING, value)

@warning_ignore("enum_variable_without_default")
static var tick_rate: TickRate:
	get:
		return get_setting(
			SettingName.TICK_RATE,
			SettingDefaultValue[SettingName.TICK_RATE],
		)
	set(value):
		set_setting(SettingName.TICK_RATE, value)


static func _on_setting_changed(
		setting_name: Array,
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


static func get_setting(setting_name: Array, default_value: Variant = null) -> Variant:
	if _settings.has_section_key(setting_name[0], setting_name[1]):
		return _settings.get_value(setting_name[0], setting_name[1])

	return default_value


static func set_setting(setting_name: Array, value: Variant) -> void:
	var old_value = get_setting(setting_name)
	_settings.set_value(setting_name[0], setting_name[1], value)

	_on_setting_changed(setting_name, value, old_value)
	instance.setting_changed.emit(setting_name, value, old_value)


static func apply_global_settings() -> void:
	apply_anisotropic_filtering_quality()
	apply_anti_aliasing_quality()
	apply_max_fps()
	apply_resolution_scale()
	apply_texture_filtering()
	apply_tick_rate()


static func apply_anisotropic_filtering_quality(value: Variant = null) -> void:
	(Engine.get_main_loop() as SceneTree) \
	.root.anisotropic_filtering_level = anisotropic_filtering_quality if value == null else value


static func apply_anti_aliasing_quality(value: Variant = null) -> void:
	(Engine.get_main_loop() as SceneTree) \
	.root.msaa_3d = anti_aliasing_quality if value == null else value


static func apply_max_fps(value: Variant = null) -> void:
	Engine.max_fps = max_fps if value == null else value


static func apply_resolution_scale(value: Variant = null) -> void:
	(Engine.get_main_loop() as SceneTree) \
	.root.scaling_3d_scale = resolution_scale if value == null else value


static func apply_texture_filtering(value: Variant = null) -> void:
	(Engine.get_main_loop() as SceneTree) \
	.root.canvas_item_default_texture_filter = texture_filtering if value == null else value


static func apply_tick_rate(value: Variant = null) -> void:
	Engine.physics_ticks_per_second = tick_rate if value == null else value


static func has_file() -> bool:
	return FileAccess.file_exists(PATH_USER_SETTINGS_FILE)


static func load() -> Error:
	return _settings.load(PATH_USER_SETTINGS_FILE)


static func save() -> Error:
	return _settings.save(PATH_USER_SETTINGS_FILE)
