class_name TaskManager
extends Node

func run_all_tasks() -> void:
	var task_nodes = get_children() as Array[TaskNode]

	print("'TaskManager.run_all_tasks': running available tasks")

	for task_node in task_nodes:
		print("'TaskManager.run_all_tasks': found task '%s', running" % task_node.name)

		# HACK: Some tasks may be async and some tasks might not be. So, we can
		# just ignore this warning. Sadly, we cannot explicitly type `TaskNode._task`
		# as such a function.
		#
		# Also, the `TaskNode_task` function should be considered an internal event
		# function in the vein of `Node._ready` and such.
		@warning_ignore("redundant_await")
		# gdlint-ignore-next-line private-access
		await task_node._task()
		task_node.queue_free()

		print("'TaskManager.run_all_tasks': task '%s' ran successfully" % task_node.name)

	print("'TaskManager.run_all_tasks': all available tasks complete")


func _ready() -> void:
	run_all_tasks()
