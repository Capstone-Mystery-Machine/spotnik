extends TaskNode
## Loads end-user's currently stored settings, if available.

func _task() -> void:
	if not UserSettings.has_file():
		return

	UserSettings.load()
