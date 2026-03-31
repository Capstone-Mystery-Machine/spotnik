extends Node3D

@export var landmark_scene: PackedScene
@export var spawn_radius: float = 10.0

var satellite_data: Array = []
var landmarks: Array[Landmark] = []

@onready var multimesh_instance: MultiMeshInstance3D = $SatelliteMultiMesh

var multimesh: MultiMesh


func _ready() -> void:
	var source := DataSource.get_data_source("spotnik/data_source")

	if source.begins_with("http://") or source.begins_with("https://"):
		$HTTPRequest.request_completed.connect(_on_request_completed)
		$HTTPRequest.request(source)
	else:
		load_local_data(source)


func _process(_delta: float) -> void:
	if multimesh == null:
		return

	for i in range(landmarks.size()):
		var landmark := landmarks[i]
		if landmark != null:
			var scale_vec: Vector3 = Vector3.ONE * landmark.visual_scale
			multimesh.set_instance_transform(
				i,
				Transform3D(Basis().scaled(scale_vec), landmark.position),
			)


func load_local_data(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	var parsed = JSON.parse_string(file.get_as_text())

	satellite_data = parsed
	spawn_all_landmarks()


func _on_request_completed(
		_result: int,
		_code: int,
		_headers: PackedStringArray,
		body: PackedByteArray,
) -> void:
	var parsed = JSON.parse_string(body.get_string_from_utf8())

	satellite_data = parsed
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
	multimesh = multimesh_instance.multimesh


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
