class_name DataSource
extends RefCounted

static func get_data_source(name: String) -> String:
	var config: Dictionary = ProjectSettings.get_setting(name, { })

	var build := "production" if OS.has_feature("production") else "debug"
	var os_name := OS.get_name().to_lower()
	var key := "%s_%s" % [build, os_name]

	if config.has(key):
		return str(config[key])

	if config.has(build):
		return str(config[build])

	if config.has(os_name):
		return str(config[os_name])

	return str(config.get("default", ""))
