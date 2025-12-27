extends Node

@export_group("Targeting")

@export var target_node_3d: Node3D = null

@export_group("Control Settings")

@export_range(0.0, 1.0, 0.0001) var jitter_threshold: float = 0.0002

@export_range(0.0, 1.0, 0.0001) var movement_threshold: float = 0.01

@export var smoothing_min: float = 1.0

@export var smoothing_max: float = 15.0

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
