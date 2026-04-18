class_name SatelUI
extends Node3D

@onready var info_ui = %Info_UI
@onready var international_designator = %International_Designator2
@onready var norad_catalog_identifier = %Norad_Catalog_Identifier2
@onready var satellite_name = %Name2
@onready var origin_country = %Origin_Country2
@onready var launch_date = %Launch_Date2

# var to determine dist of UI in proportion to satel dist
@onready var info_ui_dist = 0.025


func _ready():
	info_ui.visible = false

	#for interaction with 2d object in 3d environment
	node_area.mouse_entered.connect(_mouse_entered_area)
	node_area.mouse_exited.connect(_mouse_exited_area)
	node_area.input_event.connect(_mouse_input_event)


func setup_satel_ui(landmark: Landmark) -> void:
	international_designator.text = landmark.international_designator
	norad_catalog_identifier.text = landmark.norad_catalog_id
	satellite_name.text = landmark.satellite_name
	origin_country.text = landmark.country
	launch_date.text = landmark.launch_date

	#set spawn position
	info_ui.position = landmark.position * info_ui_dist
	info_ui.visible = true


func _on_close_button_pressed() -> void:
	info_ui.visible = false

#handle interaction with 2d ui in 3d space
# Used for checking if the mouse is inside the Area3D.
var is_mouse_inside = false
# The last processed input touch/mouse event. To calculate relative movement.
var last_event_pos_2d = null
# The time of the last event in seconds since engine start.
var last_event_time: float = -1.0

@onready var node_viewport = %Info_Viewport
@onready var node_quad = %Quad
@onready var node_area = %Area3D


func _mouse_entered_area():
	is_mouse_inside = true


func _mouse_exited_area():
	is_mouse_inside = false


func _unhandled_input(event):
	# Check if the event is a non-mouse/non-touch event
	for mouse_event in [
		InputEventMouseButton,
		InputEventMouseMotion,
		InputEventScreenDrag,
		InputEventScreenTouch,
	]:
		if is_instance_of(event, mouse_event):
			# If the event is a mouse/touch event, then we can ignore it here,
			# because it will be handled via Physics Picking.
			return
	node_viewport.push_input(event)


func _mouse_input_event(
		_camera: Camera3D,
		event: InputEvent,
		event_position: Vector3,
		_normal: Vector3,
		_shape_idx: int,
):
	# Get mesh size to detect edges and make conversions. This code only support
	# PlaneMesh and QuadMesh.
	var quad_mesh_size = node_quad.mesh.size

	# Event position in Area3D in world coordinate space.
	var event_pos3D = event_position

	# Current time in seconds since engine start.
	var now: float = Time.get_ticks_msec() / 1000.0

	# Convert position to a coordinate space relative to the Area3D node.
	# NOTE: affine_inverse accounts for the Area3D node's scale, rotation, and
	# position in the scene!
	event_pos3D = node_quad.global_transform.affine_inverse() * event_pos3D

	# TODO: Adapt to bilboard mode or avoid completely.

	var event_pos_2d: Vector2 = Vector2()

	if is_mouse_inside:
		# Convert the relative event position from 3D to 2D.
		event_pos_2d = Vector2(event_pos3D.x, -event_pos3D.y)

		# Right now the event position's range is the following:
		# (-quad_size/2) -> (quad_size/2)
		# We need to convert it into the following range: -0.5 -> 0.5
		event_pos_2d.x = event_pos_2d.x / quad_mesh_size.x
		event_pos_2d.y = event_pos_2d.y / quad_mesh_size.y
		# Then we need to convert it into the following range: 0 -> 1
		event_pos_2d.x += 0.5
		event_pos_2d.y += 0.5

		# Finally, we convert the position to the following range: 0 -> viewport.size
		event_pos_2d.x *= node_viewport.size.x
		event_pos_2d.y *= node_viewport.size.y
		# We need to do these conversions so the event's position is in the viewport's
		# coordinate system.

	elif last_event_pos_2d != null:
		# Fall back to the last known event position.
		event_pos_2d = last_event_pos_2d

	# Set the event's position and global position.
	event.position = event_pos_2d
	if event is InputEventMouse:
		event.global_position = event_pos_2d

	# Calculate the relative event distance.
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		# If there is not a stored previous position, then we'll assume there is
		# no relative motion.
		if last_event_pos_2d == null:
			event.relative = Vector2(0, 0)
		# If there is a stored previous position, then we'll calculate the relative
		# position by subtracting the previous position from the new position.
		# This will give us the distance the event traveled from prev_pos.
		else:
			event.relative = event_pos_2d - last_event_pos_2d
			event.velocity = event.relative / (now - last_event_time)

	# Update last_event_pos_2d with the position we just calculated.
	last_event_pos_2d = event_pos_2d

	# Update last_event_time to current time.
	last_event_time = now

	# Finally, send the processed input event to the viewport.
	node_viewport.push_input(event)
