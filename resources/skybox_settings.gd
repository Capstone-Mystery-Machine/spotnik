@tool
class_name SkyboxSettings
extends Resource
## Resource for skybox settings.

signal property_changed(property_name: StringName)

@export_group("Projection Settings")

## Represents the projection distance of the skybox meshes.
@export_range(0.0, 1000.0, 0.00001, "suffix:m") var projection_radius: float = 1.0:
	set(value):
		if projection_radius != value:
			projection_radius = value
			emit_changed()
			property_changed.emit(&"projection_radius")

## Represents the radius multiplier for the mid and far nebulae layers.
@export_range(1.0, 2.0, 0.00001) var nebulae_displacement_multiplier: float = 1.1:
	set(value):
		if nebulae_displacement_multiplier != value:
			nebulae_displacement_multiplier = value
			emit_changed()
			property_changed.emit(&"nebulae_displacement_multiplier")

## Represents the radius multiplier for the point stars layers.
@export_range(1.0, 2.0, 0.00001) var stars_point_radius_multiplier: float = 1.0125:
	set(value):
		if stars_point_radius_multiplier != value:
			stars_point_radius_multiplier = value
			emit_changed()
			property_changed.emit(&"stars_point_radius_multiplier")

## Represents the radius multiplier for subsequent point stars layers.
@export_range(1.0, 2.0, 0.00001) var stars_point_displacement_multiplier: float = 1.25:
	set(value):
		if stars_point_displacement_multiplier != value:
			stars_point_displacement_multiplier = value
			emit_changed()
			property_changed.emit(&"stars_point_displacement_multiplier")

## Represents the radius multiplier for the field stars layers.
@export_range(1.0, 2.0, 0.00001) var stars_field_radius_multiplier: float = 1.0125:
	set(value):
		if stars_field_radius_multiplier != value:
			stars_field_radius_multiplier = value
			emit_changed()
			property_changed.emit(&"stars_field_radius_multiplier")

## Represents the radius multiplier for subsequent field stars layers.
@export_range(1.0, 2.0, 0.00001) var stars_field_displacement_multiplier: float = 1.025:
	set(value):
		if stars_field_displacement_multiplier != value:
			stars_field_displacement_multiplier = value
			emit_changed()
			property_changed.emit(&"stars_field_displacement_multiplier")

## Represents the radius multiplier for the void layer.
@export_range(1.0, 2.0, 0.00001) var void_radius_multiplier: float = 1.0125:
	set(value):
		if void_radius_multiplier != value:
			void_radius_multiplier = value
			emit_changed()
			property_changed.emit(&"void_radius_multiplier")

@export_group("Simulation Settings")

## Represents the base rotation speed for the void layer.
@export_range(-0.1, 0.1, 0.00001, "suffix:rad/s") var rotation_speed: float = 0.00025:
	set(value):
		if rotation_speed != value:
			rotation_speed = value
			emit_changed()
			property_changed.emit(&"rotation_speed")

## Represents the rotation speed multiplier for the far field stars.
@export_range(-2.0, 2.0, 0.00001) var stars_field_far_speed_multiplier: float = 1.0125:
	set(value):
		if stars_field_far_speed_multiplier != value:
			stars_field_far_speed_multiplier = value
			emit_changed()
			property_changed.emit(&"stars_field_far_speed_multiplier")

## Represents the rotation speed multiplier for the near field stars.
@export_range(-2.0, 2.0, 0.00001) var stars_field_near_speed_multiplier: float = 1.025:
	set(value):
		if stars_field_near_speed_multiplier != value:
			stars_field_near_speed_multiplier = value
			emit_changed()
			property_changed.emit(&"stars_field_near_speed_multiplier")

## Represents the rotation speed multiplier for the far point stars.
@export_range(-2.0, 2.0, 0.00001) var stars_point_far_speed_multiplier: float = 1.0:
	set(value):
		if stars_point_far_speed_multiplier != value:
			stars_point_far_speed_multiplier = value
			emit_changed()
			property_changed.emit(&"stars_point_far_speed_multiplier")

## Represents the rotation speed multiplier for the mid point stars.
@export_range(-2.0, 2.0, 0.00001) var stars_point_mid_speed_multiplier: float = 1.005:
	set(value):
		if stars_point_mid_speed_multiplier != value:
			stars_point_mid_speed_multiplier = value
			emit_changed()
			property_changed.emit(&"stars_point_mid_speed_multiplier")

## Represents the rotation speed multiplier for the near point stars.
@export_range(-2.0, 2.0, 0.00001) var stars_point_near_speed_multiplier: float = 1.01:
	set(value):
		if stars_point_near_speed_multiplier != value:
			stars_point_near_speed_multiplier = value
			emit_changed()
			property_changed.emit(&"stars_point_near_speed_multiplier")

## Represents the rotation speed multiplier for the nebulae.
@export_range(-2.0, 2.0, 0.00001) var nebulae_speed_multiplier: float = 0.99:
	set(value):
		if nebulae_speed_multiplier != value:
			nebulae_speed_multiplier = value
			emit_changed()
			property_changed.emit(&"nebulae_speed_multiplier")

@export_group("Materials Settings")

@export_subgroup("Nebulae Settings")

## Represents the texture for the nebulae layers.
@export var nebulae_texture: Texture2D:
	set(value):
		if nebulae_texture != value:
			nebulae_texture = value
			emit_changed()
			property_changed.emit(&"nebulae_texture")

## Represents the material for the near nebulae layer.
@export var nebulae_near_material: SkyboxLayerMaterial = SkyboxLayerMaterial.new(
	Color(1.0, 1.0, 1.0, 0.25),
	Color(0.05, 0.05, 0.01, 1.0),
	0.4,
):
	set(value):
		if nebulae_near_material != value:
			nebulae_near_material = value
			emit_changed()
			property_changed.emit(&"nebulae_near_material")

## Represents the material for the mid nebulae layer.
@export var nebulae_mid_material: SkyboxLayerMaterial = SkyboxLayerMaterial.new(
	Color(1.0, 1.0, 1.0, 0.65),
	Color(0.0, 0.0, 0.0, 1.0),
	0.6,
):
	set(value):
		if nebulae_mid_material != value:
			nebulae_mid_material = value
			emit_changed()
			property_changed.emit(&"nebulae_mid_material")

## Represents the material for the far nebulae layer.
@export var nebulae_far_material: SkyboxLayerMaterial = SkyboxLayerMaterial.new(
	Color(1.0, 1.0, 1.0, 0.75),
	Color(0.0, 0.0, 0.0, 1.0),
	0.8,
):
	set(value):
		if nebulae_far_material != value:
			nebulae_far_material = value
			emit_changed()
			property_changed.emit(&"nebulae_far_material")

@export_subgroup("Stars Settings")

## Represents the texture for the field stars layers.
@export var stars_field_texture: NoiseTexture2D:
	set(value):
		if stars_field_texture != value:
			stars_field_texture = value
			emit_changed()
			property_changed.emit(&"stars_field_texture")

## Represents the texture for the point stars layers.
@export var stars_point_texture: NoiseTexture2D:
	set(value):
		if stars_point_texture != value:
			stars_point_texture = value
			emit_changed()
			property_changed.emit(&"stars_point_texture")

## Represents the material for the near point stars layer.
@export var stars_point_near_material: SkyboxLayerMaterial = SkyboxLayerMaterial.new(
	Color(0, 0, 0, 0.9),
	Color(0, 0, 0, 1.0),
	0.7,
):
	set(value):
		if stars_point_near_material != value:
			stars_point_near_material = value
			emit_changed()
			property_changed.emit(&"stars_point_near_material")

## Represents the material for the mid point stars layer.
@export var stars_point_mid_material: SkyboxLayerMaterial = SkyboxLayerMaterial.new(
	Color(0, 0, 0, 0.75),
	Color(0, 0, 0, 1.0),
	0.55,
):
	set(value):
		if stars_point_mid_material != value:
			stars_point_mid_material = value
			emit_changed()
			property_changed.emit(&"stars_point_mid_material")

## Represents the material for the far point stars layer.
@export var stars_point_far_material: SkyboxLayerMaterial = SkyboxLayerMaterial.new(
	Color(0, 0, 0, 0.5),
	Color(0, 0, 0, 1.0),
	0.45,
):
	set(value):
		if stars_point_far_material != value:
			stars_point_far_material = value
			emit_changed()
			property_changed.emit(&"stars_point_far_material")

## Represents the material for the near field stars layer.
@export var stars_field_near_material: SkyboxLayerMaterial = SkyboxLayerMaterial.new(
	Color(1.0, 1.0, 1.0, 0.6),
	Color(1.0, 1.0, 1.0, 1.0),
	0.5,
):
	set(value):
		if stars_field_near_material != value:
			stars_field_near_material = value
			emit_changed()
			property_changed.emit(&"stars_field_near_material")

## Represents the material for the far field stars layer.
@export var stars_field_far_material: SkyboxLayerMaterial = SkyboxLayerMaterial.new(
	Color(1.0, 1.0, 1.0, 0.45),
	Color(1.0, 1.0, 1.0, 1.0),
	0.5,
):
	set(value):
		if stars_field_far_material != value:
			stars_field_far_material = value
			emit_changed()
			property_changed.emit(&"stars_field_far_material")

@export_group("Color Palette Effects Settings")

# Represents the 1D gradient used as a color palette for point stars.
@export var stars_point_color_palette: GradientTexture1D:
	set(value):
		if stars_point_color_palette != value:
			stars_point_color_palette = value
			emit_changed()
			property_changed.emit(&"stars_point_color_palette")

@export_group("Dissolve Effects Settings")

## Represents the noise texture used to dissolve the nebulae.
@export var nebulae_dissolve_noise_texture: NoiseTexture2D:
	set(value):
		if nebulae_dissolve_noise_texture != value:
			nebulae_dissolve_noise_texture = value
			emit_changed()
			property_changed.emit(&"nebulae_dissolve_noise_texture")

## Represents the flow map distortion settings for the near nebulae.
@export var nebulae_near_dissolve: DissolveEffectSettings = DissolveEffectSettings.new(
	1.0,
	2.0,
	Vector2(-0.003, -0.004),
	0.15,
):
	set(value):
		if nebulae_near_dissolve != value:
			nebulae_near_dissolve = value
			emit_changed()
			property_changed.emit(&"nebulae_near_dissolve")

## Represents the flow map distortion settings for the mid nebulae.
@export var nebulae_mid_dissolve: DissolveEffectSettings = DissolveEffectSettings.new(
	0.8,
	1.5,
	Vector2(-0.002, 0.002),
	0.1,
):
	set(value):
		if nebulae_mid_dissolve != value:
			nebulae_mid_dissolve = value
			emit_changed()
			property_changed.emit(&"nebulae_mid_dissolve")

## Represents the flow map distortion settings for the far nebulae.
@export var nebulae_far_dissolve: DissolveEffectSettings = DissolveEffectSettings.new(
	0.5,
	1.0,
	Vector2(0.001, -0.001),
	0.05,
):
	set(value):
		if nebulae_far_dissolve != value:
			nebulae_far_dissolve = value
			emit_changed()
			property_changed.emit(&"nebulae_far_dissolve")

@export_group("Flow Map Distortion Effects Settings")

## Represents the flow map distortion settings for the near nebulae.
@export var nebulae_near_flow_map_distortion: FlowMapDistortionEffectSettings = FlowMapDistortionEffectSettings.new(
	0.06,
	0.03,
):
	set(value):
		if nebulae_near_flow_map_distortion != value:
			nebulae_near_flow_map_distortion = value
			emit_changed()
			property_changed.emit(&"nebulae_near_flow_map_distortion")

## Represents the flow map distortion settings for the mid nebulae.
@export var nebulae_mid_flow_map_distortion: FlowMapDistortionEffectSettings = FlowMapDistortionEffectSettings.new(
	0.04,
	0.02,
):
	set(value):
		if nebulae_mid_flow_map_distortion != value:
			nebulae_mid_flow_map_distortion = value
			emit_changed()
			property_changed.emit(&"nebulae_mid_flow_map_distortion")

## Represents the flow map distortion settings for the far nebulae.
@export var nebulae_far_flow_map_distortion: FlowMapDistortionEffectSettings = FlowMapDistortionEffectSettings.new(
	0.02,
	0.01,
):
	set(value):
		if nebulae_far_flow_map_distortion != value:
			nebulae_far_flow_map_distortion = value
			emit_changed()
			property_changed.emit(&"nebulae_far_flow_map_distortion")

@export_group("Twinkle Effect Settings")

## Represents the twinkle settings for the near point stars.
@export var stars_point_near_twinkle: TwinkleEffectSettings = TwinkleEffectSettings.new(
	0.3,
	100.0,
	2.0,
):
	set(value):
		if stars_point_near_twinkle != value:
			stars_point_near_twinkle = value
			emit_changed()
			property_changed.emit(&"stars_point_near_twinkle")

## Represents the twinkle settings for the mid point stars.
@export var stars_point_mid_twinkle: TwinkleEffectSettings = TwinkleEffectSettings.new(
	0.6,
	1000.0,
	1.5,
):
	set(value):
		if stars_point_mid_twinkle != value:
			stars_point_mid_twinkle = value
			emit_changed()
			property_changed.emit(&"stars_point_mid_twinkle")

## Represents the twinkle settings for the far point stars.
@export var stars_point_far_twinkle: TwinkleEffectSettings = TwinkleEffectSettings.new(
	0.9,
	2000.0,
	4.0,
):
	set(value):
		if stars_point_far_twinkle != value:
			stars_point_far_twinkle = value
			emit_changed()
			property_changed.emit(&"stars_point_far_twinkle")
