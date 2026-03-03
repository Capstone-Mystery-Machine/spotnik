extends Node3D

@onready var viewport_container = %Info_Viewport_Container
@onready var International_Designator = %International_Designator2
@onready var Norad_Catalog_Identifier = %Norad_Catalog_Identifier2
@onready var Name = %Name2
@onready var Origin_Country = %Origin_Country2
@onready var Launch_Date = %Launch_Date2
@onready var Latitude = %Latitude2
@onready var Longitude = %Longitude2
@onready var Cartesian_x = %Cartesian_x2
@onready var Cartesian_y = %Cartesian_y2
@onready var Cartesian_z = %Cartesian_z2


func _ready():
	viewport_container.visible = false
	SignalBus.ui_info.connect(_ui_info_signal)


func _ui_info_signal(internationalDesignator, noradCatalogIdentifier, satellite_name, countryOfOrigin, launchDate, latitude, longitude):
	International_Designator.text = internationalDesignator
	Norad_Catalog_Identifier.text = noradCatalogIdentifier
	Name.text = satellite_name
	Origin_Country.text = countryOfOrigin
	Launch_Date.text = str(launchDate)
	Latitude.text = str(latitude)
	Longitude.text = str(longitude)
	Cartesian_x.text = "N/A"
	Cartesian_y.text = 'N/A'
	Cartesian_z.text = 'N/A'


func _on_close_button_pressed() -> void:
	#viewport.visible = false
	viewport_container.visible = false


func _on_landmark_ui_open() -> void:
	viewport_container.visible = true
