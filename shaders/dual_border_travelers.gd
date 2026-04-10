@tool
extends ColorRect

@export_range(1, 12, 1) var cone_count: int = 2:
	set(value):
		cone_count = max(1, value)
		_update_cone_count()

@export var corner_radius: Vector4 = Vector4(-1.0, -1.0, -1.0, -1.0):
	set(value):
		corner_radius = value
		_update_corners()

@warning_ignore("unused_private_class_variable")
var _rotation: float = 0.0:
	set(value):
		_rotation = value
		_update_rotation()

var _shader_material: ShaderMaterial:
	get():
		return material as ShaderMaterial


func _update_cone_count() -> void:
	if is_node_ready() and _shader_material:
		RenderingServer.material_set_param(
			_shader_material.get_rid(),
			"cone_count",
			float(cone_count),
		)


func _update_corners() -> void:
	if not is_node_ready() or not _shader_material:
		return

	var radii := Vector4.ZERO

	if corner_radius != Vector4(-1.0, -1.0, -1.0, -1.0):
		radii = corner_radius
	else:
		var parent = get_parent()

		if parent is Control and parent.has_theme_stylebox("panel"):
			var stylebox = parent.get_theme_stylebox("panel")

			if stylebox is StyleBoxFlat:
				radii = Vector4(
					stylebox.corner_radius_top_left,
					stylebox.corner_radius_top_right,
					stylebox.corner_radius_bottom_right,
					stylebox.corner_radius_bottom_left,
				)

	RenderingServer.material_set_param(
		_shader_material.get_rid(),
		"corner_radius",
		radii,
	)


func _update_rotation() -> void:
	if is_node_ready():
		RenderingServer.material_set_param(
			_shader_material.get_rid(),
			"rotation",
			_rotation,
		)


func _update_size() -> void:
	if is_node_ready() and _shader_material:
		RenderingServer.material_set_param(
			_shader_material.get_rid(),
			"size",
			size,
		)


func _ready() -> void:
	resized.connect(_update_size)

	_update_cone_count()
	_update_corners()
	_update_rotation()
