class_name ControlProjector
extends Node

enum AnchorPoint {
	TOP_LEFT,
	TOP_CENTER,
	TOP_RIGHT,
	CENTER_LEFT,
	CENTER,
	CENTER_RIGHT,
	BOTTOM_LEFT,
	BOTTOM_CENTER,
	BOTTOM_RIGHT,
}

@export var target_control: Control
@export var target_node: Node3D
@export var anchor: AnchorPoint = AnchorPoint.CENTER
@export var scale_multiplier: float = 5.0


func _process(_delta: float) -> void:
	if not target_control or not target_node:
		return

	var camera: Camera3D = get_viewport().get_camera_3d()

	if not camera:
		return

	var screen_position: Vector2 = camera.unproject_position(
		target_node.global_position,
	)

	var distance: float = camera.global_position.distance_to(
		target_node.global_position,
	)

	var calculated_scale: float = scale_multiplier / max(distance, 0.1)
	target_control.scale = Vector2(calculated_scale, calculated_scale)

	var scaled_size: Vector2 = target_control.size * target_control.scale
	var offset: Vector2 = Vector2.ZERO

	match anchor:
		AnchorPoint.TOP_LEFT:
			offset = Vector2(0, 0)
		AnchorPoint.TOP_CENTER:
			offset = Vector2(scaled_size.x / 2.0, 0)
		AnchorPoint.TOP_RIGHT:
			offset = Vector2(scaled_size.x, 0)
		AnchorPoint.CENTER_LEFT:
			offset = Vector2(0, scaled_size.y / 2.0)
		AnchorPoint.CENTER:
			offset = Vector2(scaled_size.x / 2.0, scaled_size.y / 2.0)
		AnchorPoint.CENTER_RIGHT:
			offset = Vector2(scaled_size.x, scaled_size.y / 2.0)
		AnchorPoint.BOTTOM_LEFT:
			offset = Vector2(0, scaled_size.y)
		AnchorPoint.BOTTOM_CENTER:
			offset = Vector2(scaled_size.x / 2.0, scaled_size.y)
		AnchorPoint.BOTTOM_RIGHT:
			offset = Vector2(scaled_size.x, scaled_size.y)

	var canvas_transform: Transform2D = target_control.get_canvas_transform()
	var scaled_screen_position: Vector2 = canvas_transform.affine_inverse() * screen_position

	target_control.global_position = scaled_screen_position - offset
