## Resource for skybox layer material settings.
class_name SkyboxLayerMaterial
extends Resource

## Represents the albedo color and transparency of the skybox layer.
@export var albedo_color: Color

## Represents the glowing emission color of the skybox layer.
@export var emission_color: Color

## Represents the brightness multiplier for the emission color of the skybox layer.
@export var emission_energy: float


func _init(
		_albedo_color: Color = Color(0.0, 0.0, 0.0, 1.0),
		_emission_color: Color = Color(0.0, 0.0, 0.0, 1.0),
		_emission_energy: float = 1.0,
):
	albedo_color = _albedo_color
	emission_color = _emission_color
	emission_energy = _emission_energy
