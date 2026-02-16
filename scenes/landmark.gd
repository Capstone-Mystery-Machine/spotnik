extends Node3D

signal inner_entered(body: CollisionObject3D)
signal inner_exited(body: CollisionObject3D)
signal outer_entered(body: CollisionObject3D)
signal outer_exited(body: CollisionObject3D)
signal ui_open
#signal ui_info(internationalDesignator, noradCatalogIdentifier, satellite_name, countryOfOrigin, launchDate, latitude, longitude)

var internationalDesignator = "1957-001P"
var noradCatalogIdentifier = "00001"
var satellite_name = "SPUTNIK-PANIK"
var countryOfOrigin = "USSR"
var launchDate = -386294400
var latitude = 45.1234
var longitude = -120.5432

#var internationalDesignator = "1969-069M"
#var noradCatalogIdentifier = "00404"
#var satellite_name = "ERR-SAT-NOT-FOUND"
#var countryOfOrigin = "INTERNET"
#var launchDate = -14159040
#var latitude = 12.0001
#var longitude = 98.7654


func _on_camera_pointer_detector_inner_entered(body: CollisionObject3D) -> void:
	emit_signal("inner_entered", body)
	emit_signal("ui_open")
	SignalBus.ui_info.emit(internationalDesignator, noradCatalogIdentifier, satellite_name, countryOfOrigin, launchDate, latitude, longitude)


func _on_camera_pointer_detector_inner_exited(body: CollisionObject3D) -> void:
	emit_signal("inner_exited", body)


func _on_camera_pointer_detector_outer_entered(body: CollisionObject3D) -> void:
	emit_signal("outer_entered", body)


func _on_camera_pointer_detector_outer_exited(body: CollisionObject3D) -> void:
	emit_signal("outer_exited", body)
