class_name ContentLayer
extends Node

var _transition_progress: float = 0.0

var transition_progress: float:
	get:
		return _transition_progress
	set(value):
		_transition_progress = value

		if not is_node_ready():
			return

		var target_alpha = 1.0 - _transition_progress

		for child in get_children():
			if "content_alpha" in child:
				child.content_alpha = target_alpha
