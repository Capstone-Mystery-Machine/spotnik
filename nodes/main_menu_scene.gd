extends Node3D

@onready var main_menu_screen: MainMenuScreen = %MainMenuScreen


func _on_settings_button_pressed() -> void:
	pass


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/loading_scene.tscn")


func _ready() -> void:
	main_menu_screen.settings_button_pressed.connect(_on_settings_button_pressed)
	main_menu_screen.start_button_pressed.connect(_on_start_button_pressed)
