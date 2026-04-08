class_name MainMenuScreen
extends Control

@onready var scene_tree: SceneTree = get_tree()

@onready var start_button: Button = %StartButton


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/loading_scene.tscn")


func _ready():
	start_button.pressed.connect(_on_start_button_pressed)
