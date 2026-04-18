class_name RootScene
extends Node

enum TransitionType {
	DEFAULT,
	TO_MAIN_MENU,
	FROM_MAIN_MENU,
}

@onready var alpha_tweener: TweenerX = %AlphaTweener
@onready var content_layer: ContentLayer = %ContentLayer
@onready var loading_ui_layer: LoadingUILayer = %LoadingUILayer
@onready var task_manager: TaskManager = %TaskManager
@onready var transition_tweener: TweenerX = %TransitionTweener

static var instance: RootScene:
	get:
		var scene_tree = Engine.get_main_loop() as SceneTree

		return scene_tree.current_scene

var _alpha_progress: float = 1.0

var _is_initial_boot: bool = true

var _transition_progress: float = 1.0

var _transition_type: TransitionType = TransitionType.DEFAULT

var alpha_progress: float:
	get:
		return _alpha_progress
	set(value):
		_alpha_progress = value

		if not is_node_ready():
			return

		content_layer.transition_progress = value

var transition_progress: float:
	get:
		return _transition_progress
	set(value):
		_transition_progress = value

		if not is_node_ready():
			return

		loading_ui_layer.transition_progress = value


func transition_from_main_menu(scene_path: String) -> void:
	var transition_tasks: Array[TaskNode] = [
		GeoLocationTask.new(),
	]

	await _transition_to(
		scene_path,
		TransitionType.FROM_MAIN_MENU,
		transition_tasks,
	)


func transition_to_main_menu() -> void:
	await _transition_to(
		"res://scenes/main_menu_scene.tscn",
		TransitionType.TO_MAIN_MENU,
	)


func transition_to_scene(scene_path: String) -> void:
	await _transition_to(
		scene_path,
		TransitionType.DEFAULT,
	)


func _play_transition_in(transition_type: TransitionType) -> void:
	_transition_type = transition_type

	match transition_type:
		TransitionType.FROM_MAIN_MENU:
			loading_ui_layer.transition_type = transition_type
		_:
			loading_ui_layer.transition_type = TransitionType.DEFAULT

	alpha_tweener.from_value = alpha_progress
	alpha_tweener.to_value = 1.0

	transition_tweener.from_value = transition_progress
	transition_tweener.to_value = 1.0

	alpha_tweener.play()
	transition_tweener.play()

	await transition_tweener.progress_ended


func _play_transition_out() -> void:
	match _transition_type:
		TransitionType.TO_MAIN_MENU:
			loading_ui_layer.transition_type = _transition_type
		_:
			loading_ui_layer.transition_type = TransitionType.DEFAULT

	alpha_tweener.from_value = alpha_progress
	alpha_tweener.to_value = 0.0

	transition_tweener.from_value = transition_progress
	transition_tweener.to_value = 0.0

	alpha_tweener.play()
	transition_tweener.play()

	await transition_tweener.progress_ended


func _transition_to(
		scene_path: String,
		transition_type: TransitionType = TransitionType.DEFAULT,
		tasks: Array[TaskNode] = [],
) -> void:
	ResourceLoader.load_threaded_request(scene_path)

	for task in tasks:
		task_manager.add_child(task)

	if _is_initial_boot:
		_is_initial_boot = false

		_transition_type = transition_type
		loading_ui_layer.transition_type = transition_type

	else:
		await _play_transition_in(transition_type)

	await task_manager.run_all_tasks()

	for child in content_layer.get_children():
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
			"bad argument #0 to 'RootScene.transition_to' (scene '%s' was not a 'PackedScene')"
			% scene_path,
		)

		return

	content_layer.add_child(target_scene.instantiate())
	await _play_transition_out()


func _ready() -> void:
	alpha_progress = 1.0
	transition_progress = 1.0

	var bootstrap_tasks: Array[TaskNode] = [
		PermissionTask.new(),
		GeoLocationTask.new(),
	]

	_transition_to(
		"res://scenes/main_menu_scene.tscn",
		TransitionType.TO_MAIN_MENU,
		bootstrap_tasks,
	)
