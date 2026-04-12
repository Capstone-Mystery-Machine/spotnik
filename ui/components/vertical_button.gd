@tool
class_name VerticalButton
extends MarginContainer

signal pressed()

signal toggled(toggled_on: bool)

@export var icon: Texture2D:
	set(value):
		icon = value
		_update_icon()

@export var text: String = "Button":
	set(value):
		text = value
		_update_text()

@export var button_group: ButtonGroup:
	set(value):
		button_group = value
		_update_button_group()

@export var button_pressed: bool = false:
	set(value):
		if button_pressed == value:
			return

		button_pressed = value
		_update_button_pressed()

@export var button_theme_type_variation: StringName = "":
	set(value):
		button_theme_type_variation = value
		_update_theme_type_variation()

@export var toggle_mode: bool = false:
	set(value):
		toggle_mode = value
		_update_toggle_mode()

@onready var button: Button = %Button

@onready var label: Label = %Label

@onready var texture_rect: TextureRect = %TextureRect


func _update_button_group() -> void:
	if is_node_ready() and button:
		button.button_group = button_group


func _update_button_pressed() -> void:
	if is_node_ready() and button:
		button.set_pressed_no_signal(button_pressed)


func _update_icon() -> void:
	if is_node_ready() and texture_rect:
		texture_rect.texture = icon


func _update_text() -> void:
	if is_node_ready() and label:
		label.text = text


func _update_theme_type_variation() -> void:
	if is_node_ready() and button:
		button.theme_type_variation = button_theme_type_variation


func _update_toggle_mode() -> void:
	if is_node_ready() and button:
		button.toggle_mode = toggle_mode


func _on_button_pressed() -> void:
	pressed.emit()


func _on_button_toggled(toggled_on: bool) -> void:
	button_pressed = toggled_on
	toggled.emit(toggled_on)


func _ready() -> void:
	_update_toggle_mode()
	_update_button_group()
	_update_button_pressed()
	_update_icon()
	_update_text()
	_update_theme_type_variation()

	if button and not button.pressed.is_connected(_on_button_pressed):
		button.pressed.connect(_on_button_pressed)

	if button and not button.toggled.is_connected(_on_button_toggled):
		button.toggled.connect(_on_button_toggled)
