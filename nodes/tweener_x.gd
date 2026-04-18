@tool
class_name TweenerX
extends Node

signal progress_changed(new_progress: float, old_progress: float)

signal progress_repeated(current_repeats: int)

signal progress_started()

@export var target_node: Node:
	set(value):
		target_node = value
		_update_blended_progress()

@export var target_property: String = "":
	set(value):
		target_property = value
		_update_blended_progress()

@export var from_value: Variant:
	set(value):
		from_value = value
		_apply_to_target()

@export var to_value: Variant:
	set(value):
		to_value = value
		_apply_to_target()

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

@export var repeat_count: int = -1:
	set(value):
		repeat_count = value
		_animate()

@export var repeat_delay: float = 0.0:
	set(value):
		repeat_delay = max(0.0, value)
		_animate()

@export var reverse: bool = false:
	set(value):
		reverse = value
		_animate()

@export var start_delay: float = 0.0:
	set(value):
		start_delay = max(0.0, value)
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

var _is_first_run: bool = true

var _current_repeats: int = 0

var _progress: float = 0.0:
	set(value):
		_progress = value
		_update_blended_progress()

var _tween: Tween


func on_tween_callback() -> void:
	if _is_first_run:
		progress_started.emit()
		_is_first_run = false

	else:
		progress_repeated.emit(_current_repeats)


func _animate() -> void:
	if not is_node_ready():
		return

	if _tween:
		_tween.kill()

	_is_first_run = true

	if start_delay > 0.0:
		_tween = create_tween()

		_tween.tween_interval(start_delay)

		_tween.tween_callback(_start_loop)

	else:
		_start_loop()


func _apply_to_target() -> void:
	if target_node and not target_property.is_empty():
		# HACK: We need to put the defaults here since the inspector will not
		# otherwise treat the `Variant` exports as `Variant` types.
		var safe_from_value = from_value if from_value != null else 0.0
		var safe_to_value = to_value if to_value != null else 1.0

		var interpolated_value = lerp(safe_from_value, safe_to_value, progress)
		target_node.set_indexed(target_property, interpolated_value)


func _start_loop() -> void:
	if _tween:
		_tween.kill()

	_tween = create_tween()
	_tween.set_trans(Tween.TRANS_LINEAR)

	_tween.tween_callback(on_tween_callback)

	var end_progress = 0.0 if reverse else 1.0

	var remaining_distance = abs(end_progress - _progress)
	var current_duration = duration * remaining_distance

	_tween.tween_property(self, "_progress", end_progress, current_duration)

	if repeat_delay > 0.0:
		_tween.tween_interval(repeat_delay)

	_tween.tween_callback(_loop_restart)


func _loop_restart() -> void:
	if repeat_count != -1 and _current_repeats >= repeat_count:
		return

	_current_repeats += 1
	_progress = 1.0 if reverse else 0.0
	_start_loop()


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


func _ready() -> void:
	_update_blended_progress()
	_animate()
