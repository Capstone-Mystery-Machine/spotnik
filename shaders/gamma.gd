extends ColorRect

func _update_gamma(value: float) -> void:
	if is_equal_approx(value, UserSettings.Gamma.DEFAULT):
		hide()

	else:
		show()

		var inverse_gamma = 1.0 / value

		(material as ShaderMaterial).set_shader_parameter("inverse_gamma", inverse_gamma)


func _on_setting_changed(
		setting_name: Array,
		new_value: Variant,
		_old_value: Variant,
) -> void:
	if setting_name == UserSettings.SettingName.GAMMA:
		_update_gamma(new_value)


func _ready() -> void:
	UserSettings.instance.setting_changed.connect(_on_setting_changed)
	_update_gamma(UserSettings.gamma)
