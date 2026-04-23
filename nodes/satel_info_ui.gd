class_name SatelUI
extends Node3D

@onready var satellite_details_screen: SatelliteDetailsScreen = %SatelliteDetailsScreen

var content_alpha: float = 1.0:
	set(value):
		content_alpha = value

		if not is_node_ready():
			return

		satellite_details_screen.modulate.a = value


func setup_satel_ui(landmark: Landmark) -> void:
	satellite_details_screen.update_satellite_details(landmark)
