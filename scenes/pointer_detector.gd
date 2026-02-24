extends Area3D

signal inner_entered(body: CollisionObject3D)
signal inner_exited(body: CollisionObject3D)
signal outer_entered(body: CollisionObject3D)
signal outer_exited(body: CollisionObject3D)

## Represents the size of the inner trigger zone of the satellite nodes.
@export var inner_radius: float = 0.5

var outer_bodies: Dictionary = { }
var inner_bodies: Dictionary = { }

var inner_radius_sq: float


func _ready() -> void:
	inner_radius_sq = inner_radius * inner_radius


func _process(_delta: float) -> void:
	var center := global_position

	for body in outer_bodies:
		var dist_sq := center.distance_squared_to(body.global_position)

		if dist_sq <= inner_radius_sq:
			if not inner_bodies.has(body):
				inner_bodies[body] = true
				print(body.name, " entered INNER radius")
				emit_signal("inner_entered", body)
		elif inner_bodies.has(body):
			print(body.name, " exited INNER radius")
			inner_bodies.erase(body)
			emit_signal("inner_exited", body)


func _on_body_entered(body: CollisionObject3D) -> void:
	print(body.name, " entered OUTER radius")
	outer_bodies[body] = true
	emit_signal("outer_entered", body)


func _on_body_exited(body: CollisionObject3D) -> void:
	outer_bodies.erase(body)

	if inner_bodies.erase(body):
		print(body.name, " exited INNER radius")
		emit_signal("inner_exited", body)

	print(body.name, " exited OUTER area")
	emit_signal("outer_exited", body)
