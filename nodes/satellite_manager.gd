extends Node3D

@export var landmark_scene: PackedScene
@export var json_url: String = "http://localhost:8080/data/satellites.json"
@export var spawn_radius: float = 10.0

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

	for i in landmarks.size():
		var landmark := landmarks[i]
		if landmark != null:
			multimesh.set_instance_transform(
				i,
				Transform3D(Basis().scaled(landmark.mesh_node.scale), landmark.position),
			)


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

	multimesh.instance_count = satellite_data.size()

	for data in satellite_data:
		var landmark := spawn_landmark(data)
		if landmark != null:
			landmarks.append(landmark)


func setup_multimesh() -> void:
	if multimesh_instance != null:
		multimesh_instance.queue_free()

	multimesh_instance = MultiMeshInstance3D.new()
	multimesh = MultiMesh.new()

	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.mesh = BoxMesh.new()

	multimesh_instance.multimesh = multimesh
	add_child(multimesh_instance)


func spawn_landmark(data: Dictionary) -> Landmark:
	var landmark := landmark_scene.instantiate() as Landmark
	if landmark == null:
		return null

	add_child(landmark)

	var lat_rad := deg_to_rad(data["latitude"])
	var lon_rad := deg_to_rad(data["longitude"])

	landmark.position = Vector3(
		spawn_radius * cos(lat_rad) * cos(lon_rad),
		spawn_radius * sin(lat_rad),
		spawn_radius * cos(lat_rad) * sin(lon_rad),
	)

	landmark.setup(
		data["int_designator"],
		data["norad_id"],
		data["name"],
		data["country"],
		data["launch"],
		data["latitude"],
		data["longitude"],
	)

	return landmark
