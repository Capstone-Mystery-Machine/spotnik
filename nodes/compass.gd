extends Node3D

@onready var north_sprite = %NorthSprite
@onready var east_sprite = %EastSprite
@onready var south_sprite = %SouthSprite
@onready var west_sprite = %WestSprite
@onready var direction_marker_dist = 10


func _process(_delta):
	var direction_dict = Alignment.get_cardinal_directions()
	north_sprite.position = direction_dict["North"] * direction_marker_dist
	east_sprite.position = direction_dict["East"] * direction_marker_dist
	south_sprite.position = direction_dict["South"] * direction_marker_dist
	west_sprite.position = direction_dict["West"] * direction_marker_dist
