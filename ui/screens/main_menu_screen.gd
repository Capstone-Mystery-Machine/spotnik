class_name MainMenuScreen
extends Control

signal start_button_pressed()

@onready var start_button: Button = %StartButton


func _on_start_button_pressed():
	start_button_pressed.emit()


func _ready():
	start_button.pressed.connect(_on_start_button_pressed)
