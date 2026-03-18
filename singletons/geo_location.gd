class_name GeoLocation
extends RefCounted
## A singleton for handling Spotnik-specific geo-location logic.
##
## The [b]GeoLocation[/b] singleton handles the loading and data abstraction
## of platform-specific geo-location providers.

signal location_changed(location_data: LocationData)

const GEOIP_HOST: String = "ip-api.com"

const GEOIP_PATH: String = "/json/?fields=status,message,lat,lon"

const GEOIP_PORT: int = 80

## Represents the minimum duration in milliseconds for the geo-location of the
## end-user to be queried again when via GeoIP HTTP service.
const GEOIP_UPDATE_DURATION_INTERVAL: float = 1000 * 60 * 5

## Represents the minimum distance in meters for the geo-location of the end-user
## to be queried again when via sensors.
## [br]
## [b]NOTE:[/b] Not every geo-location provider supports this feature.
const SENSOR_UPDATE_DISTANCE_INTERVAL: float = 2.0

## Represents the minimum duration in milliseconds for the geo-location of the
## end-user to be queried again when via sensors.
const SENSOR_UPDATE_DURATION_INTERVAL: float = 1000 * 3

## Represents the internally cached [GeoLocation] singleton
static var _instance: GeoLocation

## Represents the [GeoLocation] singleton.
static var instance: GeoLocation:
	get:
		if _instance == null:
			_instance = GeoLocation.new()

		return _instance

## Represents the runtime instance of the loaded geo-location provider.
static var _provider_instance: Variant = null

## Represents the most recently retrieved geographical location data.
static var location_data: LocationData = null

## Represents the available geo-location provider engine names.
## [br]
## [br]
## Each provider name:
## [br]
## • Corresponds to a specific platform-level implementation or Godot plugin.
# gdlint-ignore-next-line constant-name
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

	## Spotnik is configured to use the GeoIP HTTP service.
	## [br]
	## [br]
	## [b]Behavior:[/b] Connects to the [code]ip-api.com[/code] HTTP service.
	GEOIP_PROVIDER = &"ip-api.com",
}


## Initializes the Android-specific geo-location provider and connects its signals.
static func _on_android_init() -> void:
	_provider_instance = Engine.get_singleton(ProviderName.ANDROID_PROVIDER) as JNISingleton

	if _provider_instance == null:
		push_error(
			"bad dispatch to 'GeoLocation._on_android_init' (failed to load plugin '%s')"
			% ProviderName.ANDROID_PROVIDER,
		)

		Engine.get_main_loop().quit(OSX.ExitCode.GEO_LOCATION_PLUGIN_MISSING)
		return

	_provider_instance.onLocationUpdates.connect(_on_android_location_changed)

	_provider_instance.SetMinDistMeters(SENSOR_UPDATE_DISTANCE_INTERVAL)
	_provider_instance.SetMinTimeMs(SENSOR_UPDATE_DURATION_INTERVAL)

	_provider_instance.StartListening()


## Translates the Android geo-location provider's location data into a [LocationData]
## object and emits it.
static func _on_android_location_changed(location: Dictionary) -> void:
	location_data = LocationData.new(
		location.latitude,
		location.longitude,
	)

	instance.location_changed.emit(location_data)


## Initializes the GeoIP geo-location provider and connects its signals.
static func _on_geoip_init() -> void:
	var scene_tree = Engine.get_main_loop()

	while true:
		await _on_geoip_poll()
		await scene_tree.create_timer(GEOIP_UPDATE_DURATION_INTERVAL / 1000).timeout


## Polls GeoIP HTTP service and then translates the provider's location data into
## a [LocationData] object and emits it.
static func _on_geoip_poll() -> void:
	var response = await GlobalScopeX.fetch_json(
		false,
		GEOIP_HOST,
		GEOIP_PORT,
		GEOIP_PATH,
	)

	if response == null:
		push_error(
			"bad dispatch to '_on_geoip_poll' (no response from provider)",
		)

		return

	var body = response.body

	if body.status != "success":
		push_error(
			"bad dispatch to '_on_geoip_poll' (provider returned error %s)" % body.message,
		)

		return

	location_data = LocationData.new(
		body.lat,
		body.lon,
	)

	instance.location_changed.emit(location_data)


## Initializes the geo-location provider based on the engine export's specific project
## settings.
static func init_provider() -> void:
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
		ProviderName.GEOIP_PROVIDER:
			_on_geoip_init()
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

			Engine.get_main_loop().quit(OSX.ExitCode.GEO_LOCATION_PLUGIN_UNSUPPORTED)

	print(
		"'GeoLocation.init_provider': geo-location provider '%s' successfully loaded"
		% provider_name,
	)
