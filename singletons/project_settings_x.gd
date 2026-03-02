class_name ProjectSettingsX
extends Node
## A singleton for Spotnik-specific project settings management.

@warning_ignore("shadowed_variable_base_class")
## Returns the platform-specific project setting, if available. Otherwise, the generic
## project setting will be returned.
static func get_platform_setting(name: String) -> Variant:
	var platform_name = "%s.%s" \
	% [name, OS.get_name().to_lower()]

	if ProjectSettings.has_setting(platform_name):
		return ProjectSettings.get_setting(platform_name)

	return ProjectSettings.get_setting(name)
