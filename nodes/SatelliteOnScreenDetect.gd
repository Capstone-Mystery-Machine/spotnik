extends VisibleOnScreenNotifier3D

@export var detector_path: NodePath = "../CameraPointerDetector/CollisionShape3D"


func _ready() -> void:
	var collision_shape := get_node_or_null(detector_path) as CollisionShape3D
	var shape: SphereShape3D = collision_shape.shape
	var radius: float = shape.radius
	var size: Vector3 = Vector3.ONE * radius

	aabb.position = -size / 2.0
	aabb.size = size
