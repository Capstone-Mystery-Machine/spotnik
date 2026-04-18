class_name SettingsMenu

static var _settings_menu_screen: SettingsMenuScreen = null

static var visible: bool:
	get():
		_get_settings_menu_screen()
		return _settings_menu_screen.visible


static func _get_settings_menu_screen() -> void:
	if not is_instance_valid(_settings_menu_screen):
		var scene_tree = Engine.get_main_loop() as SceneTree
		_settings_menu_screen = scene_tree.get_first_node_in_group("SettingsMenuScreen")


static func close() -> void:
	_get_settings_menu_screen()
	_settings_menu_screen.visible = false


static func open() -> void:
	_get_settings_menu_screen()
	_settings_menu_screen.visible = true
