class_name SignalBus
extends RefCounted

signal ui_info(landmark: Landmark)
signal settings_open()

static var _instance: SignalBus

static var instance: SignalBus:
	get:
		if _instance == null:
			_instance = SignalBus.new()

		return _instance
