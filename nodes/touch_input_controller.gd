extends InputController
## Input controller that targets a [Node3D].
##
## The input controller modifies a target [Node3D]'s [member Node3D.rotation]
## in response to the end-user tapping-and-dragging on the 3D viewport.

@export_group("Targeting")

## Represents which [Node3D] that the input controller is going to modify in
## reaction to input performed by the end-user.
@export var target_node_3d: Node3D = null

@export_group("Control Settings")

## Represents how far up the end-user can rotate the target [Node3D]'s
## [member Node3D.rotation] exclusively. This is mainly so that the end-user
## cannot rotate the [Node3D] up so much that it rotates back on itself, thus
## causing gimbal lock.
@export_range(-90.0, 90.0, 0.0001) var pitch_max: float = 90.0

## Represents how far down the end-user can rotate the target [Node3D]'s
## [member Node3D.rotation] exclusively. This is mainly so that the end-user
## cannot rotate the [Node3D] down so much that it rotates back on itself, thus
## causing gimbal lock.
@export_range(-90.0, 90.0, 0.0001) var pitch_min: float = -90.0

## Represents the sensitivity value that is [b]multiplied against[/b] the
## end-user's vertical touch movements. That is, the lower the value, the more
## physical dragging movement needed to modify the target [Node3D]'s
## [member Node3D.rotation].
@export var sensitivity_pitch: float = 0.0025

## Represents the sensitivity value that is [b]multiplied against[/b] the
## end-user's horizontal touch movements. That is, the lower the value, the more
## physical dragging movement needed to modify the target [Node3D]'s
## [member Node3D.rotation].
@export var sensitivity_yaw: float = 0.0025

## Represents the max pitch inspector values converted from degrees into radians.
var _pitch_max: float:
	get:
		return deg_to_rad(pitch_max - GlobalScopeX.EPSILON_SINGLE_PRECISION)

## Represents the min pitch inspector values converted from degrees into radians.
var _pitch_min: float:
	get:
		return deg_to_rad(pitch_min + GlobalScopeX.EPSILON_SINGLE_PRECISION)


## Enables the input controller if [constant InputX.input_mode] is set to
## [constant InputX.InputMode.INPUT_TOUCH].
func _is_enabled(input_mode: InputX.InputMode) -> bool:
	return input_mode == InputX.InputMode.INPUT_TOUCH


## Handles unhandled screen dragging input by translating screen pixel movement
## deltas into angular rotation applied to the target [Node3D]'s
## [member Node3D.rotation].
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		var rotation_delta: Vector2 = Vector2(
			event.screen_relative.y * sensitivity_pitch,
			event.screen_relative.x * sensitivity_yaw,
		)

		target_node_3d.rotation.x = clamp(
			target_node_3d.rotation.x - rotation_delta.x,
			_pitch_min,
			_pitch_max,
		)

		target_node_3d.rotation.y -= rotation_delta.y

		get_viewport().set_input_as_handled()
