extends Node
## Input controller that targets a [Node3D].
##
## The input controller modifies a target [Node3D]'s [member Node3D.rotation]
## in response to the end-user tapping-and-dragging on the 3D viewport.

@export_group("Targeting")

## Represents which [Node3D] that the input controller is going to modify in
## reaction to input performed by the end-user.
@export var target_node_3d: Node3D = null

@export_group("Control Settings")

## Represents the sensitivity value that is [b]multiplied against[/b] the
## end-user's vertical touch movements. That is, the lower the value, the more
## physical dragging movement needed to modify the target [Node3D]'s
## [member Node3D.rotation].
@export var sensitity_pitch: float = 0.0025

## Represents the sensitivity value that is [b]multiplied against[/b] the
## end-user's horizontal touch movements. That is, the lower the value, the more
## physical dragging movement needed to modify the target [Node3D]'s
## [member Node3D.rotation].
@export var sensitity_yaw: float = 0.0025


## Enables the input controller if [constant InputX.input_mode] is set to
## [constant InputX.InputMode.INPUT_TOUCH].
func _ready() -> void:
	match InputX.input_mode:
		InputX.InputMode.INPUT_TOUCH:
			process_mode = Node.PROCESS_MODE_INHERIT
		_:
			process_mode = Node.PROCESS_MODE_DISABLED


## Handles unhandled screen dragging input by translating screen pixel movement
## deltas into angular rotation applied to the target [Node3D]'s
## [member Node3D.rotation].
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		var rotation_delta: Vector2 = Vector2(
			event.screen_relative.y * sensitity_pitch,
			event.screen_relative.x * sensitity_yaw,
		)

		target_node_3d.rotation.x -= rotation_delta.x
		target_node_3d.rotation.y -= rotation_delta.y
