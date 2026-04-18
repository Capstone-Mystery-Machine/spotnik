class_name InputX
extends RefCounted
## A singleton for handling Spotnik-specific input logic.
##
## The [b]InputX[/b] singleton handles the selection of which input mode Spotnik
## is currently running in.

signal input_mode_changed(input_mode: InputMode)

## Represents the input modes that defines how the end-user interacts with
## Spotnik.
## [br]
## [br]
## Each input mode:
## [br]
## • Changes how the end-user interacts with the application.
## [br]
## • Has its own criteria for enablement.
enum InputMode {
	## Spotnik is configured with no input mode.
	## [br]
	## [br]
	## [b]3D Environment Controls:[/b] None.
	## [br]
	## [b]UI Controls:[/b] None.
	## [br]
	## [b]Enablement Criterion:[/b] No user settings or platform configuration found.
	INPUT_NONE,

	## Spotnik is configured to be in mouse input mode.
	## [br]
	## [br]
	## [b]3D Environment Controls:[/b] Cursor point, click, and drag.
	## [br]
	## [b]UI Controls:[/b] Standard mouse and keyboard.
	## [br]
	## [b]Enablement Criterion:[/b] The end-user is using a desktop platform.
	INPUT_MOUSE,

	## Spotnik is configured to be in motion input mode.
	## [br]
	## [br]
	## [b]3D Environment Controls:[/b] Finger point, tap, and drag.
	## [br]
	## [b]UI Controls:[/b] Standard touch and virtual keyboards.
	## [br]
	## [b]Enablement Criterion:[/b] The end-user is using a mobile platform
	## while both [code]input_devices/sensors/enable_gravity[/code] and
	## [code]input_devices/sensors/enable_magnetometer[/code] project settings
	## were enabled at export-time.
	INPUT_MOTION,

	## Spotnik is configured to be in touch input mode.
	## [br]
	## [br]
	## [b]3D Environment Controls:[/b] Finger point, tap, and drag.
	## [br]
	## [b]UI Controls:[/b] Standard touch and virtual keyboards.
	## [br]
	## [b]Enablement Criterion:[/b] The end-user is using a mobile platform
	## while either [code]input_devices/sensors/enable_gravity[/code] or
	## [code]input_devices/sensors/enable_magnetometer[/code] project settings
	## were not enabled at export-time.
	INPUT_TOUCH,
}

## Represents the error thresholds (in degrees) used to classify sensor movement,
## where [code]x[/code] is the jitter threshold and [code]y[/code] is the movement
## threshold.
## [br]
## • [b]X:[/b] Readings inclusively below this value are treated as unintentional
##   noise and smoothed heavily.
## [br]
## • [b]Y:[/b] Readings inclusively above this value are treated as deliberate
##   movement by the end-user.
const ERROR_THRESHOLDS: Vector2 = Vector2(
	deg_to_rad(1.5),
	deg_to_rad(10.0),
)

## Represents the target smoothing speeds applied to the camera, where [code]x[/code]
## is the minimum speed and [code]y[/code] is the maximum speed.
const SMOOTHING_LIMITS: Vector2 = Vector2(0.5, 18.0)

## Represents the internally cached [InputX] singleton.
static var _instance: InputX

## Represents the [InputX] singleton.
static var instance: InputX:
	get:
		if _instance == null:
			_instance = InputX.new()
		return _instance

## Represents which member of [enum InputMode] was evaluated at boot-time as
## being enabled.
static var platform_input_mode: InputMode = _get_platform_input_mode()

## Represents which member of [enum InputMode] was selected by the end-user.
## [br]
## Returns [code]null[/code] if no configuration is available.
static var preferred_input_mode: InputMode:
	get:
		return UserSettings.input_mode

## Represents which member of [enum InputMode] was selected by the end-user,
## if available. If not, then the platform
static var input_mode: InputMode:
	get:
		if preferred_input_mode != InputMode.INPUT_NONE:
			return preferred_input_mode
		return platform_input_mode

## Represents the internally cached and smoothed directional vector for Earth's
## gravity.
var _filtered_gravitational_direction: Vector3 = Vector3.ZERO

## Represents the internally cached and smoothed directional vector for Earth's
## magnetic field.
var _filtered_magnetic_direction: Vector3 = Vector3.ZERO


## Returns the raw gravitational force from the device's sensor.
## [br]
## A failsafe is applied to return a default downward vector if the sensor
## reading is entirely zero.
static func _get_gravitational_force() -> Vector3:
	var gravitational_force = Input.get_gravity()

	if gravitational_force.length_squared() < 0.01:
		return Vector3(0.0, -9.8, 0.0)

	return gravitational_force


## Returns the raw magnetic field from the device's sensor.
## [br]
## A failsafe is applied to return a default forward vector if the sensor
## reading is entirely zero.
static func _get_magnetic_field() -> Vector3:
	var magnetic_field = Input.get_magnetometer()

	if magnetic_field.length_squared() < 0.01:
		return Vector3(0.0, 0.0, -1.0)

	return magnetic_field


## Returns which member of [enum InputMode] is currently enabled. The default is
## [constant InputMode.INPUT_MOUSE].
static func _get_platform_input_mode() -> InputMode:
	if _is_platform_motion_input_mode():
		return InputMode.INPUT_MOTION

	if _is_platform_touch_input_mode():
		return InputMode.INPUT_TOUCH

	return InputMode.INPUT_MOUSE


## Returns [code]true[/code] the enablement criteria for [constant InputMode.INPUT_MOTION]
## is currently valid.
static func _is_platform_motion_input_mode() -> bool:
	return (OS.has_feature("mobile")
		and ProjectSettings.get_setting("input_devices/sensors/enable_gravity")
		and ProjectSettings.get_setting("input_devices/sensors/enable_magnetometer") )


## Returns [code]true[/code] the enablement criteria for [constant InputMode.INPUT_MOUSE]
## is currently valid.
static func _is_platform_mouse_input_mode() -> bool:
	return !OS.has_feature("mobile")


## Returns [code]true[/code] the enablement criteria for [constant InputMode.INPUT_TOUCH]
## is currently valid.
static func _is_platform_touch_input_mode() -> bool:
	return (OS.has_feature("mobile")
		and (
			!ProjectSettings.get_setting("input_devices/sensors/enable_gravity")
			or !ProjectSettings.get_setting("input_devices/sensors/enable_magnetometer") )
	)


## Returns a [Basis] aligned with Earth's coordinate system. Optionally accepts
## custom directional vectors to build the [Basis] from.
static func get_geocentric_basis(
		gravitational_direction: Vector3 = _get_gravitational_force().normalized(),
		magnetic_direction: Vector3 = _get_magnetic_field().normalized(),
) -> Basis:
	var gravitational_up = -gravitational_direction
	var magnetic_north = magnetic_direction

	var cardinal_east = magnetic_north.cross(gravitational_up)

	if cardinal_east.length_squared() < 0.001:
		cardinal_east = Vector3.RIGHT

	cardinal_east = cardinal_east.normalized()

	var cardinal_north = gravitational_up.cross(cardinal_east).normalized()
	var cardinal_south = -cardinal_north

	return Basis(cardinal_east, gravitational_up, cardinal_south).transposed()


## Returns a [Basis] aligned with Earth's coordinate system using the internally
## smoothed sensor data.
func get_geocentric_basis_smoothed() -> Basis:
	return InputX.get_geocentric_basis(
		_filtered_gravitational_direction,
		_filtered_magnetic_direction,
	)


## Polls and smooths input sensor data every engine tick.
func _process(delta: float) -> void:
	var gravitational_direction = _get_gravitational_force().normalized()
	var magnetic_direction = _get_magnetic_field().normalized()

	if _filtered_gravitational_direction == Vector3.ZERO:
		_filtered_gravitational_direction = gravitational_direction
		_filtered_magnetic_direction = magnetic_direction

	var magnetic_angle = _filtered_magnetic_direction.angle_to(magnetic_direction)
	var gravitational_angle = _filtered_gravitational_direction.angle_to(gravitational_direction)

	var max_angle = max(magnetic_angle, gravitational_angle)
	var weight = clamp(
		(max_angle - ERROR_THRESHOLDS.x) / (ERROR_THRESHOLDS.y - ERROR_THRESHOLDS.x),
		0.0,
		1.0,
	)

	var dynamic_speed = lerp(
		SMOOTHING_LIMITS.x,
		SMOOTHING_LIMITS.y,
		smoothstep(0.0, 1.0, weight),
	)

	var frame_independent_weight = 1.0 - exp(-dynamic_speed * delta)

	_filtered_gravitational_direction = _filtered_gravitational_direction.slerp(
		gravitational_direction,
		frame_independent_weight,
	).normalized()

	_filtered_magnetic_direction = _filtered_magnetic_direction.slerp(
		magnetic_direction,
		frame_independent_weight,
	).normalized()


func _on_user_setting_changed(
		setting_name: Array,
		new_value: InputMode,
		_old_value: InputMode,
) -> void:
	if setting_name != UserSettings.SettingName.INPUT_MODE:
		return

	instance.input_mode_changed.emit(new_value)


func _init() -> void:
	UserSettings.instance.setting_changed.connect(_on_user_setting_changed)

	var scene_tree = (Engine.get_main_loop() as SceneTree)
	scene_tree.process_frame.connect(
		func():
			_process(scene_tree.root.get_process_delta_time())
	)
