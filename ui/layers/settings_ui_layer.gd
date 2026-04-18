class_name SettingsUILayer
extends CanvasLayer

@onready var settings_button_screen: SettingsButtonScreen = %SettingsButtonScreen
@onready var settings_menu_screen: SettingsMenuScreen = %SettingsMenuScreen

var content_alpha: float = 1.0:
	set(value):
		content_alpha = value

		if not is_node_ready():
			return

		settings_button_screen.modulate.a = value
		settings_menu_screen.modulate.a = value


func _on_settings_button_pressed():
	settings_menu_screen.visible = true


func _on_visibility_changed():
	settings_menu_screen.visible = false


func _ready():
	visibility_changed.connect(_on_visibility_changed)
	settings_button_screen.settings_button_pressed.connect(_on_settings_button_pressed)
