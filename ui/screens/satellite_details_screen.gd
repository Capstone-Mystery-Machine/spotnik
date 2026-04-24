class_name SatelliteDetailsScreen
extends MarginContainer

@onready var international_designator_label = %InternationalDesignatorLabel
@onready var launch_date_label = %LaunchDateLabel
@onready var norad_catalog_identifier_label = %NoradCatalogIdentifierLabel
@onready var origin_country_label = %OriginCountryLabel
@onready var satellite_name_label = %SatelliteNameLabel


func update_satellite_details(landmark: Landmark) -> void:
	international_designator_label.text = landmark.international_designator
	norad_catalog_identifier_label.text = landmark.norad_catalog_id
	satellite_name_label.text = landmark.satellite_name
	origin_country_label.text = landmark.country
	launch_date_label.text = landmark.launch_date

