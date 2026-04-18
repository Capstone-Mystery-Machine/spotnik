class_name MainMenuScreen
extends Control

@onready var scene_tree: SceneTree = get_tree()

@onready var start_button: Button = %StartButton


func _on_start_button_pressed():
	RootScene.instance.transition_from_main_menu(
		"res://scenes/viewer_scene.tscn",
	)


func _ready():
	start_button.pressed.connect(_on_start_button_pressed)
