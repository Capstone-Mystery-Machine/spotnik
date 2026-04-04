extends Node3D

@onready var _main_menu_screen: MainMenuScreen = %MainMenuScreen


func _on_settings_button_pressed() -> void:
	SettingsMenu.open()


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/loading_scene.tscn")


func _ready() -> void:
	_main_menu_screen.settings_button_pressed.connect(_on_settings_button_pressed)
	_main_menu_screen.start_button_pressed.connect(_on_start_button_pressed)
