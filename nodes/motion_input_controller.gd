extends InputController
## Input controller that targets a [Node3D].
##
## The input controller modifies a target [Node3D]'s [member Node3D.transform]
## in response to an end-user's rotation of their device as input. This is done
## by pulling the sensor data from the device's accelerometer and magnetometer.

@export_group("Control Settings")

## Represents any sensor readings that are [b]below[/b] this value to be treated
## as unintentional noise (e.g. shaky hands) and will be smoothed heavily to
## keep the camera stable.
@export_range(0.0, 1.0, 0.0001) var jitter_threshold: float = 0.0002

## Represents any sensor readings that are [b]above[/b] this value to be treated
## as a deliberate movement by the end-user. The camera will reduce smoothing to
## catch up to the end-user's movement as quickly as possible.
@export_range(0.0, 1.0, 0.0001) var movement_threshold: float = 0.01

## Represents the target smoothing speeds applied to the camera, where [code]x[/code]
## is the minimum speed and [code]y[/code] is the maximum speed.
## [br]
## • [b]X:[/b] Used when sensor readings are [b]inclusively below[/b] the
##   [member jitter_threshold]. The lower the value, the higher the drag there
##   is on camera movement.
## [br]
## • [b]Y:[/b] Used when sensor readings are [b]inclusively above[/b] the
##   [member movement_threshold]. The higher the value, the higher the camera's
##   movement responsiveness is.
@export var smoothing_limits: Vector2 = Vector2(1.0, 15.0)


## Enables the input controller if [constant InputX.input_mode] is set to
## [constant InputX.InputMode.INPUT_MOTION].
func _is_enabled(input_mode: InputX.InputMode) -> bool:
	return input_mode == InputX.InputMode.INPUT_MOTION


## Runs every engine tick reading the accelerometer and magnetometer sensor data
## and translating movement deltas into a new [Basis] matrix that is then applied
## to the target [Node3D]'s [member Node3D.transform.basis] via spherical linear
## interpolation.
## [br]
## The following high-level steps are performed:
## [br]
## • An Earth-aligned [Basis] is computed to serve as the target basis.
## [br]
## • An error rate is computed based on how far misaligned the target [Node3D]'s
##   [member Node3D.transform.basis] is from the computed [Basis].
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
## • The computed target [Basis] is then applied to the target [Node3D]'s
##   [member Node3D.transform.basis] via spherical linear interpolation.
## [br]
##     • Spherical linear interpolation is used because it guarantees that the
##       applied [Basis] is interpolated along the arc of rotation and thus
##       moves at a constant speed. That is, the rotation remains orthonormal.
func _process(delta: float) -> void:
	target_node.transform.basis = InputX.get_geocentric_basis_smoothed(
		target_node.transform.basis,
		delta,
		Vector2(jitter_threshold, movement_threshold),
		smoothing_limits,
	)
