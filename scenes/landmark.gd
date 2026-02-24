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

## Represents the maximum scale size the satellite node will grow to.
@export var max_scale: float = 5.0

@onready var detector: Area3D = $CameraPointerDetector
@onready var outer_shape: CollisionShape3D = $CameraPointerDetector/CollisionShape3D

var outer_radius: float
var inner_radius: float


func _ready() -> void:
	outer_radius = outer_shape.shape.radius
	inner_radius = detector.inner_radius


func _process(delta: float) -> void:
	if detector.outer_bodies.is_empty():
		scale = scale.lerp(Vector3.ONE, 10.0 * delta)
		return

	var body = detector.outer_bodies.keys()[0.0]
	var distance = global_position.distance_to(body.global_position)

	var t = 1.0 - clamp(
		(distance - inner_radius) / (outer_radius - inner_radius),
		0.0,
		1.0,
	)

	var target_scale = lerp(1.0, max_scale, t)

	scale = scale.lerp(Vector3.ONE * target_scale, 10.0 * delta)


func _on_camera_pointer_detector_inner_entered(body: CollisionObject3D) -> void:
	emit_signal("inner_entered", body)
	SignalBus.ui_info.emit(self)


func _on_camera_pointer_detector_inner_exited(body: CollisionObject3D) -> void:
	emit_signal("inner_exited", body)


func _on_camera_pointer_detector_outer_entered(body: CollisionObject3D) -> void:
	emit_signal("outer_entered", body)


func _on_camera_pointer_detector_outer_exited(body: CollisionObject3D) -> void:
	emit_signal("outer_exited", body)
