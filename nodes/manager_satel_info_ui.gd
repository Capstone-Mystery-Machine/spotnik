extends Node

#@export var info_ui_scene: PackedScene
@onready var info_ui_scene = preload("res://nodes/satel_info_ui.tscn")


func _ready():
	SignalBus.instance.ui_info.connect(_ui_info_signal)


func _ui_info_signal(landmark: Landmark) -> SatelUI:
	var satel_info_box := info_ui_scene.instantiate() as SatelUI

	add_child(satel_info_box)
	satel_info_box.setup_satel_ui(landmark)

	return satel_info_box
