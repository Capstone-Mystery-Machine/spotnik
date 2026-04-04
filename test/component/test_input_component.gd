extends GutTest

func test_01_input_mode_changed_signal_emitted_automatically():
	var input_x = InputX.instance

	watch_signals(input_x)
	UserSettings.input_mode = InputX.InputMode.INPUT_GYRO

	assert_signal_emitted(
		input_x,
		"input_mode_changed",
		"Signal should automatically emit when the user setting is changed.",
	)


func test_02_input_mode_reflects_user_preference():
	UserSettings.input_mode = InputX.InputMode.INPUT_TOUCH

	assert_eq(
		InputX.input_mode,
		InputX.InputMode.INPUT_TOUCH,
		"InputX should actively reflect the preferred mode from UserSettings.",
	)


func test_03_input_mode_falls_back_when_preference_is_none():
	UserSettings.input_mode = InputX.InputMode.INPUT_NONE
	var expected = InputX.platform_input_mode

	assert_eq(
		InputX.input_mode,
		expected,
		"InputX should return platform mode when UserSettings is set to NONE.",
	)


func test_04_signal_contains_correct_payload():
	var input_x = InputX.instance
	watch_signals(input_x)

	UserSettings.input_mode = InputX.InputMode.INPUT_MOUSE
	var expected_args = [
		UserSettings.SettingName.INPUT_MODE,
		InputX.InputMode.INPUT_MOUSE,
	]

	assert_signal_emitted_with_parameters(
		input_x,
		"input_mode_changed",
		expected_args,
	)
