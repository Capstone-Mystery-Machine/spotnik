extends TaskNode
## Initializes the Geo-Location provider and awaits the first location update.

func _task() -> void:
	print("'GeoLocation._task': initializing geo-location provider")
	GeoLocation.init_provider()

	if GeoLocation.location_data == null:
		print(
			"'GeoLocation._task': no geo-location data available, awaiting initial data",
		)

		await GeoLocation.instance.location_changed

		print("'GeoLocation._task': initial geo-location data received")
