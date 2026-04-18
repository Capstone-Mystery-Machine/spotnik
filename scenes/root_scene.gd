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
		scene_path: String,
		transition_type: TransitionType = TransitionType.DEFAULT,
		tasks: Array[TaskNode] = [],
) -> void:
	settings_ui_layer.visible = false

	ResourceLoader.load_threaded_request(scene_path)

	for task in tasks:
		task_manager.add_child(task)

	print("animate in")

	await task_manager.run_all_tasks()

	for child in content_container.get_children():
		child.queue_free()

	var status = ResourceLoader.load_threaded_get_status(scene_path)

	while status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		await get_tree().process_frame

		status = ResourceLoader.load_threaded_get_status(scene_path)

	if status != ResourceLoader.THREAD_LOAD_LOADED:
		push_error(
			"bad argument #0 to 'RootScene.transition_to' (scene '%s' failed to load )"
			% scene_path,
		)

		return

	var target_scene = ResourceLoader.load_threaded_get(scene_path) as PackedScene

	if not target_scene:
		push_error(
			"bad argument #0 to 'RootScene.transition_to (scene '%s' was not a `PackedScene`)"
			% scene_path,
		)

		return

	content_container.add_child(target_scene.instantiate())

	print("animate out")

	settings_ui_layer.visible = true


func _ready() -> void:
	var bootstrap_tasks: Array[TaskNode] = [
		PermissionTask.new(),
		GeoLocationTask.new(),
	]

	transition_to(
		"res://scenes/main_menu_scene.tscn",
		TransitionType.DEFAULT,
		bootstrap_tasks,
	)
