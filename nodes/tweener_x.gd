@tool
class_name TweenerX
extends Node

signal progress_changed(new_progress: float, old_progress: float)

@export var target_node: Node:
	set(value):
		target_node = value
		_update_blended_progress()

@export var target_property: String = "":
	set(value):
		target_property = value
		_update_blended_progress()

@export var duration: float = 1.0:
	set(value):
		duration = max(0.001, value)
		_animate()

@export var ease_type: Tween.EaseType = Tween.EASE_IN_OUT:
	set(value):
		ease_type = value
		_animate()

@export_range(0.0, 1.0) var intensity: float = 1.0:
	set(value):
		intensity = value
		_update_blended_progress()

@export_range(-1.0, 1.0) var offset: float = 0.0:
	set(value):
		offset = value
		_update_blended_progress()

@export var start_delay: float = 0.0:
	set(value):
		start_delay = max(0.0, value)
		_animate()

@export var repeat_delay: float = 0.0:
	set(value):
		repeat_delay = max(0.0, value)
		_animate()

@export_range(1, 12, 1) var steps: int = 1:
	set(value):
		steps = max(1, value)
		_update_blended_progress()

@export var transition_type: Tween.TransitionType = Tween.TRANS_LINEAR:
	set(value):
		transition_type = value
		_animate()

var progress: float = 0.0:
	set(value):
		var old_progress = progress
		progress = value

		progress_changed.emit(value, old_progress)
		_apply_to_target()

var _progress: float = 0.0:
	set(value):
		_progress = value
		_update_blended_progress()

var _tween: Tween


func _apply_to_target() -> void:
	if target_node and not target_property.is_empty():
		target_node.set_indexed(target_property, progress)


func _update_blended_progress() -> void:
	if not is_node_ready():
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

	var eased_total_progress = (floor(step_time) + eased_step_fraction) / steps_float
	progress = lerp(_progress, eased_total_progress, intensity) + offset


func _animate() -> void:
	if not is_node_ready():
		return

	if _tween:
		_tween.kill()

	if start_delay > 0.0:
		_tween = create_tween()
		_tween.tween_interval(start_delay)
		_tween.tween_callback(_start_loop)
	else:
		_start_loop()


func _start_loop() -> void:
	if _tween:
		_tween.kill()

	_tween = create_tween()
	_tween.set_loops()
	_tween.set_trans(Tween.TRANS_LINEAR)

	_tween.tween_property(self, "_progress", 1.0, duration).from(0.0)

	if repeat_delay > 0.0:
		_tween.tween_interval(repeat_delay)


func _ready() -> void:
	_update_blended_progress()
	_animate()
