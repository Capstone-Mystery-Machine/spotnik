extends Node

#@export var info_ui_scene: PackedScene
@onready var info_ui_scene = preload("res://nodes/satel_info_ui.tscn")

var _satel_info_box: SatelUI = null


func _ready():
	SignalBus.instance.ui_enter.connect(_ui_enter_signal)
	SignalBus.instance.ui_exit.connect(_ui_exit_signal)


func _ui_enter_signal(landmark: Landmark) -> void:
	if _satel_info_box != null:
		_satel_info_box.queue_free()
		_satel_info_box = null

	_satel_info_box = info_ui_scene.instantiate() as SatelUI

	add_child(_satel_info_box)
	_satel_info_box.setup_satel_ui(landmark)


func _ui_exit_signal() -> void:
	if _satel_info_box != null:
		_satel_info_box.queue_free()
		_satel_info_box = null
