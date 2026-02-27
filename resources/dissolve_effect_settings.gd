@tool
class_name DissolveEffectSettings
extends Resource
## Resource for dissolve effect settings.

signal property_changed(property_name: StringName, resource: DissolveEffectSettings)

## Represents the opacity removed by the dissolve noise.
@export_range(0.0, 1.0, 0.001) var intensity: float = 1.0:
	set(value):
		if intensity != value:
			intensity = value
			emit_changed()
			property_changed.emit(&"intensity", self)

## Represents the dissolved hole size multiplier of the dissolving noise.
@export_range(0.0, 5.0, 0.001) var scale: float = 1.0:
	set(value):
		if scale != value:
			scale = value
			emit_changed()
			property_changed.emit(&"scale", self)

## Represents the movement speed of the dissolving noise.
@export var speed: Vector2 = Vector2(-0.001, -0.002):
	set(value):
		if speed != value:
			speed = value
			emit_changed()
			property_changed.emit(&"speed", self)

## Represents the texture warp intensity of the dissolving noise.
@export_range(0.0, 1.0, 0.001) var warp_intensity: float = 0.1:
	set(value):
		if warp_intensity != value:
			warp_intensity = value
			emit_changed()
			property_changed.emit(&"warp_intensity", self)


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
