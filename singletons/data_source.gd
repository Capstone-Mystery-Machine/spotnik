class_name DataSource
extends RefCounted

static func get_data_source() -> String:
	return ProjectSettingsX.get_platform_setting("spotnik/data_source/url")
