@tool
extends Node3D

@onready var orbital_tilt: Node3D = %OrbitalTilt

@onready var tweener_x: TweenerX = %TweenerX

enum OrbitalQuad {
	HORIZON,
	QUAD_TWO,
	QUAD_THREE,
}

const quad_selection: Array[OrbitalQuad] = [
	OrbitalQuad.HORIZON,
	OrbitalQuad.QUAD_TWO,
	OrbitalQuad.QUAD_THREE,
]

var _quad_selection: Array[OrbitalQuad] = [
	OrbitalQuad.QUAD_TWO,
	OrbitalQuad.QUAD_THREE,
]


func on_progress_repeated() -> void:
	match _quad_selection.pop_front():
		OrbitalQuad.HORIZON:
			orbital_tilt.rotation_degrees.z = 0
		OrbitalQuad.QUAD_TWO:
			orbital_tilt.rotation_degrees.z = randf_range(15, 60)
		OrbitalQuad.QUAD_THREE:
			orbital_tilt.rotation_degrees.z = randf_range(-60, -15)

	if _quad_selection.is_empty():
		_quad_selection = quad_selection.duplicate()


func _ready() -> void:
	tweener_x.progress_repeated.connect(on_progress_repeated)
