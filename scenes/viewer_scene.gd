extends Node3D

@onready var crosshair: Control = $Crosshair
@onready var satel_info_ui: SatelUI = $SatelInfoUI
@onready var settings_ui_layer: SettingsUILayer = $SettingsUILayer

var content_alpha: float = 1.0:
	set(value):
		content_alpha = value

		if not is_node_ready():
			return

		crosshair.modulate.a = value
		satel_info_ui.content_alpha = value
		settings_ui_layer.content_alpha = value
