class_name RootScene
extends Node

@onready var taskManager: TaskManager = %TaskManager

static var instance: RootScene:
	get:
		var scene_tree = Engine.get_main_loop() as SceneTree

		return scene_tree.current_scene
