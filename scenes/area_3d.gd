extends Area3D

@export var inner_radius: float = 0.5

# Bodies currently inside the INNER radius
var inner_bodies: Dictionary[CollisionObject3D, bool] = { }

signal inner_entered(body: CollisionObject3D)
signal inner_exited(body: CollisionObject3D)
signal outer_entered(body: CollisionObject3D)
signal outer_exited(body: CollisionObject3D)

var space_state: PhysicsDirectSpaceState3D
var inner_shape: SphereShape3D


func _ready() -> void:
	space_state = get_world_3d().direct_space_state

	inner_shape = SphereShape3D.new()
	inner_shape.radius = inner_radius


func _process(_delta: float) -> void:
	var query := PhysicsShapeQueryParameters3D.new()
	query.shape = inner_shape
	query.transform = Transform3D(Basis(), global_transform.origin)
	query.collide_with_bodies = true
	query.collide_with_areas = false

	var results: Array = space_state.intersect_shape(query)

	var currently_inside: Dictionary[CollisionObject3D, bool] = { }

	for hit in results:
		var body := hit.collider as CollisionObject3D
		if body == null:
			continue

		currently_inside[body] = true

		if not inner_bodies.has(body):
			inner_bodies[body] = true
			print(body.name, " entered INNER radius")
			emit_signal("inner_entered", body)

	# Detect exits
	for body in inner_bodies.keys():
		if not currently_inside.has(body):
			print(body.name, " exited INNER radius")
			emit_signal("inner_exited", body)
			inner_bodies.erase(body)


func _on_body_entered(body: CollisionObject3D) -> void:
	print(body.name, " entered OUTER area")
	emit_signal("outer_entered", body)


func _on_body_exited(body: CollisionObject3D) -> void:
	emit_signal("outer_exited", body)
	inner_bodies.erase(body)
