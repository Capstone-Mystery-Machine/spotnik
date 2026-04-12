class_name InputController
extends Node
## Input controller that targets a [Node3D].
##
## The input controller modifies a target [Node3D]'s orientation or positioning
## in response to some end-user input.

@export_group("Targeting")

## Represents which [Node3D] that the input controller is going to modify in
## reaction to input performed by the end-user.
@export var target_node: Node3D = null


## Returns if the [InputController] is currently enabled or not.
func _is_enabled(_input_mode: InputX.InputMode) -> bool:
	push_error("bad dispatch to 'InputController._is_enabled' (not implemented)")
	return false


func _on_input_mode_changed(input_mode: InputX.InputMode) -> void:
	if _is_enabled(input_mode):
		process_mode = Node.PROCESS_MODE_INHERIT
	else:
		process_mode = Node.PROCESS_MODE_DISABLED


func _ready() -> void:
	InputX.instance.input_mode_changed.connect(_on_input_mode_changed)
	_on_input_mode_changed(InputX.input_mode)
