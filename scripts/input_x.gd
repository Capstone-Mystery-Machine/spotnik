class_name InputX
extends Node

enum InputMode {
	INPUT_MOUSE,
	INPUT_GYRO,
	INPUT_TOUCH,
}

static var input_mode: InputMode = _get_input_mode()

static func _get_input_mode() -> InputMode:
	if _is_gyro_input_mode():
		return InputMode.INPUT_GYRO
	elif _is_touch_input_mode():
		return InputMode.INPUT_TOUCH
		
	return InputMode.INPUT_MOUSE

static func _is_gyro_input_mode() -> bool:
	return (OS.has_feature("mobile")
		and ProjectSettings.get_setting("input_devices/sensors/enable_gravity")
		and ProjectSettings.get_setting("input_devices/sensors/enable_magnetometer"))

static func _is_mouse_input_mode() -> bool:
	return !OS.has_feature("mobile")

static func _is_touch_input_mode() -> bool:
	return (OS.has_feature("mobile")
		and (
			!ProjectSettings.get_setting("input_devices/sensors/enable_gravity")
			or !ProjectSettings.get_setting("input_devices/sensors/enable_magnetometer"))
		)
