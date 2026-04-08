@tool
extends ColorRect

@export var traveler_cone_gradient: GradientTexture2D:
	set(value):
		traveler_cone_gradient = value
		_update_traveler_cone_gradient()

var _shader_material: ShaderMaterial:
	get():
		return material as ShaderMaterial

@warning_ignore("unused_private_class_variable")
var _rotation: float = 0.0:
	set(value):
		_rotation = value
		_update_rotation()


func _update_rotation() -> void:
	if is_node_ready():
		_shader_material.set_shader_parameter("rotation", _rotation)


func _update_traveler_cone_gradient() -> void:
	if is_node_ready() and traveler_cone_gradient:
		_shader_material.set_shader_parameter(
			"traveler_cone_gradient",
			traveler_cone_gradient,
		)


func _ready() -> void:
	_update_traveler_cone_gradient()
	_update_rotation()
