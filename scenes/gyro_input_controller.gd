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


## Runs every engine tick reading the accelerometer and magnetometer sensor data
## and translating movement deltas into a new [Basis] matrix that is then applied
## to the target [Node3D]'s [member Node3D.transform.basis] via spherical linear
## interpolation.
## [br]
## The following high-level steps are performed:
## [br]
## • Physical gravitational and north pole directional vectors are polled from
## sensor data.
## [br]
## • Cardinal-aligned right and south + gravitational up directions are constructed
##   from the gravity and north pole directional vectors.
## [br]
## • A basis matrix is computed based on the computed right, up, and back directions.
## [br]
##     • Because sensor data understands the world as relative to the end-user's
##       device and Godot understands the device as relative to the world, we
##       need to invert the computed basis matrix's perspective before further
##       calculations.
## [br]
## • An error rate is computed based on how far misaligned the target [Node3D]'s
##   [member Node3D.transform.basis] is from the computed basis matrix.
## [br]
##     • Negative alignments are treated as high-correction needed via taking
##       the absolute value of the computed error rate.
## [br]
## • A dynamic smoothing value is computed by remapping the error rate from
##   [code][jitter_threshold, movement_threshold][/code] to
##   [code][smoothing_min, smoothing_max][/code] via percentage math.
##     • The dynamic smoothing value controls how sluggish to responsive the
##       [Node3D] adjustments are.
## [br]
## • The computed basis matrix is then applied to the target [Node3D]'s
##   [member Node3D.transform.basis] via spherical linear interpolation.
## [br]
##     • Spherical linear interpolation is used because it guarantees that the
##       applied basis matrix is interpolated along the arc of rotation and thus
##       moves at a constant speed. That is, the rotation remains orthonormal.
func _process(delta: float) -> void:
	var current_basis = target_node_3d.transform.basis
	var target_basis = InputX.get_geocentric_basis()

	var alignment = current_basis.z.dot(target_basis.z)
	var error = abs(1.0 - alignment)

	var dynamic_smoothing = remap(
		error,
		jitter_threshold,
		movement_threshold,
		smoothing_min,
		smoothing_max,
	)

	dynamic_smoothing = clamp(dynamic_smoothing, smoothing_min, smoothing_max)

	target_node_3d.transform.basis = current_basis.slerp(
		target_basis,
		dynamic_smoothing * delta,
	)
