extends Node3D

@export var landmark_scene: PackedScene
@export var json_path: String = "/Users/dannyjohnston/Downloads/satellites.json"

var satellite_data: Array = []

var spawn_radius: float = 10.0


func _ready() -> void:
	load_satellite_data()
	spawn_all_landmarks()


func load_satellite_data() -> void:
	if not FileAccess.file_exists(json_path):
		push_error("JSON file not found at: " + json_path)
		return

	var file = FileAccess.open(json_path, FileAccess.READ)
	var json_text = file.get_as_text()
	file.close()

	var parsed = JSON.parse_string(json_text)

	if typeof(parsed) != TYPE_ARRAY:
		push_error("JSON format invalid!")
		return

	satellite_data = parsed


func spawn_all_landmarks() -> void:
	for data in satellite_data:
		spawn_landmark(data)


func spawn_landmark(data: Dictionary) -> void:
	if landmark_scene == null:
		return

	var landmark = landmark_scene.instantiate()
	add_child(landmark)

	# Convert latitude/longitude → Cartesian (radius = 10m)
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
