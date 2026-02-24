@tool
class_name SkyboxLayerMaterial
extends Resource
## Resource for skybox layer material settings.

## Represents the albedo color and transparency of the skybox layer.
@export var albedo_color: Color:
	set(value):
		if albedo_color != value:
			albedo_color = value
			emit_changed()

## Represents the glowing emission color of the skybox layer.
@export var emission_color: Color:
	set(value):
		if emission_color != value:
			emission_color = value
			emit_changed()

## Represents the brightness multiplier for the emission color of the skybox layer.
@export var emission_energy: float:
	set(value):
		if emission_energy != value:
			emission_energy = value
			emit_changed()


func _init(
		_albedo_color: Color = Color(0.0, 0.0, 0.0, 1.0),
		_emission_color: Color = Color(0.0, 0.0, 0.0, 1.0),
		_emission_energy: float = 1.0,
):
	albedo_color = _albedo_color
	emission_color = _emission_color
	emission_energy = _emission_energy
