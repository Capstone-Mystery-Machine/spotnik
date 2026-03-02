class_name GeoLocation
extends RefCounted
## A singleton for handling Spotnik-specific geo-location logic.
##
## The [b]GeoLocation[/b] singleton handles the loading and data abstraction
## of platform-specific geo-location providers.

signal location_changed(location_data: LocationData)

## Represents the [GeoLocation] singleton.
static var instance: GeoLocation = GeoLocation.new()

## Represents the runtime instance of the loaded geo-location provider.
var _provider_instance: Variant = null

## Represents the most recently retrieved geographical location data.
var location_data: LocationData = null

## Represents the available geo-location provider engine names.
## [br]
## [br]
## Each provider name:
## [br]
## • Corresponds to a specific platform-level implementation or Godot plugin.
const ProviderName = {
	## Spotnik is configured to not utilize a geo-location provider.
	## [br]
	## [br]
	## [b]Behavior:[/b] Geo-location initialization is skipped.
	NONE = null,

	## Spotnik is configured to use the Android GPS plugin.
	## [br]
	## [br]
	## [b]Behavior:[/b] Connects to the [code]PraxisMapperGPSPlugin[/code] plugin.
	ANDROID_PROVIDER = &"PraxisMapperGPSPlugin",
}


## Initializes the Android-specific geo-location provider and connects its signals.
func _on_android_init() -> void:
	_provider_instance = Engine.get_singleton(ProviderName.ANDROID_PROVIDER)

	if _provider_instance == null:
		push_error(
			"bad dispatch to 'GeoLocation._on_android_init' (failed to load plugin '%s')"
			% ProviderName.ANDROID_PROVIDER,
		)

		Engine.get_main_loop().quit()
		return

	_provider_instance.onLocationUpdates.connect(_on_android_location_changed)
	_provider_instance.StartListening()


## Translates the Android geo-location provider's location data into a [LocationData]
## object and emits it.
func _on_android_location_changed(location: Dictionary[String, float]) -> void:
	location_data = LocationData.new(
		location.latitude,
		location.longitude,
	)

	emit_signal("location_changed", location_data)


## Initializes the geo-location provider based on the engine export's specific project
## settings.
func init_provider() -> void:
	if _provider_instance != null:
		push_error(
			"bad dispatch to 'GeoLocation.init_provider' (provider was already loaded)",
		)

		return

	var provider_name = ProjectSettingsX.get_platform_setting(
		"spotnik/geo_location/provider_name",
	)

	print(
		"'GeoLocation.init_provider': trying to load geo-location provider '%s'"
		% provider_name,
	)

	match provider_name:
		ProviderName.ANDROID_PROVIDER:
			_on_android_init()
		null:
			print(
				"'GeoLocation.init_provider': no geo-location provider was specified, skipping",
			)

			return
		_:
			push_error(
				"bad dispatch to 'GeoLocation.init_provider' (provider '%s' not supported)"
				% provider_name,
			)

			Engine.get_main_loop().quit()

	print(
		"'GeoLocation.init_provider': geo-location provider '%s' successfully loaded"
		% provider_name,
	)
