extends Node

@export_group("Targeting")

@export var target_node_3d: Node3D = null

@export_group("Control Settings")

@export var sensitity_pitch: float = 0.025

@export var sensitity_yaw: float = 0.025

var is_dragging: bool = false

func _ready() -> void:
	match InputX.input_mode:
		InputX.InputMode.INPUT_MOUSE:
			process_mode = Node.PROCESS_MODE_INHERIT
		_:
			process_mode = Node.PROCESS_MODE_DISABLED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		is_dragging = event.is_action_pressed("interaction_drag")

		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if is_dragging else Input.MOUSE_MODE_VISIBLE

	elif event is InputEventMouseMotion:
		if !is_dragging:
			return

		var rotation_delta: Vector2 = Vector2(
			event.screen_relative.y * sensitity_pitch,
			event.screen_relative.x * sensitity_yaw,
		)

		target_node_3d.rotation.x -= rotation_delta.x
		target_node_3d.rotation.y -= rotation_delta.y
