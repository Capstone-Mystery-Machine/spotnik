class_name OSX
extends Node
## A singleton for handling Spotnik-specific OS / platform integration.

## Represents an enumeration of Spotnik-specific semantic process exit codes. External
## monitoring software may use these codes to determine their response to Spotnik
## shutting down.
enum ExitCode {
	## Spotnik exits telling any monitoring software that nothing went wrong.
	SUCCESS,

	## Spotnik exits telling any monitoring software that the end-user denied a
	## required permission grant prompt on boot.
	PERMISSION_NOT_GRANTED,

	## Spotnik exits telling any monitoring software that the configured geo-location
	## plugin was unable to be loaded.
	GEO_LOCATION_PLUGIN_MISSING,

	## Spotnik exits telling any monitoring software that the configured geo-location
	## plugin is not supported.
	GEO_LOCATION_PLUGIN_UNSUPPORTED,

	## Spotnik exits telling any monitoring software that the configured scene
	## resource was tried to be loaded, but there failure trying to read its data.
	TRANSITION_LOAD_RESOURCE_FAILED,

	## Spotnik exits telling any monitoring software that the configured scene
	## resource was tried to be loaded, but it was formatted wrongly or corrupted.
	TRANSITION_LOAD_RESOURCE_MALFORMED,
}


## Returns if the export target requires permissions to be requested on boot.
static func permission_request_required() -> bool:
	return OS.has_feature("permission_request_required")
