@tool
extends ColorRect

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
		RenderingServer.material_set_param(
			_shader_material.get_rid(),
			"rotation",
			_rotation,
		)


func _ready() -> void:
	_update_rotation()
