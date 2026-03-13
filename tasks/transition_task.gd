extends TaskNode
## Loads a scene in a background thread and then transitions to it once the scene
## is fully loaded.

signal scene_loaded

## Represents the scene resource that will be switched to once it
## is successfully loaded.
@export_file("*.tscn") var target_scene_path: String

@onready var scene_tree: SceneTree = get_tree()


func _on_thread_load_loaded() -> void:
	var packed_scene = ResourceLoader.load_threaded_get(target_scene_path) as PackedScene

	scene_tree.change_scene_to_packed(packed_scene)
	scene_loaded.emit()


func _on_thread_load_failed() -> void:
	print("'TransitionTask._process': failed to load '%s' scene" % target_scene_path)
	scene_tree.quit(OSX.ExitCode.TRANSITION_LOAD_RESOURCE_FAILED)


func _on_thread_load_invalid_resource() -> void:
	print("'TransitionTask._process': '%s' is malformed" % target_scene_path)
	scene_tree.quit(OSX.ExitCode.TRANSITION_LOAD_RESOURCE_MALFORMED)


func _process(_delta: float) -> void:
	var status = ResourceLoader.load_threaded_get_status(target_scene_path)

	match status:
		ResourceLoader.THREAD_LOAD_LOADED:
			process_mode = Node.PROCESS_MODE_DISABLED
			_on_thread_load_loaded()
		ResourceLoader.THREAD_LOAD_FAILED:
			_on_thread_load_failed()
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			_on_thread_load_invalid_resource()


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED


func _task() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT

	ResourceLoader.load_threaded_request(target_scene_path)
	await scene_loaded
