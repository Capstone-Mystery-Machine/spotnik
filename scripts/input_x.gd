class_name InputX
extends Node
## A singleton for handling Spotnik-specific input logic.
##
## The [b]InputX[/b] singleton handles the selection of which input mode Spotnik
## is currently running in.

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
	## Spotnik is configured to be in mouse input mode.
	## [br]
	## [br]
	## [b]3D Environment Controls:[/b] Cursor point, click, and drag.
	## [br]
	## [b]UI Controls:[/b] Standard mouse and keyboard.
	## [br]
	## [b]Enablement Criterion:[/b] The end-user is using a desktop platform.
	INPUT_MOUSE,
	## Spotnik is configured to be in gyro input mode.
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
	INPUT_GYRO,
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

## Represents which member of [enum InputMode] was evaluated at boot-time as
## being enabled.
static var input_mode: InputMode = _get_input_mode()

## Returns which member of [enum InputMode] is currently enabled. The default is
## [constant InputMode.INPUT_MOUSE].
static func _get_input_mode() -> InputMode:
	if _is_gyro_input_mode():
		return InputMode.INPUT_GYRO
	elif _is_touch_input_mode():
		return InputMode.INPUT_TOUCH

	return InputMode.INPUT_MOUSE

## Returns [code]true[/code] the enablement criteria for [constant InputMode.INPUT_GYRO]
## is currently valid.
static func _is_gyro_input_mode() -> bool:
	return (OS.has_feature("mobile")
		and ProjectSettings.get_setting("input_devices/sensors/enable_gravity")
		and ProjectSettings.get_setting("input_devices/sensors/enable_magnetometer"))

## Returns [code]true[/code] the enablement criteria for [constant InputMode.INPUT_MOUSE]
## is currently valid.
static func _is_mouse_input_mode() -> bool:
	return !OS.has_feature("mobile")

## Returns [code]true[/code] the enablement criteria for [constant InputMode.INPUT_TOUCH]
## is currently valid.
static func _is_touch_input_mode() -> bool:
	return (OS.has_feature("mobile")
		and (
			!ProjectSettings.get_setting("input_devices/sensors/enable_gravity")
			or !ProjectSettings.get_setting("input_devices/sensors/enable_magnetometer"))
		)
