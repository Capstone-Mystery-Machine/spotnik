class_name LoadingUILayer
extends CanvasLayer

@export var fov_base: float = 100.0

@export var fov_bounce: float = 90.0

@export var glow_base_scale: float = 0.5

@export var glow_main_menu_scale: float = 1.0

@onready var background_color_rect: ColorRect = %BackgroundColorRect
@onready var glow_texture_rect: TextureRect = %GlowTextureRect
@onready var planet_animation_scene: PlanetAnimationScene = %PlanetAnimationScene

var _transition_progress: float = 0.0

var _transition_type: RootScene.TransitionType \
		= RootScene.TransitionType.DEFAULT

var transition_progress: float = 0.0:
	get:
		return _transition_progress
	set(value):
		_transition_progress = value

		if is_node_ready():
			_update_visuals()

var transition_type: RootScene.TransitionType:
	get:
		return _transition_type
	set(value):
		_transition_type = value

		if is_node_ready():
			_update_visuals()


func _update_visuals() -> void:
	background_color_rect.modulate.a = transition_progress

	match transition_type:
		RootScene.TransitionType.TO_MAIN_MENU:
			var inverted_progress = 1.0 - transition_progress

			var bounce_progress = sin(transition_progress * PI)
			var delayed_glow_progress = clamp((inverted_progress - 0.5) * 2.0, 0.0, 1.0)

			var current_fov = lerp(fov_base, fov_bounce, bounce_progress)
			var current_scale = lerp(
				glow_base_scale,
				glow_main_menu_scale,
				delayed_glow_progress,
			)

			planet_animation_scene.fov = current_fov
			glow_texture_rect.scale = Vector2(current_scale, current_scale)
		RootScene.TransitionType.FROM_MAIN_MENU:
			var bounce_progress = sin(transition_progress * PI)
			var fast_glow_progress = clamp(transition_progress * 2.0, 0.0, 1.0)

			var current_fov = lerp(fov_base, fov_bounce, bounce_progress)
			var current_scale = lerp(
				glow_main_menu_scale,
				glow_base_scale,
				fast_glow_progress,
			)

			planet_animation_scene.fov = current_fov
			glow_texture_rect.scale = Vector2(current_scale, current_scale)
		_:
			planet_animation_scene.fov = fov_base
			glow_texture_rect.scale = Vector2(glow_base_scale, glow_base_scale)


func _ready() -> void:
	_update_visuals()
