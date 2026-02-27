extends Node
## Requests the permissions required by the app's export target when the node
## is made ready.

@onready var scene_tree: SceneTree = get_tree()


func _on_dialog_ok(_button_index: int) -> void:
	scene_tree.quit(OSX.ExitCode.PERMISSION_NOT_GRANTED)


func _on_request_permissions_result(_permission: String, granted: bool) -> void:
	if granted:
		return

	if scene_tree.on_request_permissions_result.is_connected(_on_request_permissions_result):
		scene_tree.on_request_permissions_result.disconnect(_on_request_permissions_result)

	DisplayServer.dialog_show(
		"Permission Not Granted",
		"Spotnik was not granted a required permission. The app will exit now.",
		PackedStringArray(["OK"]),
		_on_dialog_ok,
	)


func _ready() -> void:
	if not OSX.permission_request_required():
		return

	if not OS.request_permissions():
		scene_tree.on_request_permissions_result.connect(_on_request_permissions_result)
