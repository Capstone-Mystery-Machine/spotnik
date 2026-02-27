@tool
class_name FlowMapDistortionEffectSettings
extends ResourceX
## Resource for flow map distortion effect settings.

## Represents the strength of the flow map distortion.
@export_range(0.0, 1.0, 0.001) var intensity: float = 0.04:
	set(value):
		if was_changed_event_emitted(&"intensity", value):
			intensity = value

## Represents the movement speed of the flow map distortion.
@export_range(0.0, 1.0, 0.001) var speed: float = 0.02:
	set(value):
		if was_changed_event_emitted(&"speed", value):
			speed = value


func _init(
		_intensity: float = 0.04,
		_speed: float = 0.02,
):
	intensity = _intensity
	speed = _speed
