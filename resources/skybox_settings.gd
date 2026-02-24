@tool
class_name SkyboxSettings
extends Resource
## Resource for skybox settings.

@export_group("Materials Settings")

@export_subgroup("Nebulae Settings")

## Represents the texture for the nebulae layers.
@export var nebulae_texture: Texture2D

## Represents the material for the near nebulae layer.
@export var nebulae_near_material: SkyboxLayerMaterial = SkyboxLayerMaterial.new(Color(0, 0, 0, 0.4), Color(0.05, 0.05, 0.01, 1.0), 0.5)

## Represents the material for the mid nebulae layer.
@export var nebulae_mid_material: SkyboxLayerMaterial = SkyboxLayerMaterial.new(Color(0, 0, 0, 0.65), Color(0.15, 0.1, 0.2, 1.0), 0.75)

## Represents the material for the far nebulae layer.
@export var nebulae_far_material: SkyboxLayerMaterial = SkyboxLayerMaterial.new(Color(0, 0, 0, 0.75), Color(0.01, 0.01, 0.25, 1.0), 0.95)

@export_subgroup("Stars Settings")

## Represents the texture for the field stars layers.
@export var stars_field_texture: NoiseTexture2D

## Represents the texture for the point stars layers.
@export var stars_point_texture: NoiseTexture2D

## Represents the material for the near point stars layer.
@export var stars_point_near_material: SkyboxLayerMaterial = SkyboxLayerMaterial.new(
	Color(0, 0, 0, 0.9),
	Color(0, 0, 0, 1.0),
	0.6,
)

## Represents the material for the mid point stars layer.
@export var stars_point_mid_material: SkyboxLayerMaterial = SkyboxLayerMaterial.new(
	Color(0, 0, 0, 0.75),
	Color(0, 0, 0, 1.0),
	0.45,
)

## Represents the material for the far point stars layer.
@export var stars_point_far_material: SkyboxLayerMaterial = SkyboxLayerMaterial.new(
	Color(0, 0, 0, 0.5),
	Color(0, 0, 0, 1.0),
	0.5,
)

## Represents the material for the near field stars layer.
@export var stars_field_near_material: SkyboxLayerMaterial = SkyboxLayerMaterial.new(
	Color(1.0, 1.0, 1.0, 0.6),
	Color(1.0, 1.0, 1.0, 1.0),
	0.55,
)

## Represents the material for the far field stars layer.
@export var stars_field_far_material: SkyboxLayerMaterial = SkyboxLayerMaterial.new(
	Color(1.0, 1.0, 1.0, 0.45),
	Color(1.0, 1.0, 1.0, 1.0),
	0.5,
)

@export_group("Projection Settings")

## Represents the projection distance of the skybox meshes.
@export_range(0.0, 1000.0, 0.00001, "suffix:m") var projection_radius: float = 1.0

## Represents the radius multiplier for the mid and far nebulae layers.
@export_range(1.0, 2.0, 0.00001) var nebulae_displacement_multiplier: float = 1.1

## Represents the radius multiplier for the point stars layers.
@export_range(1.0, 2.0, 0.00001) var stars_point_radius_multiplier: float = 1.0125

## Represents the radius multiplier for subsequent point stars layers.
@export_range(1.0, 2.0, 0.00001) var stars_point_displacement_multiplier: float = 1.25

## Represents the radius multiplier for the field stars layers.
@export_range(1.0, 2.0, 0.00001) var stars_field_radius_multiplier: float = 1.0125

## Represents the radius multiplier for subsequent field stars layers.
@export_range(1.0, 2.0, 0.00001) var stars_field_displacement_multiplier: float = 1.025

## Represents the radius multiplier for the void layer.
@export_range(1.0, 2.0, 0.00001) var void_radius_multiplier: float = 1.0125

@export_group("Simulation Settings")

## Represents the base rotation speed for the void layer.
@export_range(-0.1, 0.1, 0.00001, "suffix:rad/s") var rotation_speed: float = 0.00025

## Represents the rotation speed multiplier for the far field stars.
@export_range(-2.0, 2.0, 0.00001) var stars_field_far_speed_multiplier: float = 1.0

## Represents the rotation speed multiplier for the near field stars.
@export_range(-2.0, 2.0, 0.00001) var stars_field_near_speed_multiplier: float = 1.0

## Represents the rotation speed multiplier for the far point stars.
@export_range(-2.0, 2.0, 0.00001) var stars_point_far_speed_multiplier: float = 1.0

## Represents the rotation speed multiplier for the mid point stars.
@export_range(-2.0, 2.0, 0.00001) var stars_point_mid_speed_multiplier: float = 1.005

## Represents the rotation speed multiplier for the near point stars.
@export_range(-2.0, 2.0, 0.00001) var stars_point_near_speed_multiplier: float = 1.01

## Represents the rotation speed multiplier for the nebulae.
@export_range(-2.0, 2.0, 0.00001) var nebulae_speed_multiplier: float = 0.99

@export_group("Nebulae Effects Settings")

## Represents the opacity removed by the carving noise.
@export_range(0.0, 1.0, 0.01) var nebulae_carving_intensity: float = 0.65

## Represents the 3D noise texture used to carve the nebulae.
@export var nebulae_carving_noise_texture: Texture3D

## Represents the scale of the carving noise.
@export var nebulae_carving_scale: float = 2.5

## Represents the movement speed of the carving noise.
@export var nebulae_carving_speed: float = 0.08

## Represents the strength of the flow map distortion.
@export var nebulae_flow_intensity: float = 0.04

## Represents the movement speed of the flow map distortion.
@export var nebulae_flow_speed: float = 0.02

@export_group("Twinkle Effect Settings")

## Represents the twinkle settings for the near point stars.
@export var stars_point_near_twinkle: TwinkleEffectSettings = TwinkleEffectSettings.new(
	0.3,
	100.0,
	2.0,
)

## Represents the twinkle settings for the mid point stars.
@export var stars_point_mid_twinkle: TwinkleEffectSettings = TwinkleEffectSettings.new(
	0.6,
	1000.0,
	1.5,
)

## Represents the twinkle settings for the far point stars.
@export var stars_point_far_twinkle: TwinkleEffectSettings = TwinkleEffectSettings.new(
	0.9,
	2000.0,
	4.0,
)
