extends Node

const SatelliteDetailsScreenScene = preload("res://ui/screens/satellite_details_screen.tscn")

var _satellite_details_screen: SatelliteDetailsScreen = null


func _clear_ui() -> void:
	if _satellite_details_screen != null:
		_satellite_details_screen.queue_free()
		_satellite_details_screen = null


func _on_ui_enter(landmark: Landmark) -> void:
	_clear_ui()
	_satellite_details_screen = SatelliteDetailsScreenScene.instantiate() as SatelliteDetailsScreen

	add_child(_satellite_details_screen)
	_satellite_details_screen.update_satellite_details(landmark)


func _on_ui_exit() -> void:
	_clear_ui()


func _ready():
	SignalBus.instance.ui_enter.connect(_on_ui_enter)
	SignalBus.instance.ui_exit.connect(_on_ui_exit)
