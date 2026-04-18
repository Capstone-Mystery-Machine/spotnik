class_name RootScene
extends Node

enum TransitionType {
	DEFAULT,
}

@onready var content_container: Node = %ContentContainer
@onready var settings_ui_layer: SettingsUILayer = %SettingsUILayer
@onready var task_manager: TaskManager = %TaskManager

static var instance: RootScene:
	get:
		var scene_tree = Engine.get_main_loop() as SceneTree

		return scene_tree.current_scene


func transition_to(
		target_scene: PackedScene,
		transition_type: TransitionType = TransitionType.DEFAULT,
		tasks: Array[TaskNode] = [],
) -> void:
	settings_ui_layer.visible = false

	for task in tasks:
		task_manager.add_child(task)

	print("animate in")

	await task_manager.run_all_tasks()

	for child in content_container.get_children():
		child.queue_free()

	if target_scene:
		content_container.add_child(target_scene.instantiate())

	print("animate out")

	settings_ui_layer.visible = true


func _ready() -> void:
	var bootstrap_tasks: Array[TaskNode] = [
		PermissionTask.new(),
		GeoLocationTask.new(),
	]

	transition_to(
		preload("res://scenes/main_menu_scene.tscn"),
		TransitionType.DEFAULT,
		bootstrap_tasks,
	)
