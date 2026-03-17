extends TaskNode
## Applies all non-specific global user settings to the game engine.

func _task() -> void:
	UserSettings.apply_global_settings()
