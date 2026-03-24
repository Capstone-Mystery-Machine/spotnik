extends Node3D

@export var landmark_scene: PackedScene
@export var json_url: String = "http://localhost:8080/data/satellites.json"
@export var spawn_radius: float = 10

var satellite_data: Array = []
var landmarks: Array[Landmark] = []

var multimesh_instance: MultiMeshInstance3D
var multimesh: MultiMesh


func _ready() -> void:
	$HTTPRequest.request_completed.connect(_on_request_completed)
	$HTTPRequest.request(json_url)


func _process(_delta: float) -> void:
	if multimesh == null:
		return

	for i in range(landmarks.size()):
		var landmark = landmarks[i]
		if landmark == null:
			continue

		var instance_transform := Transform3D(
			Basis().scaled(landmark.mesh_node.scale),
			landmark.position,
		)
		multimesh.set_instance_transform(i, instance_transform)


func _on_request_completed(
		_result: int,
		_code: int,
		_headers: PackedStringArray,
		body: PackedByteArray,
) -> void:
	satellite_data = JSON.parse_string(body.get_string_from_utf8())
	spawn_all_landmarks()


func spawn_all_landmarks() -> void:
	if landmark_scene == null:
		return

	landmarks.clear()

	setup_multimesh()

	for i in range(satellite_data.size()):
		var landmark = spawn_landmark(satellite_data[i])
		if landmark != null:
			landmarks.append(landmark)

	if multimesh != null:
		multimesh.instance_count = landmarks.size()


func setup_multimesh() -> void:
	if multimesh_instance != null:
		multimesh_instance.queue_free()

	multimesh_instance = MultiMeshInstance3D.new()
	add_child(multimesh_instance)

	multimesh = MultiMesh.new()
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh_instance.multimesh = multimesh

	var box_mesh := BoxMesh.new()
	multimesh.mesh = box_mesh


func spawn_landmark(data: Dictionary) -> Landmark:
	if landmark_scene == null:
		return null

	var landmark = landmark_scene.instantiate() as Landmark
	if landmark == null:
		return null

	add_child(landmark)

	var latitude: float = data["latitude"]
	var longitude: float = data["longitude"]

	var lat_rad = deg_to_rad(latitude)
	var lon_rad = deg_to_rad(longitude)

	var x = spawn_radius * cos(lat_rad) * cos(lon_rad)
	var y = spawn_radius * sin(lat_rad)
	var z = spawn_radius * cos(lat_rad) * sin(lon_rad)

	var sat_position = Vector3(x, y, z)
	landmark.position = sat_position

	landmark.setup(
		data["int_designator"],
		data["norad_id"],
		data["name"],
		data["country"],
		data["launch"],
		data["latitude"],
		data["longitude"],
	)

	# Hide the landmark's own visual mesh, but keep the node/script/detector alive
	landmark.mesh_node.visible = false

	return landmark
