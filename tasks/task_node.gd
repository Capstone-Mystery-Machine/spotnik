class_name TaskNode
extends Node

## Resolves the internal mechanisms of the task and exits the function when finished.
func _task() -> void:
	push_error("bad dispatch to 'TaskNode._task' (not implemented)")
