class_name PlanetAnimationScene
extends Node3D

@export var fov: float = 100.0:
	set(value):
		fov = value

		if is_node_ready() and camera:
			camera.fov = value

@onready var camera: Camera3D = %Camera3D
