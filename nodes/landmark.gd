class_name Landmark
extends Node3D

signal inner_entered(body: CollisionObject3D)
signal inner_exited(body: CollisionObject3D)
signal outer_entered(body: CollisionObject3D)
signal outer_exited(body: CollisionObject3D)

## Represents the maximum scale size the satellite node will grow to.
@export var max_scale: float = 5.0
## Represents the distance between the camera and where satellites spawn.
@export var spawn_radius: float = 10.0
## Represents the speed at which the satellite meshes scale (stay between 5-12).
@export var scale_speed: float = 8.0

var international_designator: String
var norad_catalog_id: String
var satellite_name: String
var country: String
var launch_date: int
var latitude: float
var longitude: float

@onready var detector: Area3D = $CameraPointerDetector
@onready var outer_shape: CollisionShape3D = $CameraPointerDetector/CollisionShape3D
@onready var screen_notifier: VisibleOnScreenNotifier3D = $SatelliteOnScreenDetect

var outer_radius: float
var inner_radius: float
var pointer: CollisionObject3D
var visual_scale: float = 1.0


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


func _ready() -> void:
	outer_radius = outer_shape.shape.radius
	inner_radius = detector.inner_radius

	screen_notifier.screen_entered.connect(_on_screen_entered)
	screen_notifier.screen_exited.connect(_on_screen_exited)
	_set_active(screen_notifier.is_on_screen())


func _physics_process(delta: float) -> void:
	var weight: float = min(scale_speed * delta, 1.0)

	if pointer == null:
		visual_scale = lerp(visual_scale, 1.0, weight)
		return

	if outer_radius <= inner_radius:
		return

	var distance = global_position.distance_to(pointer.global_position)

	var t = 1.0 - clamp(
		(distance - inner_radius) / (outer_radius - inner_radius),
		0.0,
		1.0,
	)

	var target_scale = lerp(1.0, max_scale, t)
	visual_scale = lerp(visual_scale, target_scale, weight)


func _set_active(active: bool) -> void:
	set_physics_process(active)
	detector.monitoring = active
	detector.monitorable = active

	if not active:
		pointer = null
		visual_scale = 1.0


func _on_screen_entered() -> void:
	_set_active(true)


func _on_screen_exited() -> void:
	_set_active(false)


func _on_camera_pointer_detector_inner_entered(body: CollisionObject3D) -> void:
	emit_signal("inner_entered", body)
	SignalBus.instance.ui_info.emit(self)


func _on_camera_pointer_detector_inner_exited(body: CollisionObject3D) -> void:
	emit_signal("inner_exited", body)


func _on_camera_pointer_detector_outer_entered(body: CollisionObject3D) -> void:
	pointer = body
	emit_signal("outer_entered", body)


func _on_camera_pointer_detector_outer_exited(body: CollisionObject3D) -> void:
	pointer = null
	emit_signal("outer_exited", body)
