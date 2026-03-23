extends Node3D

@onready var north_label_sprite = %SpriteNorth
@onready var east_label_sprite = %SpriteEast
@onready var south_label_sprite = %SpriteSouth
@onready var west_label_sprite = %SpriteWest
@export var spawn_dist = 20


func _ready() -> void:
	north_label_sprite.position = Vector3(0, -2, 20)
	east_label_sprite.position = Vector3(-20, -2, 0)
	south_label_sprite.position = Vector3(0, -2, -20)
	west_label_sprite.position = Vector3(20, -2, 0)


#not in use due to hardcoding being more reliable and accurate
func load_gyro_data() -> Dictionary:
	var geocentric_basis = InputX.get_geocentric_basis()
	var east = geocentric_basis.x
	var south = geocentric_basis.z
	var west = -east
	var north = -south
	var cardinals = { "East": east, "South": south, "West": west, "North": north }
	return cardinals


func align_compass(gyro_data: Dictionary) -> void:
	await get_tree().create_timer(1).timeout
	gyro_data["North"] = Vector3(gyro_data["North"].x * spawn_dist, gyro_data["North"].y, gyro_data["North"].z * spawn_dist)
	gyro_data["East"] = Vector3(gyro_data["East"].x * spawn_dist, gyro_data["East"].y, gyro_data["East"].z * spawn_dist)
	gyro_data["South"] = Vector3(gyro_data["South"].x * spawn_dist, gyro_data["South"].y, gyro_data["South"].z * spawn_dist)
	gyro_data["West"] = Vector3(gyro_data["West"].x * spawn_dist, gyro_data["West"].y, gyro_data["West"].z * spawn_dist)
	north_label_sprite.position = gyro_data["North"]
	east_label_sprite.position = gyro_data["East"]
	south_label_sprite.position = gyro_data["South"]
	west_label_sprite.position = gyro_data["West"]
