class_name SettingsButtonScreen
extends MarginContainer

signal settings_button_pressed()

@onready var settings_button: Button = %SettingsButton


func _on_settings_button_pressed():
	settings_button_pressed.emit()


func _ready():
	settings_button.pressed.connect(_on_settings_button_pressed)
