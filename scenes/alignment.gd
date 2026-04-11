class_name Alignment
extends Node3D

@export var north_vector = Vector3(0, 0, 0)
@export var east_vector = Vector3(0, 0, 0)
@export var south_vector = Vector3(0, 0, 0)
@export var west_vector = Vector3(0, 0, 0)


func get_cardinal_directions() -> void:
	#use if not aligning correctly due to wait
	#await get_tree().create_timer(0.1).timeout
	var geocentric_basis = InputX.get_geocentric_basis()
	east_vector = geocentric_basis.x
	south_vector = geocentric_basis.z
	west_vector = -east_vector
	north_vector = -south_vector
