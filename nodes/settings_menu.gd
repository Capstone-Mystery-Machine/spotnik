extends Node2D

@onready var settings_canvas = %SettingsCanvas
@onready var low_button = %QualityLow
@onready var med_button = %QualityMed
@onready var high_button = %QualityHigh
@onready var gamma_slide = %GammaSlider


func _ready() -> void:
	SignalBus.instance.settings_open.connect(_settings_open)
	settings_canvas.visible = false


func _on_return_pressed() -> void:
	UserSettings.save()
	settings_canvas.visible = false


func _settings_open() -> void:
	gamma_slide.value = UserSettings.gamma
	settings_canvas.visible = true
	if (UserSettings.quality_profile == UserSettings.QualityProfile.LOW):
		low_button.button_pressed = true
	if (UserSettings.quality_profile == UserSettings.QualityProfile.MEDIUM):
		med_button.button_pressed = true
	if (UserSettings.quality_profile == UserSettings.QualityProfile.HIGH):
		high_button.button_pressed = true


func _on_gamma_slider_drag_ended(_value_changed: bool) -> void:
	UserSettings.gamma = gamma_slide.value


func _on_quality_low_pressed() -> void:
	UserSettings.quality_profile = UserSettings.QualityProfile.LOW


func _on_quality_med_pressed() -> void:
	UserSettings.quality_profile = UserSettings.QualityProfile.MEDIUM


func _on_quality_high_pressed() -> void:
	UserSettings.quality_profile = UserSettings.QualityProfile.HIGH
