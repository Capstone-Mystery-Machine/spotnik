class_name PermissionTask
extends TaskNode
## Requests the permissions required by the app's export target when the task
## is requested to run.
## [br]
## [b]NOTE:[/b] This task should only be ran once per-boot of Spotnik.

signal permissions_granted

# gdlint-ignore-next-line constant-name
const PermissionName = {
	ANDROID_COARSE_LOCATION = &"android.permission.ACCESS_COARSE_LOCATION",
	ANDROID_FINE_LOCATION = &"android.permission.ACCESS_FINE_LOCATION",
}

# gdlint-ignore-next-line constant-name
const PermissionKey = {
	PermissionName.ANDROID_COARSE_LOCATION: true,
	PermissionName.ANDROID_FINE_LOCATION: true,
}

var _expected_responses: int = 0

@onready var scene_tree: SceneTree = get_tree()


func _dialog_permission_declined(permission: String) -> void:
	DisplayServer.dialog_show(
		"Permission Not Granted",
		"Spotnik was not granted a required permission: '" \
				+ permission + "'. The app will exit now.",
		PackedStringArray(["OK"]),
		func(_button_index: int):
			print(
				"'PermissionTask._dialog_declined': exiting due to declined '%s' permission"
				% permission,
			)

			scene_tree.quit(OSX.ExitCode.PERMISSION_NOT_GRANTED),
	)


func _on_all_permissions_resolved() -> void:
	var granted := OS.get_granted_permissions()

	var has_location_permission = PermissionName.ANDROID_COARSE_LOCATION in granted \
	or PermissionName.ANDROID_FINE_LOCATION in granted

	if not has_location_permission:
		_dialog_permission_declined("location")
		return

	permissions_granted.emit()


func _on_request_permissions_result(permission: String, _granted: bool) -> void:
	if permission in PermissionKey:
		_expected_responses -= 1

	if _expected_responses <= 0:
		if scene_tree.on_request_permissions_result.is_connected(_on_request_permissions_result):
			scene_tree.on_request_permissions_result.disconnect(_on_request_permissions_result)

		_on_all_permissions_resolved()


func _task() -> void:
	print("'PermissionTask._task': trying to request permissions")

	if not OSX.permission_request_required():
		print("'PermissionTask._task': permissions requests not needed, skipping requests")

		return

	var granted_permissions := OS.get_granted_permissions()

	for permission_key in PermissionKey:
		if permission_key not in granted_permissions:
			_expected_responses += 1

	if _expected_responses == 0 or OS.request_permissions():
		print("'PermissionTask._task': permissions were already granted, skipping requests")

		return

	scene_tree.on_request_permissions_result.connect(_on_request_permissions_result)

	await permissions_granted
