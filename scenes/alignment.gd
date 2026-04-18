class_name Alignment
extends Node3D

static func get_cardinal_directions() -> Dictionary:
	var geocentric_basis = InputX.instance.get_geocentric_basis_smoothed()
	var west_vector = Vector3(geocentric_basis.x.x, geocentric_basis.y.x, geocentric_basis.z.x)
	var north_vector = Vector3(geocentric_basis.x.z, geocentric_basis.y.z, geocentric_basis.z.z)
	var east_vector = -west_vector
	var south_vector = -north_vector

	var cardinal_dict = {
		"North": north_vector,
		"East": east_vector,
		"South": south_vector,
		"West": west_vector,
	}
	return cardinal_dict
