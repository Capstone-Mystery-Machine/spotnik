@tool
extends Node

@export var target_node: Node:
	set(value):
		target_node = value
		_update_target()

@export var target_property: String = "":
	set(value):
		target_property = value
		_update_target()

@export var duration: float = 1.0:
	set(value):
		duration = value
		_animate()

@export var ease_type: Tween.EaseType = Tween.EASE_IN_OUT:
	set(value):
		ease_type = value
		_animate()

@export_range(0.0, 1.0) var intensity: float = 1.0:
	set(value):
		intensity = value
		_update_target()

@export_range(-1.0, 1.0) var offset: float = 0.0:
	set(value):
		offset = value
		_update_target()

@export_range(1, 12, 1) var steps: int = 1:
	set(value):
		steps = max(1, value)
		_update_target()

@export var transition_type: Tween.TransitionType = Tween.TRANS_SINE:
	set(value):
		transition_type = value
		_animate()

var _progress: float = 0.0:
	set(value):
		_progress = value
		_update_target()

var _tween: Tween


func _update_target() -> void:
	if not is_node_ready() or not target_node or target_property.is_empty():
		return

	var steps_float = float(steps)

	var step_time = _progress * steps_float
	var step_fraction = fposmod(step_time, 1.0)

	var eased_step_fraction = Tween.interpolate_value(
		0.0,
		1.0,
		step_fraction,
		1.0,
		transition_type,
		ease_type,
	)

	var eased_total_progress \
	= (floor(step_time) + eased_step_fraction) / steps_float

	var final_weighted_value = lerp(
		_progress,
		eased_total_progress,
		intensity,
	)

	target_node.set_indexed(target_property, final_weighted_value + offset)


func _animate() -> void:
	if not is_node_ready():
		return

	if _tween:
		_tween.kill()

	_tween = create_tween()
	_tween.set_loops()

	_tween.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	_tween.tween_property(self, "_progress", 1.0, duration).from(0.0)


func _ready() -> void:
	_update_target()
	_animate()
