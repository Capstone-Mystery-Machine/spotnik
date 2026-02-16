extends Node3D

var international_designator: String
var norad_catalog_id: String
var satellite_name: String
var country: String
var launch_date: int

func setup(
	id_designator: String,
	norad_id: String,
	satName: String,
	country_name: String,
	launch: int
) -> void:
	international_designator = id_designator
	norad_catalog_id = norad_id
	satellite_name = satName
	country = country_name
	launch_date = launch

signal inner_entered(body: CollisionObject3D)
signal inner_exited(body: CollisionObject3D)
signal outer_entered(body: CollisionObject3D)
signal outer_exited(body: CollisionObject3D)
signal ui_open


func _on_camera_pointer_detector_inner_entered(body: CollisionObject3D) -> void:
	emit_signal("inner_entered", body)
	emit_signal("ui_open")


func _on_camera_pointer_detector_inner_exited(body: CollisionObject3D) -> void:
	emit_signal("inner_exited", body)


func _on_camera_pointer_detector_outer_entered(body: CollisionObject3D) -> void:
	emit_signal("outer_entered", body)


func _on_camera_pointer_detector_outer_exited(body: CollisionObject3D) -> void:
	emit_signal("outer_exited", body)
