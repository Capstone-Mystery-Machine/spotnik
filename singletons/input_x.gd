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


## Returns a normalized [Vector3] pointing to Earth's cardinal East.
static func get_cardinal_east(gravitational_up: Vector3) -> Vector3:
	var magnetic_field = Input.get_magnetometer()
	var magnetic_north = magnetic_field.normalized()

	return magnetic_north.cross(gravitational_up).normalized()


## Returns a normalized [Vector3] pointing to Earth's cardinal North.
static func get_cardinal_north(cardinal_east: Vector3, gravitational_up: Vector3) -> Vector3:
	return gravitational_up.cross(cardinal_east).normalized()


## Returns a [Basis] aligned with Earth's coordinate system.
static func get_geocentric_basis() -> Basis:
	var gravitational_down = get_gravitational_down()
	var gravitational_up = -gravitational_down

	var cardinal_east = get_cardinal_east(gravitational_up)
	var cardinal_north = get_cardinal_north(cardinal_east, gravitational_up)
	var cardinal_south = -cardinal_north

	return Basis(cardinal_east, gravitational_up, cardinal_south).inverse()


## Returns a new [Basis] that smoothly interpolates from the [param current_basis]
## towards an Earth-aligned geocentric [Basis].
## [br]
## [param error_thresholds] expects X to be the jitter threshold and Y to be the
## movement threshold.
## [param smoothing_limits] expects X to be the min smoothing and Y to be the max
## smoothing.
static func get_geocentric_basis_smoothed(
		current_basis: Basis,
		delta: float,
		error_thresholds: Vector2 = Vector2(0.0, 0.0),
		smoothing_limits: Vector2 = Vector2(1.0, 1.0),
) -> Basis:
	var target_basis = get_geocentric_basis()

	var alignment = current_basis.z.dot(target_basis.z)
	var error = abs(1.0 - alignment)

	var dynamic_smoothing = remap(
		error,
		error_thresholds.x, # jitter
		error_thresholds.y, # movement
		smoothing_limits.x, # min
		smoothing_limits.y, # max
	)

	dynamic_smoothing = clamp(
		dynamic_smoothing,
		smoothing_limits.x,
		smoothing_limits.y,
	)

	return current_basis.slerp(
		target_basis,
		dynamic_smoothing * delta,
	)


## Returns an Euler angles [Vector3] aligned with Earth's coordinate system.
static func get_geocentric_euler() -> Vector3:
	var geocentric_basis = get_geocentric_basis()

	return geocentric_basis.get_euler()


## Returns a [Quaternion] aligned with Earth's coordinate system.
static func get_geocentric_quaternion() -> Quaternion:
	var geocentric_basis = get_geocentric_basis()

	return geocentric_basis.get_rotation_quaternion()


## Returns a [Transform3D] aligned with Earth's coordinate system.
static func get_geocentric_transform() -> Transform3D:
	var geocentric_basis = get_geocentric_basis()

	return Transform3D(geocentric_basis, Vector3.ZERO)


## Returns a normalized [Vector3] pointing in the direction of Earth's gravity.
static func get_gravitational_down() -> Vector3:
	var gravitational_force = Input.get_gravity()

	return gravitational_force.normalized()


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
