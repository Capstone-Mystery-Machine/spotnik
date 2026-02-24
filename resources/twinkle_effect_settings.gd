@tool
class_name TwinkleEffectSettings
extends Resource
## Resource for star twinkle effect settings.

## Represents the spatial density of the twinkle pattern. Higher values make stars twinkle independently.
@export_range(0.0, 5000.0, 1.0) var frequency: float = 1500.0:
	set(value):
		if frequency != value:
			frequency = value
			emit_changed()

## Represents the intensity of the twinkle effect.
@export_range(0.0, 1.0, 0.001) var intensity: float = 0.5:
	set(value):
		if intensity != value:
			intensity = value
			emit_changed()

## Represents the pulsing speed of the twinkle effect.
@export_range(0.0, 20.0, 0.001) var speed: float = 2.0:
	set(value):
		if speed != value:
			speed = value
			emit_changed()


func _init(
		_intensity: float = 0.5,
		_frequency: float = 1500.0,
		_speed: float = 2.0,
):
	intensity = _intensity
	frequency = _frequency
	speed = _speed
