class_name OSX
extends Node

enum ExitCode {
	SUCCESS,
	PERMISSION_NOT_GRANTED,
}


static func permission_request_required() -> bool:
	return OS.has_feature("permission_request_required")
