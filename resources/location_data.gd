@tool
class_name LocationData
extends ResourceX
## Resource for the geo-location coordinates of a location.

## Represents the longitude of a location.
@export var latitude: float:
	set(value):
		if was_changed_event_emitted(&"latitude", value):
			latitude = value

## Represents the longitude of a location.
@export var longitude: float:
	set(value):
		if was_changed_event_emitted(&"longitude", value):
			longitude = value


func _init(
		_latitude: float = 0.0,
		_longitude: float = 0.0,
):
	latitude = _latitude
	longitude = _longitude
