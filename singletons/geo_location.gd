class_name GeoLocation
extends RefCounted

signal location_changed(location_data: LocationData)

static var instance: GeoLocation = GeoLocation.new()

var _plugin_instance: Variant = null

var location_data: LocationData = null

const PluginName = {
	NONE = null,
	ANDROID_PLUGIN = &"PraxisMapperGPSPlugin",
}


func _get_geo_location_plugin_name() -> StringName:
	return ProjectSettings.get_setting("spotnik/geo_location/plugin_name")


func _on_android_init() -> void:
	_plugin_instance = Engine.get_singleton(PluginName.ANDROID_PLUGIN)

	if _plugin_instance == null:
		push_error(
			"bad dispatch to 'GeoLocation._on_android_init' (failed to load"
			+ "plugin '" + PluginName.ANDROID_PLUGIN + "')",
		)

		Engine.get_main_loop().quit()

	_plugin_instance.onLocationUpdates.connect(_on_android_location_changed)


func _on_android_location_changed(location: Dictionary[String, float]) -> void:
	location_data = LocationData.new(
		location.latitude,
		location.longitude,
	)

	emit_signal("location_changed", location_data)


func init_plugin() -> void:
	if _plugin_instance != null:
		push_error("bad dispatch to 'GeoLocation.init_plugin' (plugin was already loaded)")
		return

	var plugin_name = _get_geo_location_plugin_name()

	print("'GeoLocation.init_plugin': trying to load geo-location plugin '%s'" % plugin_name)

	match plugin_name:
		PluginName.ANDROID_PLUGIN:
			_on_android_init()
		null:
			print("'GeoLocation.init_plugin': no geo-location plugin was specified, skipping")
			return
		_:
			push_error(
				"bad dispatch to 'GeoLocation.init_plugin' (plugin '"
				+ plugin_name + "' not supported)",
			)

			Engine.get_main_loop().quit()

	print("'GeoLocation.init_plugin': geo-location plugin '%s' successfully loaded" % plugin_name)
