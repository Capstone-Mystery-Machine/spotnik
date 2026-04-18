extends Node3D

@export var landmark_scene: PackedScene
@export var spawn_radius: float = 10.0

var satellite_data: Array = []
var landmarks: Array[Landmark] = []

@onready var multimesh_instance: MultiMeshInstance3D = $SatelliteMultiMesh

var multimesh: MultiMesh


func _ready() -> void:
	var source: String = DataSource.get_data_source()

	print("Resolved data source: ", source)

	if source.is_empty():
		push_error("No data source could be resolved.")
		return

	if source.begins_with("http://") or source.begins_with("https://"):
		$HTTPRequest.request_completed.connect(_on_request_completed)
		var err: Error = $HTTPRequest.request(source)
		if err != OK:
			push_error("Failed to start HTTP request: %s" % err)
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
	if not FileAccess.file_exists(path):
		push_error("Local data file does not exist: %s" % path)
		return

	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to open local data file: %s" % path)
		return

	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if parsed == null:
		push_error("Failed to parse local JSON from: %s" % path)
		return

	satellite_data = parsed
	spawn_all_landmarks()


func _on_request_completed(
		_result: int,
		_code: int,
		_headers: PackedStringArray,
		body: PackedByteArray,
) -> void:
	if _code != 200:
		push_error("HTTP request failed with response code: %s" % _code)
		return

	var parsed: Variant = JSON.parse_string(body.get_string_from_utf8())
	if parsed == null:
		push_error("Failed to parse HTTP JSON response.")
		return

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
	landmark.setup_from_orbital_data(data)

	return landmark
