extends Node
## Requests the permissions required by the app's export target when the node
## is made ready.

# gdlint-ignore-next-line constant-name
const PermissionName = {
	ANDROID_COARSE_LOCATION = &"android.permission.ACCESS_COARSE_LOCATION",
	ANDROID_FINE_LOCATION = &"android.permission.ACCESS_FINE_LOCATION",
}

var _was_geo_location_initialized: bool = false

@onready var scene_tree: SceneTree = get_tree()


func _on_all_permissions_granted() -> void:
	_on_geo_location_permission_granted()


func _on_geo_location_permission_granted() -> void:
	print(
		"'PermissionManager._on_geo_location_permission_granted': geo-location permission granted",
	)

	GeoLocation.instance.init_provider()
	_was_geo_location_initialized = true


func _on_permission_declined(permission: String) -> void:
	match permission:
		PermissionName.ANDROID_COARSE_LOCATION:
			if PermissionName.ANDROID_FINE_LOCATION in OS.get_granted_permissions():
				return
		PermissionName.ANDROID_FINE_LOCATION:
			if PermissionName.ANDROID_COARSE_LOCATION in OS.get_granted_permissions():
				return

	if scene_tree.on_request_permissions_result.is_connected(_on_request_permissions_result):
		scene_tree.on_request_permissions_result.disconnect(_on_request_permissions_result)

	DisplayServer.dialog_show(
		"Permission Not Granted",
		"Spotnik was not granted a required permission. The app will exit now.",
		PackedStringArray(["OK"]),
		func(_button_index: int):
			print(
				"'PermissionManager._on_permission_declined': permission '%s' was not granted, exiting"
				% permission,
			)

			scene_tree.quit(OSX.ExitCode.PERMISSION_NOT_GRANTED),
	)


func _on_permission_granted(permission: String) -> void:
	match permission:
		PermissionName.ANDROID_COARSE_LOCATION, PermissionName.ANDROID_FINE_LOCATION:
			if not _was_geo_location_initialized:
				_on_geo_location_permission_granted()


func _on_request_permissions_result(permission: String, granted: bool) -> void:
	if granted:
		_on_permission_granted(permission)

	else:
		_on_permission_declined(permission)


func _ready() -> void:
	print("'PermissionManager._ready': trying to request permissions")

	if not OSX.permission_request_required() or OS.request_permissions():
		print(
			"'PermissionManager._ready': permissions were already granted or not needed, skipping",
		)

		_on_all_permissions_granted()
		return

	scene_tree.on_request_permissions_result.connect(_on_request_permissions_result)
