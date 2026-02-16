extends Node3D

@export var spawn_positions: Array[Vector3] = [
	Vector3(-2.7409, 2.864, -2.4372),
	Vector3(3.1786, 2.2535, -2.1817),
	Vector3(2.4875, -2.6795, -2.8872),
	Vector3(2.0, 2.0, 3.2192),
	Vector3(-3.0571, 2.5818, 2.175)]

@onready var template: Node3D = $Landmark

func _ready():
	spawn_all_satellites()

func spawn_all_satellites() -> void:
	for pos in spawn_positions:
		spawn_satellite_at(pos)

func spawn_satellite_at(pos: Vector3) -> void:
	
	var satellite_copy = template.duplicate()
	add_child(satellite_copy)
	satellite_copy.global_position = global_position + pos
