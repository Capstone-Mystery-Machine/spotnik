extends Node3D

@onready var north_label_sprite = $SpriteNorth
@onready var east_label_sprite = $SpriteEast
@onready var south_label_sprite = $SpriteSouth
@onready var west_label_sprite = $SpriteWest


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	north_label_sprite.position = Vector3(20, -2, 0)
	east_label_sprite.position = Vector3(0, -2, 20)
	south_label_sprite.position = Vector3(-20, -2, 0)
	west_label_sprite.position = Vector3(0, -2, -20)
