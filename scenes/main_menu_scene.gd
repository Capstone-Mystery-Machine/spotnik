extends CanvasLayer

@onready var main_menu_screen: Control = $MainMenuScreen
@onready var settings_ui_layer: SettingsUILayer = $SettingsUILayer

var content_alpha: float = 1.0:
	set(value):
		content_alpha = value

		if not is_node_ready():
			return

		main_menu_screen.modulate.a = value
		settings_ui_layer.content_alpha = value
