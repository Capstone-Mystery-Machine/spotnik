extends Node3D

@export var landmark_scene: PackedScene
@export var json_url: String = "http://localhost:8080/data/satellites.json"

var satellite_data: Array = []

@export var spawn_radius: float = 10


func _ready() -> void:
	$HTTPRequest.request_completed.connect(_on_request_completed)
	$HTTPRequest.request(json_url)


func _on_request_completed(
		_result: int,
		_code: int,
		_headers: PackedStringArray,
		body: PackedByteArray,
) -> void:
	satellite_data = JSON.parse_string(body.get_string_from_utf8())
	spawn_all_landmarks()


func spawn_all_landmarks() -> void:
	for data in satellite_data:
		spawn_landmark(data)


func spawn_landmark(data: Dictionary) -> void:
	if landmark_scene == null:
		return

	var landmark = landmark_scene.instantiate()
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
