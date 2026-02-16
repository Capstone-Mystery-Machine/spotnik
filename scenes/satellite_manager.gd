extends Node3D

@export var landmark_scene: PackedScene
@export var json_path: String = "/Users/dannyjohnston/Downloads/satellites.json"

var satellite_data: Array = []

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
	
	# Convert JSON position array → Vector3
	var pos_array = data["position"]
	var satPosition = Vector3(pos_array[0], pos_array[1], pos_array[2])
	landmark.position = satPosition
	
	landmark.setup(
		data["int_designator"],
		data["norad_id"],
		data["name"],
		data["country"],
		data["launch"]
	)
