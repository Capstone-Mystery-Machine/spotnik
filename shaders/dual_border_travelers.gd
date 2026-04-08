@tool
extends ColorRect

@export var traveler_cone_gradient: GradientTexture2D:
	set(value):
		traveler_cone_gradient = value
		_update_traveler_cone_gradient()

@export var traveler_speed: float = 1.0:
	set(value):
		traveler_speed = value
		_update_traveler_speed()

var shader_material: ShaderMaterial:
	get():
		return material as ShaderMaterial


func _update_traveler_cone_gradient() -> void:
	if is_node_ready() and traveler_cone_gradient:
		shader_material.set_shader_parameter("traveler_cone_gradient", traveler_cone_gradient)


func _update_traveler_speed() -> void:
	if is_node_ready() and traveler_speed:
		shader_material.set_shader_parameter("traveler_speed", traveler_speed)


func _ready() -> void:
	_update_traveler_cone_gradient()
	_update_traveler_speed()
