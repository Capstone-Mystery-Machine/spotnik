@tool
extends ColorRect

@export var traveler_cone_sharpness: float = 20.0:
	set(value):
		traveler_cone_sharpness = value
		_update_traveler_cone_sharpness()

@export var traveler_color_left: Color = Color(1, 1, 1, 1):
	set(value):
		traveler_color_left = value
		_update_traveler_color_left()

@export var traveler_color_right: Color = Color(0, 0, 0, 1):
	set(value):
		traveler_color_right = value
		_update_traveler_color_right()

@export var traveler_speed: float = 1.0:
	set(value):
		traveler_speed = value
		_update_traveler_speed()

var shader_material: ShaderMaterial:
	get():
		return material as ShaderMaterial


func _update_traveler_cone_sharpness() -> void:
	if is_node_ready() and traveler_cone_sharpness:
		shader_material.set_shader_parameter("traveler_cone_sharpness", traveler_cone_sharpness)


func _update_traveler_color_left() -> void:
	if is_node_ready() and traveler_color_left:
		shader_material.set_shader_parameter("traveler_color_left", traveler_color_left)


func _update_traveler_color_right() -> void:
	if is_node_ready() and traveler_color_right:
		shader_material.set_shader_parameter("traveler_color_right", traveler_color_right)


func _update_traveler_speed() -> void:
	if is_node_ready() and traveler_speed:
		shader_material.set_shader_parameter("traveler_speed", traveler_speed)


func _ready() -> void:
	_update_traveler_cone_sharpness()
	_update_traveler_color_left()
	_update_traveler_color_right()
	_update_traveler_speed()
