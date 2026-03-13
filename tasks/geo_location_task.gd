extends TaskNode
## Initializes the Geo-Location provider and awaits the first location update.

func _task() -> void:
	print("'GeoLocation._task': initializing geo-location provider")
	GeoLocation.init_provider()
