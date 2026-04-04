extends GutTest

var _original_input_mode: InputX.InputMode


func before_each() -> void:
	_original_input_mode = UserSettings.input_mode


func after_each() -> void:
	UserSettings.input_mode = _original_input_mode


func test_01_instance_is_not_null():
	var instance = InputX.instance

	assert_not_null(instance, "Instance should be created on first access.")


func test_02_instance_is_singleton():
	var instance1 = InputX.instance
	var instance2 = InputX.instance

	assert_same(instance1, instance2, "Multiple accesses should return the same instance.")


func test_03_is_platform_mouse_mode_true_on_desktop():
	# Note: OS.has_feature cannot be changed at runtime. This test assumes a desktop
	# test environment.
	if not OS.has_feature("mobile"):
		assert_true(
			InputX._is_platform_mouse_input_mode(),
			"Should be true on non-mobile platforms.",
		)


func test_04_is_platform_gyro_mode_false_on_desktop():
	if not OS.has_feature("mobile"):
		assert_false(
			InputX._is_platform_gyro_input_mode(),
			"Gyro mode should always be false on desktop.",
		)


func test_05_is_platform_touch_mode_false_on_desktop():
	if not OS.has_feature("mobile"):
		assert_false(
			InputX._is_platform_touch_input_mode(),
			"Touch mode should always be false on desktop.",
		)


func test_06_gyro_mode_false_on_desktop_even_with_sensors():
	if not OS.has_feature("mobile"):
		ProjectSettings.set_setting("input_devices/sensors/enable_gravity", true)
		ProjectSettings.set_setting("input_devices/sensors/enable_magnetometer", true)

		assert_false(
			InputX._is_platform_gyro_input_mode(),
			"Gyro mode must remain false on desktop despite sensor settings.",
		)


func test_07_touch_mode_false_on_desktop_even_without_sensors():
	if not OS.has_feature("mobile"):
		ProjectSettings.set_setting("input_devices/sensors/enable_gravity", false)
		ProjectSettings.set_setting("input_devices/sensors/enable_magnetometer", false)

		assert_false(
			InputX._is_platform_touch_input_mode(),
			"Touch mode must remain false on desktop despite missing sensors.",
		)


func test_08_touch_mode_false_on_desktop_with_mixed_sensors():
	if not OS.has_feature("mobile"):
		ProjectSettings.set_setting("input_devices/sensors/enable_gravity", true)
		ProjectSettings.set_setting("input_devices/sensors/enable_magnetometer", false)

		assert_false(
			InputX._is_platform_touch_input_mode(),
			"Touch mode must remain false on desktop with mixed sensor settings.",
		)


func test_09_platform_input_mode_evaluates_to_mouse():
	if not OS.has_feature("mobile"):
		var expected = InputX.InputMode.INPUT_MOUSE
		var actual = InputX._get_platform_input_mode()

		assert_eq(
			actual,
			expected,
			"Platform input mode should evaluate to mouse on desktop.",
		)


func test_10_static_platform_input_mode_is_mouse():
	if not OS.has_feature("mobile"):
		var expected = InputX.InputMode.INPUT_MOUSE
		var actual = InputX.platform_input_mode

		assert_eq(
			actual,
			expected,
			"The cached platform input mode must be mouse on desktop.",
		)


func test_11_input_mode_returns_preferred():
	UserSettings.input_mode = InputX.InputMode.INPUT_GYRO

	assert_eq(
		InputX.input_mode,
		InputX.InputMode.INPUT_GYRO,
		"Input mode should return the preferred mode.",
	)


func test_12_input_mode_falls_back_to_platform():
	var expected = InputX.platform_input_mode
	UserSettings.input_mode = InputX.InputMode.INPUT_NONE

	assert_eq(
		InputX.input_mode,
		expected,
		"Input mode should fallback to platform mode if preferred is NONE.",
	)


func test_13_get_gravitational_down_is_normalized():
	var grav_down = InputX.get_gravitational_down()

	if grav_down != Vector3.ZERO:
		assert_almost_eq(
			grav_down.length(),
			1.0,
			0.001,
			"Gravitational down vector must be normalized.",
		)


func test_14_get_cardinal_east_is_normalized():
	var up = Vector3(0, 1, 0)
	var east = InputX.get_cardinal_east(up)

	if east != Vector3.ZERO:
		assert_almost_eq(
			east.length(),
			1.0,
			0.001,
			"Cardinal east vector must be normalized.",
		)


func test_15_get_cardinal_north_is_orthogonal():
	var up = Vector3(0, 1, 0)
	var east = Vector3(1, 0, 0)
	var north = InputX.get_cardinal_north(east, up)

	assert_almost_eq(
		north.dot(east),
		0.0,
		0.001,
		"North should be orthogonal to East.",
	)

	assert_almost_eq(
		north.dot(up),
		0.0,
		0.001,
		"North should be orthogonal to Up.",
	)


func test_16_get_geocentric_basis_is_valid_rotation():
	var basis = InputX.get_geocentric_basis()

	assert_almost_eq(
		basis.determinant(),
		1.0,
		0.001,
		"Geocentric basis must have a determinant of 1.",
	)


func test_17_get_geocentric_euler_matches_basis():
	var expected = InputX.get_geocentric_basis().get_euler()
	var actual = InputX.get_geocentric_euler()

	assert_eq(
		actual,
		expected,
		"Euler angles should match the geocentric basis.",
	)


func test_18_get_geocentric_quaternion_matches_basis():
	var expected = InputX.get_geocentric_basis().get_rotation_quaternion()
	var actual = InputX.get_geocentric_quaternion()

	assert_eq(
		actual,
		expected,
		"Quaternion should match the geocentric basis.",
	)


func test_19_get_geocentric_transform_contains_correct_basis():
	var expected_basis = InputX.get_geocentric_basis()
	var transform = InputX.get_geocentric_transform()

	assert_eq(
		transform.basis,
		expected_basis,
		"Transform must use the geocentric basis.",
	)


func test_20_get_geocentric_transform_origin_is_zero():
	var transform = InputX.get_geocentric_transform()

	assert_eq(
		transform.origin,
		Vector3.ZERO,
		"Transform origin must be strictly zero.",
	)
