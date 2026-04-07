class_name OrbitalMath

const EARTH_MU: float = 398600.4418


static func elements_to_state_vectors(data: Dictionary) -> Dictionary:
	var a: float = float(data["SEMIMAJOR_AXIS"])
	var e: float = float(data["ECCENTRICITY"])
	var i: float = deg_to_rad(float(data["INCLINATION"]))
	var raan: float = deg_to_rad(float(data["RA_OF_ASC_NODE"]))
	var arg_periapsis: float = deg_to_rad(float(data["ARG_OF_PERICENTER"]))
	var mean_anomaly: float = deg_to_rad(float(data["MEAN_ANOMALY"]))

	var eccentric_anomaly: float = solve_kepler(mean_anomaly, e)

	var x_orb: float = a * (cos(eccentric_anomaly) - e)
	var y_orb: float = a * sqrt(1.0 - e * e) * sin(eccentric_anomaly)
	var pos_orbital := Vector3(x_orb, y_orb, 0.0)

	var r: float = pos_orbital.length()

	var factor: float = sqrt(EARTH_MU * a) / r
	var vx_orb: float = -factor * sin(eccentric_anomaly)
	var vy_orb: float = factor * sqrt(1.0 - e * e) * cos(eccentric_anomaly)
	var vel_orbital := Vector3(vx_orb, vy_orb, 0.0)

	var rotation_matrix: Basis = make_orbit_basis(raan, i, arg_periapsis)

	return {
		"position": rotation_matrix * pos_orbital,
		"velocity": rotation_matrix * vel_orbital,
		"semimajor_axis": a,
	}


static func solve_kepler\
(mean_anomaly: float, eccentricity: float, max_iterations: int = 10) -> float:
	var BigE: float = mean_anomaly

	for n in range(max_iterations):
		var f: float = BigE - eccentricity * sin(BigE) - mean_anomaly
		var f_prime: float = 1.0 - eccentricity * cos(BigE)
		BigE -= f / f_prime

	return BigE


static func make_orbit_basis(raan: float, inclination: float, arg_periapsis: float) -> Basis:
	var rot_arg_periapsis := Basis(Vector3.FORWARD, arg_periapsis)
	var rot_inclination := Basis(Vector3.RIGHT, inclination)
	var rot_raan := Basis(Vector3.FORWARD, raan)

	return rot_raan * rot_inclination * rot_arg_periapsis
