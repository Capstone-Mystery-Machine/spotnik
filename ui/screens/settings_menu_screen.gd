class_name SettingsMenuScreen
extends Control

@onready var gamma_h_slider: HSlider = %GammaHSlider

@onready var high_quality_button: Button = %HighQualityButton

@onready var low_quality_button: Button = %LowQualityButton

@onready var medium_quality_button: Button = %MediumQualityButton

@onready var motion_button: Button = %MotionButton

@onready var touch_button: Button = %TouchButton


func _toggle_quality_profile(quality_profile: UserSettings.QualityProfile) -> void:
	match quality_profile:
		UserSettings.QualityProfile.HIGH:
			high_quality_button.button_pressed = true
		UserSettings.QualityProfile.LOW:
			low_quality_button.button_pressed = true
		UserSettings.QualityProfile.MEDIUM:
			medium_quality_button.button_pressed = true


func _toggle_control_style(input_mode: InputX.InputMode) -> void:
	match input_mode:
		InputX.InputMode.INPUT_GYRO:
			motion_button.button_pressed = true
		InputX.InputMode.INPUT_TOUCH:
			touch_button.button_pressed = true


func _on_gamma_h_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		UserSettings.save()


func _on_gamma_h_slider_value_changed(value: float) -> void:
	UserSettings.gamma = value


func _on_quality_profile_button_pressed(
		quality_profile: UserSettings.QualityProfile,
) -> void:
	UserSettings.quality_profile = quality_profile
	UserSettings.save()


func _on_setting_changed(
		setting_name: Array,
		new_value: Variant,
		_old_value: Variant,
) -> void:
	match setting_name:
		UserSettings.SettingName.INPUT_MODE:
			pass
		UserSettings.SettingName.GAMMA:
			gamma_h_slider.value = new_value
		_:
			_toggle_quality_profile(UserSettings.quality_profile)


func _on_control_style_button_pressed(
		input_mode: InputX.InputMode,
) -> void:
	UserSettings.input_mode = input_mode
	UserSettings.save()


func _ready() -> void:
	_toggle_control_style(InputX.input_mode)
	_toggle_quality_profile(UserSettings.quality_profile)

	gamma_h_slider.max_value = UserSettings.Gamma.MAX
	gamma_h_slider.min_value = UserSettings.Gamma.MIN

	gamma_h_slider.value = UserSettings.gamma

	UserSettings.instance.setting_changed.connect(_on_setting_changed)

	low_quality_button.pressed.connect(
		_on_quality_profile_button_pressed.bind(UserSettings.QualityProfile.LOW),
	)

	high_quality_button.pressed.connect(
		_on_quality_profile_button_pressed.bind(UserSettings.QualityProfile.HIGH),
	)

	medium_quality_button.pressed.connect(
		_on_quality_profile_button_pressed.bind(UserSettings.QualityProfile.MEDIUM),
	)

	gamma_h_slider.drag_ended.connect(_on_gamma_h_slider_drag_ended)
	gamma_h_slider.value_changed.connect(_on_gamma_h_slider_value_changed)

	motion_button.pressed.connect(
		_on_control_style_button_pressed.bind(InputX.InputMode.INPUT_GYRO),
	)

	touch_button.pressed.connect(
		_on_control_style_button_pressed.bind(InputX.InputMode.INPUT_TOUCH),
	)
