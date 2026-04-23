class_name SignalBus
extends RefCounted

signal ui_enter(landmark: Landmark)

signal ui_exit()

static var _instance: SignalBus

static var instance: SignalBus:
	get:
		if _instance == null:
			_instance = SignalBus.new()

		return _instance
