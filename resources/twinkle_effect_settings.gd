## Resource for star twinkle effect settings.
class_name TwinkleEffectSettings
extends Resource

## Represents the intensity of the twinkle effect.
@export_range(0.0, 1.0, 0.001) var intensity: float = 0.5

## Represents the spatial density of the twinkle pattern. Higher values make stars twinkle independently.
@export_range(0.0, 5000.0, 1.0) var frequency: float = 1500.0

## Represents the pulsing speed of the twinkle effect.
@export_range(0.0, 20.0, 0.001) var speed: float = 2.0


func _init(
		_intensity: float = 0.5,
		_frequency: float = 1500.0,
		_speed: float = 2.0,
):
	intensity = _intensity
	frequency = _frequency
	speed = _speed
