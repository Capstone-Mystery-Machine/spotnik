extends Node

@export_group("Targeting")

@export var target_node_3d: Node3D = null

@export_group("Control Settings")

@export var sensitity_pitch: float = 0.0025

@export var sensitity_yaw: float = 0.0025

var is_dragging: bool = false

func _ready() -> void:
	match InputX.input_mode:
		InputX.InputMode.INPUT_TOUCH:
			process_mode = Node.PROCESS_MODE_INHERIT
		_:
			process_mode = Node.PROCESS_MODE_DISABLED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		var rotation_delta: Vector2 = Vector2(
			event.screen_relative.y * sensitity_pitch,
			event.screen_relative.x * sensitity_yaw,
		)

		target_node_3d.rotation.x -= rotation_delta.x
		target_node_3d.rotation.y -= rotation_delta.y
