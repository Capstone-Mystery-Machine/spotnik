@tool
class_name FlowMapDistortionEffectSettings
extends Resource
## Resource for flow map distortion effect settings.

signal property_changed(property_name: StringName, resource: FlowMapDistortionEffectSettings)

## Represents the strength of the flow map distortion.
@export_range(0.0, 1.0, 0.001) var intensity: float = 0.04:
	set(value):
		if intensity != value:
			intensity = value
			emit_changed()
			property_changed.emit(&"intensity", self)

## Represents the movement speed of the flow map distortion.
@export_range(0.0, 1.0, 0.001) var speed: float = 0.02:
	set(value):
		if speed != value:
			speed = value
			emit_changed()
			property_changed.emit(&"speed", self)


func _init(
		_intensity: float = 0.04,
		_speed: float = 0.02,
):
	intensity = _intensity
	speed = _speed
