extends Node3D

@onready var viewport = $Info_Sprite
@onready var viewport_container = $Info_Sprite/Info_Viewport_Container
@onready var international_designator = \
$Info_Sprite/Info_Viewport_Container/Info_Viewport\
/PanelContainer/Satel_Info/International_Designator2
@onready var norad_catalog_identifier = \
$Info_Sprite/Info_Viewport_Container/Info_Viewport\
/PanelContainer/Satel_Info/Norad_Catalog_Identifier2
@onready var satellite_name = \
$Info_Sprite/Info_Viewport_Container/Info_Viewport/PanelContainer/Satel_Info/Name2
@onready var origin_country = \
$Info_Sprite/Info_Viewport_Container/Info_Viewport/PanelContainer/Satel_Info/Origin_Country2
@onready var launch_date = \
$Info_Sprite/Info_Viewport_Container/Info_Viewport/PanelContainer/Satel_Info/Launch_Date2
@onready var latitude = \
$Info_Sprite/Info_Viewport_Container/Info_Viewport/PanelContainer/Satel_Info/Latitude2
@onready var longitude = \
$Info_Sprite/Info_Viewport_Container/Info_Viewport/PanelContainer/Satel_Info/Longitude2
@onready var cartesian_x = \
$Info_Sprite/Info_Viewport_Container/Info_Viewport/PanelContainer/Satel_Info/Cartesian_x2
@onready var cartesian_y = \
$Info_Sprite/Info_Viewport_Container/Info_Viewport/PanelContainer/Satel_Info/Cartesian_y2
@onready var cartesian_z = \
$Info_Sprite/Info_Viewport_Container/Info_Viewport/PanelContainer/Satel_Info/Cartesian_z2


func _ready():
	viewport_container.visible = false
	SignalBus.instance.ui_info.connect(_ui_info_signal)


func _ui_info_signal(landmark):
	viewport_container.visible = true

	international_designator.text = landmark.international_designator
	norad_catalog_identifier.text = landmark.norad_catalog_id
	satellite_name.text = landmark.satellite_name
	origin_country.text = landmark.country
	launch_date.text = str(landmark.launch_date)
	latitude.text = str(landmark.latitude)
	longitude.text = str(landmark.longitude)
	cartesian_x.text = "N/A"
	cartesian_y.text = "N/A"
	cartesian_z.text = "N/A"


func _on_close_button_pressed() -> void:
	viewport_container.visible = false


func _on_landmark_ui_open() -> void:
	viewport_container.visible = true
