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
