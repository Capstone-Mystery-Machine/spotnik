extends Node3D

@onready var crosshair: Control = $Crosshair
@onready var settings_ui_layer: SettingsUILayer = $SettingsUILayer

var content_alpha: float = 1.0:
	set(value):
		content_alpha = value

		if not is_node_ready():
			return

		crosshair.modulate.a = value
		settings_ui_layer.content_alpha = value
