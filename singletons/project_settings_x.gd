class_name ProjectSettingsX
extends RefCounted
## A singleton for Spotnik-specific project settings management.

@warning_ignore("shadowed_variable_base_class")
## Returns the platform-specific project setting, if available. Otherwise, the generic
## project setting will be returned.
static func get_platform_setting(name: String) -> Variant:
	var os_name := OS.get_name().to_lower()
	var release_mode := "production" if OS.has_feature("production") else "debug"

	var operating_system_key := "%s/%s" % [name, os_name]
	var release_key := "%s/%s" % [operating_system_key, release_mode]

	if ProjectSettings.has_setting(release_key):
		return ProjectSettings.get_setting(release_key)

	if ProjectSettings.has_setting(operating_system_key):
		return ProjectSettings.get_setting(operating_system_key)

	return ProjectSettings.get_setting(name)
