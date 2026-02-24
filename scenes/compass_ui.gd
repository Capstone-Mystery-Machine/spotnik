extends Node3D

@onready var north_label_sprite = $SpriteNorth
@onready var east_label_sprite = $SpriteEast
@onready var south_label_sprite = $SpriteSouth
@onready var west_label_sprite = $SpriteWest
@onready var compass = preload("res://scenes/compass_points.tscn")


func _ready() -> void:
	var gyro_data = load_gyro_data()

	var n = compass.instantiate()
	add_child(n)
	var e = compass.instantiate()
	add_child(e)
	var s = compass.instantiate()
	add_child(s)
	var w = compass.instantiate()
	add_child(w)

	spawn_compass(gyro_data, n, e, s, w)


func load_gyro_data() -> Dictionary:
	var basis1 = InputX.get_geocentric_basis() #try .inverse() if not working
	var east = basis1.x
	var south = basis1.z
	var west = Vector3(-basis1.x.x, -basis1.x.y, basis1.x.z)
	var north = Vector3(-basis1.z.x, -basis1.z.y, basis1.z.z)
	var cardinals = { "East": east, "South": south, "West": west, "North": north }
	return cardinals


func spawn_compass(gyro_data: Dictionary, n, e, s, w) -> void:
	var spawn_dist = 1000
	gyro_data["North"] = Vector3(gyro_data["North"].x * spawn_dist, gyro_data["North"].y * spawn_dist, gyro_data["North"].z)
	gyro_data["East"] = Vector3(gyro_data["East"].x * spawn_dist, gyro_data["East"].y * spawn_dist, gyro_data["East"].z)
	gyro_data["South"] = Vector3(gyro_data["South"].x * spawn_dist, gyro_data["South"].y * spawn_dist, gyro_data["South"].z)
	gyro_data["West"] = Vector3(gyro_data["West"].x * spawn_dist, gyro_data["West"].y * spawn_dist, gyro_data["West"].z)
	#
	#north_label_sprite.location = gyro_data["North"]
	#east_label_sprite.location = gyro_data["East"]
	#south_label_sprite.location = gyro_data["South"]
	#west_label_sprite.location = gyro_data["West"]
	n.position = gyro_data["North"]
	e.position = gyro_data["East"]
	s.position = gyro_data["South"]
	w.position = gyro_data["West"]
