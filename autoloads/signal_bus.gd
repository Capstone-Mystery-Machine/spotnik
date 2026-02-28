class_name SignalBus
extends Node

signal ui_info(landmark: Landmark)

static var instance: SignalBus


func _ready() -> void:
	instance = self
