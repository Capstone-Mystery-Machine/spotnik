extends Node2D

@onready var settings_canvas = %SettingsCanvas


func _ready() -> void:
	SignalBus.instance.settings_open.connect(_settings_open)
	settings_canvas.visible = false


func _on_return_pressed() -> void:
	settings_canvas.visible = false


func _settings_open() -> void:
	settings_canvas.visible = true
