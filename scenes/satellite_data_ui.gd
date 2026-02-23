extends Node3D

#var viewport = $Info_Viewport

@onready var viewport = $Info_Sprite
@onready var viewport_container = $Info_Sprite/Info_Viewport_Container
@onready var International_Designator = $Info_Sprite/Info_Viewport_Container/Info_Viewport/PanelContainer/Satel_Info/International_Designator2
@onready var Norad_Catalog_Identifier = $Info_Sprite/Info_Viewport_Container/Info_Viewport/PanelContainer/Satel_Info/Norad_Catalog_Identifier2
@onready var Name = $Info_Sprite/Info_Viewport_Container/Info_Viewport/PanelContainer/Satel_Info/Name2
@onready var Origin_Country = $Info_Sprite/Info_Viewport_Container/Info_Viewport/PanelContainer/Satel_Info/Origin_Country2
@onready var Launch_Date = $Info_Sprite/Info_Viewport_Container/Info_Viewport/PanelContainer/Satel_Info/Launch_Date2
@onready var Latitude = $Info_Sprite/Info_Viewport_Container/Info_Viewport/PanelContainer/Satel_Info/Latitude2
@onready var Longitude = $Info_Sprite/Info_Viewport_Container/Info_Viewport/PanelContainer/Satel_Info/Longitude2
@onready var Cartesian_x = $Info_Sprite/Info_Viewport_Container/Info_Viewport/PanelContainer/Satel_Info/Cartesian_x2
@onready var Cartesian_y = $Info_Sprite/Info_Viewport_Container/Info_Viewport/PanelContainer/Satel_Info/Cartesian_y2
@onready var Cartesian_z = $Info_Sprite/Info_Viewport_Container/Info_Viewport/PanelContainer/Satel_Info/Cartesian_z2


func _ready():
	viewport_container.visible = false
	SignalBus.ui_info.connect(_ui_info_signal)


func _ui_info_signal(landmark):
	viewport_container.visible = true

	International_Designator.text = landmark.international_designator
	Norad_Catalog_Identifier.text = landmark.norad_catalog_id
	Name.text = landmark.satellite_name
	Origin_Country.text = landmark.country
	Launch_Date.text = str(landmark.launch_date)
	Latitude.text = str(landmark.latitude)
	Longitude.text = str(landmark.longitude)
	Cartesian_x.text = "N/A"
	Cartesian_y.text = 'N/A'
	Cartesian_z.text = 'N/A'


func _on_close_button_pressed() -> void:
	#viewport.visible = false
	viewport_container.visible = false


func _on_landmark_ui_open() -> void:
	viewport_container.visible = true
