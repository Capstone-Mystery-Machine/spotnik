extends InputController
## Input controller that targets a [Node3D].
##
## The input controller modifies a target [Node3D]'s [member Node3D.transform]
## in response to an end-user's rotation of their device as input. This is done
## by pulling the sensor data from the device's accelerometer and magnetometer.

## Enables the input controller if [constant InputX.input_mode] is set to
## [constant InputX.InputMode.INPUT_MOTION].
func _is_enabled(input_mode: InputX.InputMode) -> bool:
	return input_mode == InputX.InputMode.INPUT_MOTION


## Runs every engine tick reading the accelerometer and magnetometer sensor data
## and translating movement deltas into a new [Basis] matrix that is then applied
## to the target [Node3D]'s [member Node3D.transform.basis].
func _process(_delta: float) -> void:
	target_node.transform.basis = InputX.instance.get_geocentric_basis_smoothed()
