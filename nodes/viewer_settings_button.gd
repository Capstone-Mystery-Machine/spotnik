extends Node2D

func _on_viewer_settings_button_pressed() -> void:
	SignalBus.instance.settings_open.emit()
