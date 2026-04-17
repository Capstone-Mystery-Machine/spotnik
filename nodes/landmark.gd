class_name Landmark
extends Node3D

signal inner_entered(body: CollisionObject3D)
signal inner_exited(body: CollisionObject3D)
signal outer_entered(body: CollisionObject3D)
signal outer_exited(body: CollisionObject3D)

## Represents the maximum scale size the satellite node will grow to.
@export var max_scale: float = 5.0
## Represents the speed at which the satellite meshes scale (stay between 5-12).
@export var scale_speed: float = 8.0
## Represents the speed of the simulation (x1 being real time).
@export var simulation_speed: float = 60.0

var earth_mu: float = 398600.4418
var international_designator: String
var norad_catalog_id: String
var satellite_name: String
var country: String
var launch_date: String
var epoch: String

var acc: Vector3 = Vector3.ZERO
var pos: Vector3 = Vector3.ZERO
var vel: Vector3 = Vector3.ZERO

var is_on_screen: bool = false

@onready var detector: Area3D = $CameraPointerDetector
@onready var outer_shape: CollisionShape3D = $CameraPointerDetector/CollisionShape3D
@onready var screen_notifier: VisibleOnScreenNotifier3D = $SatelliteOnScreenDetect

var outer_radius: float
var inner_radius: float
var pointer: CollisionObject3D
var visual_scale: float = 1.0


func setup_from_orbital_data(data: Dictionary) -> void:
	international_designator = str(data.get("OBJECT_ID", ""))
	norad_catalog_id = str(data.get("NORAD_CAT_ID", ""))
	satellite_name = str(data.get("OBJECT_NAME", ""))
	country = str(data.get("COUNTRY_CODE", ""))
	launch_date = str(data.get("LAUNCH_DATE", ""))
	epoch = str(data.get("EPOCH", ""))

	var state := OrbitalMath.elements_to_state_vectors(data)

	pos = state["position"]
	vel = state["velocity"]
	acc = compute_gravity()

	position = Vector3.ZERO


func _ready() -> void:
	outer_radius = outer_shape.shape.radius
	inner_radius = detector.inner_radius

	screen_notifier.screen_entered.connect(_on_screen_entered)
	screen_notifier.screen_exited.connect(_on_screen_exited)
	is_on_screen = screen_notifier.is_on_screen()

	detector.monitoring = false
	detector.monitorable = false
	outer_shape.disabled = true


func _physics_process(delta: float) -> void:
	update_orbit_motion(delta)
	update_visual_scale(delta)


func update_orbit_motion(delta: float) -> void:
	var dt: float = delta * simulation_speed

	vel += acc * (dt * 0.5)
	pos += vel * dt
	acc = compute_gravity()
	vel += acc * (dt * 0.5)


func set_visual_direction(dir: Vector3, radius: float) -> void:
	position = dir.normalized() * radius


func set_hidden_state() -> void:
	visible = false
	set_interaction_enabled(false)


func set_interaction_enabled(active: bool) -> void:
	detector.monitoring = active
	detector.monitorable = active
	outer_shape.disabled = not active

	if not active:
		pointer = null
		visual_scale = 1.0


func update_visual_scale(delta: float) -> void:
	var weight: float = min(scale_speed * delta, 1.0)

	if pointer == null:
		visual_scale = lerp(visual_scale, 1.0, weight)
		return

	if outer_radius <= inner_radius:
		return

	var distance: float = global_position.distance_to(pointer.global_position)

	var t: float = 1.0 - clamp(
		(distance - inner_radius) / (outer_radius - inner_radius),
		0.0,
		1.0,
	)

	var target_scale: float = lerp(1.0, max_scale, t)
	visual_scale = lerp(visual_scale, target_scale, weight)


func compute_gravity() -> Vector3:
	var r: float = pos.length()

	if r <= 0.000001:
		return Vector3.ZERO

	return (-earth_mu / pow(r, 3)) * pos


func _on_screen_entered() -> void:
	is_on_screen = true


func _on_screen_exited() -> void:
	is_on_screen = false
	pointer = null
	visual_scale = 1.0


func _on_camera_pointer_detector_inner_entered(body: CollisionObject3D) -> void:
	emit_signal("inner_entered", body)
	SignalBus.instance.ui_info.emit(self)


func _on_camera_pointer_detector_inner_exited(body: CollisionObject3D) -> void:
	emit_signal("inner_exited", body)


func _on_camera_pointer_detector_outer_entered(body: CollisionObject3D) -> void:
	pointer = body
	emit_signal("outer_entered", body)


func _on_camera_pointer_detector_outer_exited(body: CollisionObject3D) -> void:
	if pointer == body:
		pointer = null
	emit_signal("outer_exited", body)
