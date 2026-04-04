class_name MainMenuScreen
extends Control

signal settings_button_pressed()

signal start_button_pressed()

@onready var settings_button: Button = %SettingsButton
@onready var start_button: Button = %StartButton


func _on_settings_button_pressed():
	settings_button_pressed.emit()


func _on_start_button_pressed():
	start_button_pressed.emit()


func _ready():
	settings_button.pressed.connect(_on_settings_button_pressed)
	start_button.pressed.connect(_on_start_button_pressed)
