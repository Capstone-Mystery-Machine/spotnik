class_name SettingsUILayer
extends CanvasLayer

@onready var settings_button_screen: SettingsButtonScreen = %SettingsButtonScreen
@onready var settings_menu_screen: SettingsMenuScreen = %SettingsMenuScreen


func _on_settings_button_pressed():
	settings_menu_screen.visible = true


func _on_visibility_changed():
	settings_menu_screen.visible = false


func _ready():
	visibility_changed.connect(_on_visibility_changed)
	settings_button_screen.settings_button_pressed.connect(_on_settings_button_pressed)
