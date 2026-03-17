extends TaskNode
## Applies all non-specific global user settings to the game engine.

func _task() -> void:
	print(
		"'ApplyGlobalUserSettingsTask._task': applying globally applicable user settings",
	)

	UserSettings.apply_global_settings()
