extends AnimatableBody3D

@onready var parent: Node3D = get_parent()

##Represents distance from the camera to camera pointer
##(Should be equal to satellite spawn radius).
@export var spawn_radius = 100


func _physics_process(_delta: float) -> void:
	global_position = parent.to_global(Vector3.FORWARD * spawn_radius)
