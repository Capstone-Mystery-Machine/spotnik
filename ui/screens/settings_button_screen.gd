class_name SettingsButtonScreen
extends MarginContainer

@onready var settings_button: Button = %SettingsButton


func _on_settings_button_pressed():
	SettingsMenu.open()


func _ready():
	settings_button.pressed.connect(_on_settings_button_pressed)
