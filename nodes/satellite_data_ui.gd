class_name SatelUI
extends Node3D

@onready var info_ui = %Info_UI
@onready var international_designator = %International_Designator2
@onready var norad_catalog_identifier = %Norad_Catalog_Identifier2
@onready var satellite_name = %Name2
@onready var origin_country = %Origin_Country2
@onready var launch_date = %Launch_Date2
@onready var panel_container: PanelContainer = %PanelContainer

# var to determine dist of UI in proportion to satel dist
@onready var info_ui_dist = 0.025

var content_alpha: float = 1.0:
	set(value):
		content_alpha = value

		if not is_node_ready():
			return

		panel_container.modulate.a = value


func setup_satel_ui(landmark: Landmark) -> void:
	international_designator.text = landmark.international_designator
	norad_catalog_identifier.text = landmark.norad_catalog_id
	satellite_name.text = landmark.satellite_name
	origin_country.text = landmark.country
	launch_date.text = landmark.launch_date

	#set spawn position
	info_ui.position = landmark.position * info_ui_dist
