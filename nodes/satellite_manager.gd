extends Node3D

@export var landmark_scene: PackedScene
@export var spawn_radius: float = 100.0

@export var observer_lat_deg: float = 40.7934
@export var observer_lon_deg: float = -77.8600
@export var observer_alt_km: float = 0.0

var satellite_data: Array = []
var landmarks: Array[Landmark] = []

@onready var multimesh_instance: MultiMeshInstance3D = $SatelliteMultiMesh

var multimesh: MultiMesh


func _ready() -> void:
	setup_multimesh()

	if GeoLocation.location_data != null:
		observer_lat_deg = GeoLocation.location_data.latitude
		observer_lon_deg = GeoLocation.location_data.longitude

	GeoLocation.instance.location_changed.connect(_on_location_changed)
	GeoLocation.init_provider()

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


func _on_location_changed(location_data: LocationData) -> void:
	observer_lat_deg = location_data.latitude
	observer_lon_deg = location_data.longitude


func _process(_delta: float) -> void:
	if multimesh == null:
		return

	for i in range(landmarks.size()):
		var landmark := landmarks[i]
		if landmark == null:
			continue

		update_landmark_visual(landmark)

		if not landmark.visible:
			multimesh.set_instance_transform(
				i,
				Transform3D(
					Basis().scaled(Vector3.ZERO),
					landmark.position,
				),
			)
			continue

		var scale_vec: Vector3 = Vector3.ONE * landmark.visual_scale

		multimesh.set_instance_transform(
			i,
			Transform3D(
				Basis().scaled(scale_vec),
				landmark.position,
			),
		)


func update_landmark_visual(landmark: Landmark) -> void:
	var observer_pos := geodetic_to_ecef(
		observer_lat_deg,
		observer_lon_deg,
		observer_alt_km,
	)

	var los := landmark.pos - observer_pos
	var sky_dir := ecef_to_local_sky_dir(los, observer_lat_deg, observer_lon_deg)

	if sky_dir.length_squared() <= 0.0:
		landmark.set_hidden_state()
		return

	landmark.set_visual_direction(sky_dir, spawn_radius)
	landmark.visible = true

	landmark.set_interaction_enabled(landmark.is_on_screen)


func geodetic_to_ecef(lat_deg: float, lon_deg: float, alt_km: float) -> Vector3:
	var lat := deg_to_rad(lat_deg)
	var lon := deg_to_rad(lon_deg)
	var r := 6371.0 + alt_km

	return Vector3(
		r * cos(lat) * cos(lon),
		r * sin(lat),
		r * cos(lat) * sin(lon),
	)


func ecef_to_local_sky_dir(los: Vector3, lat_deg: float, lon_deg: float) -> Vector3:
	if los.length_squared() <= 0.0:
		return Vector3.ZERO

	var lat := deg_to_rad(lat_deg)
	var lon := deg_to_rad(lon_deg)
	var dir := los.normalized()

	var up := Vector3(
		cos(lat) * cos(lon),
		sin(lat),
		cos(lat) * sin(lon),
	).normalized()

	var east := Vector3(
		-sin(lon),
		0.0,
		cos(lon),
	).normalized()

	var north := up.cross(east).normalized()

	var e := dir.dot(east)
	var n := dir.dot(north)
	var u := dir.dot(up)

	if u <= 0.0:
		return Vector3.ZERO

	return Vector3(e, u, -n).normalized()


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
	update_landmark_visual(landmark)

	return landmark
