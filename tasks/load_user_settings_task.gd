extends TaskNode
## Loads end-user's currently stored settings, if available.

func _task() -> void:
	print(
		"'LoadUserSettingsTask._task': trying to load user settings on disk",
	)

	if not UserSettings.has_file():
		print(
			"'LoadUserSettingsTask._task': user settings not found on disk, skipping",
		)

		return

	print(
		"'LoadUserSettingsTask._task': user settings found on disk, loading",
	)

	UserSettings.load()
