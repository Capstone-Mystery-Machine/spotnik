extends Node3D

func _on_view_sky_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/loading_scene.tscn")


func _on_settings_button_pressed() -> void:
	SignalBus.instance.settings_open.emit()
