class_name MainMenuScreen
extends Control

@onready var scene_tree: SceneTree = get_tree()

@onready var start_button: Button = %StartButton


func _on_start_button_pressed():
	var loading_tasks: Array[TaskNode] = [
		GeoLocationTask.new(),
	]

	RootScene.instance.transition_to(
		preload("res://scenes/viewer_scene.tscn"),
		RootScene.TransitionType.DEFAULT,
		loading_tasks,
	)


func _ready():
	start_button.pressed.connect(_on_start_button_pressed)
