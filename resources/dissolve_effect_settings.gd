@tool
class_name DissolveEffectSettings
extends ResourceX
## Resource for dissolve effect settings.

## Represents the opacity removed by the dissolve noise.
@export_range(0.0, 1.0, 0.001) var intensity: float = 1.0:
	set(value):
		if was_changed_event_emitted(&"intensity", value):
			intensity = value

## Represents the dissolved hole size multiplier of the dissolving noise.
@export_range(0.0, 5.0, 0.001) var scale: float = 1.0:
	set(value):
		if was_changed_event_emitted(&"scale", value):
			scale = value

## Represents the movement speed of the dissolving noise.
@export var speed: Vector2 = Vector2(-0.001, -0.002):
	set(value):
		if was_changed_event_emitted(&"speed", value):
			speed = value

## Represents the texture warp intensity of the dissolving noise.
@export_range(0.0, 1.0, 0.001) var warp_intensity: float = 0.1:
	set(value):
		if was_changed_event_emitted(&"warp_intensity", value):
			warp_intensity = value


func _init(
		_intensity: float = 1.0,
		_scale: float = 1.0,
		_speed: Vector2 = Vector2(-0.001, -0.002),
		_warp_intensity = 0.1,
):
	intensity = _intensity
	scale = _scale
	speed = _speed
	warp_intensity = _warp_intensity
