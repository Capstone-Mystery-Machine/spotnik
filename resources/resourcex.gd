@tool
class_name ResourceX
extends Resource
## Resource with extended functionality.

signal property_changed(
		resource: ResourceX,
		property_name: StringName,
		new_value: Variant,
		old_value: Variant,
)


## Returns `true` if the value passed in is different from the current value
## of the property. A `property_changed` event is emitted if `true` is returned.
func was_changed_event_emitted(property_name: StringName, new_value: Variant) -> bool:
	var old_value = get(property_name)

	if old_value == new_value:
		return false

	emit_changed()
	property_changed.emit(self, property_name, new_value, old_value)

	return true
