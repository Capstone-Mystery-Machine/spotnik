extends Node

func _ready() -> void:
	var task_nodes = get_children() as Array[TaskNode]

	for task_node in task_nodes:
		# HACK: Some tasks may be async and some tasks might not be. So, we can
		# just ignore this warning. Sadly, we cannot explicitly type `TaskNode._task`
		# as such a function.
		#
		# Also, the `TaskNode_task` function should be considered an internal event
		# function in the vein of `Node._ready` and such.
		@warning_ignore("redundant_await")
		# gdlint-ignore-next-line private-access
		await task_node._task()
