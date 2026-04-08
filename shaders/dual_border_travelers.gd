@tool
extends ColorRect

@export var traveler_cone_gradient: GradientTexture2D:
	set(value):
		traveler_cone_gradient = value
		_update_traveler_cone_gradient()

@export var traveler_duration: float = 1.0

@export var traveler_ease: Tween.EaseType = Tween.EASE_IN_OUT:
	set(value):
		traveler_ease = value
		_animate_rotation()

@export var traveler_transition: Tween.TransitionType = Tween.TRANS_SINE:
	set(value):
		traveler_transition = value
		_animate_rotation()

var _rotation: float = 0.0:
	set(value):
		_rotation = value
		_update_rotation()

var shader_material: ShaderMaterial:
	get():
		return material as ShaderMaterial

var _tween: Tween


func _update_rotation() -> void:
	if is_node_ready():
		shader_material.set_shader_parameter("rotation", _rotation)


func _update_traveler_cone_gradient() -> void:
	if is_node_ready() and traveler_cone_gradient:
		shader_material.set_shader_parameter(
			"traveler_cone_gradient",
			traveler_cone_gradient,
		)


func _animate_rotation() -> void:
	if not is_node_ready():
		return

	if _tween:
		_tween.kill()

	_tween = create_tween()
	_tween.set_loops()
	_tween.set_trans(traveler_transition).set_ease(traveler_ease)
	_tween.tween_property(
		self,
		"_rotation",
		1.0,
		traveler_duration,
	).from(0.0)


func _ready() -> void:
	_update_rotation()
	_update_traveler_cone_gradient()

	_animate_rotation()
