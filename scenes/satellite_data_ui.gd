extends Node3D

#var viewport = $Info_Viewport

@onready var viewport = $Info_Sprite
@onready var viewport_container = $Info_Sprite/Info_Viewport_Container

#func _ready():
#	viewport.visible = false


func _on_close_button_pressed() -> void:
	#viewport.visible = false
	viewport_container.visible = false
