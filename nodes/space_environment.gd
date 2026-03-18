extends WorldEnvironment

func _update_bloom(bloom_enabled: bool) -> void:
	if environment:
		environment.glow_enabled = bloom_enabled


func _on_user_setting_changed(
		setting_name: Array,
		new_value: bool,
		_old_value: bool,
) -> void:
	if setting_name == UserSettings.SettingName.BLOOM_ENABLED:
		_update_bloom(new_value)


func _ready() -> void:
	UserSettings.instance.setting_changed.connect(_on_user_setting_changed)
	_update_bloom(UserSettings.bloom_enabled)
