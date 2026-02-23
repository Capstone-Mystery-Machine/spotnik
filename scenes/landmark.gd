extends Node3D

var international_designator: String
var norad_catalog_id: String
var satellite_name: String
var country: String
var launch_date: int
var latitude: float
var longitude: float


func setup(
		id_designator: String,
		norad_id: String,
		sat_name: String,
		country_name: String,
		launch: int,
		lat: float,
		long: float,
) -> void:
	international_designator = id_designator
	norad_catalog_id = norad_id
	satellite_name = sat_name
	country = country_name
	launch_date = launch
	latitude = lat
	longitude = long


signal inner_entered(body: CollisionObject3D)
signal inner_exited(body: CollisionObject3D)
signal outer_entered(body: CollisionObject3D)
signal outer_exited(body: CollisionObject3D)


func _on_camera_pointer_detector_inner_entered(body: CollisionObject3D) -> void:
	emit_signal("inner_entered", body)
	SignalBus.ui_info.emit(self)


func _on_camera_pointer_detector_inner_exited(body: CollisionObject3D) -> void:
	emit_signal("inner_exited", body)


func _on_camera_pointer_detector_outer_entered(body: CollisionObject3D) -> void:
	emit_signal("outer_entered", body)


func _on_camera_pointer_detector_outer_exited(body: CollisionObject3D) -> void:
	emit_signal("outer_exited", body)
