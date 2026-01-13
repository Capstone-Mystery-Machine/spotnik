extends Node
## Input controller that targets a [Node3D].
##
## The input controller modifies a target [Node3D]'s [member Node3D.transform]
## in response to an end-user's rotation of their device as input. This is done
## by pulling the sensor data from the device's accelerometer and magnetometer.

@export_group("Targeting")

## Represents which [Node3D] that the input controller is going to modify in
## reaction to input performed by the end-user.
@export var target_node_3d: Node3D = null

@export_group("Control Settings")

## Represents any sensor readings that are [b]below[/b] this value to be treated
## as unintentional noise (e.g. shaky hands) and will be smoothed heavily to
## keep the camera stable.
@export_range(0.0, 1.0, 0.0001) var jitter_threshold: float = 0.0002

## Represents any sensor readings that are [b]above[/b] this value to be treated
## as a deliberate movement by the end-user. The camera will reduce smoothing to
## catch up to the end-user's movement as quickly as possible.
@export_range(0.0, 1.0, 0.0001) var movement_threshold: float = 0.01

## Represents the target smoothing speed used when the sensor readings are
## [b]inclusively below[/b] the [member jitter_threshold] value. That is, the
## lower the value, the higher the drag there is on camera movement.
@export var smoothing_min: float = 1.0

## Represents the target smoothing speed used when the sensor readings are
## [b]inclusively above[/b] the [member movement_threshold] value. That is, the
## higher the value, the higher the camera's movement responsiveness is.
@export var smoothing_max: float = 15.0

## Enables the input controller if [constant InputX.input_mode] is set to
## [constant InputX.InputMode.INPUT_GYRO].
func _ready() -> void:
	match InputX.input_mode:
		InputX.InputMode.INPUT_GYRO:
			process_mode = Node.PROCESS_MODE_INHERIT
		_:
			process_mode = Node.PROCESS_MODE_DISABLED

func _process(delta: float) -> void:
	var gravity = Input.get_gravity()
	var magnet = Input.get_magnetometer()

	var gravity_direction = gravity.normalized()
	var magnet_direction = magnet.normalized()

	var physical_up = -gravity_direction
	var physical_east = magnet_direction.cross(physical_up).normalized()
	var physical_north = physical_up.cross(physical_east).normalized()

	var target_basis = Basis(physical_east, physical_up, -physical_north).inverse()
	var current_basis = target_node_3d.transform.basis
	
	var alignment = current_basis.z.dot(target_basis.z)
	var error = abs(1.0 - alignment)

	var dynamic_smoothing = remap(error, jitter_threshold, movement_threshold, smoothing_min, smoothing_max)
	dynamic_smoothing = clamp(dynamic_smoothing, smoothing_min, smoothing_max)

	target_node_3d.transform.basis = current_basis.slerp(target_basis, dynamic_smoothing * delta)
