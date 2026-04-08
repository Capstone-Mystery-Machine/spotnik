@tool
extends ColorRect

@export var traveler_cone_gradient: GradientTexture2D:
	set(value):
		traveler_cone_gradient = value
		_update_traveler_cone_gradient()

@export var traveler_duration: float = 1.0

@export var traveler_ease: Tween.EaseType = Tween.EASE_IN_OUT

@export var traveler_transition: Tween.TransitionType = Tween.TRANS_SINE

var traveler_rotation: float = 0.0:
	set(value):
		traveler_rotation = value
		_update_traveler_rotation()

var shader_material: ShaderMaterial:
	get():
		return material as ShaderMaterial


func _animate_traveler_rotation() -> void:
	var tween = create_tween()

	tween.set_loops()
	tween.set_trans(traveler_transition).set_ease(traveler_ease)

	tween.tween_property(self, "traveler_rotation", 1.0, traveler_duration).from(0.0)


func _update_traveler_cone_gradient() -> void:
	if is_node_ready() and traveler_cone_gradient:
		shader_material.set_shader_parameter("traveler_cone_gradient", traveler_cone_gradient)


func _update_traveler_rotation() -> void:
	if is_node_ready():
		shader_material.set_shader_parameter("rotation", traveler_rotation)


func _ready() -> void:
	_update_traveler_cone_gradient()
	_update_traveler_rotation()

	_animate_traveler_rotation()
