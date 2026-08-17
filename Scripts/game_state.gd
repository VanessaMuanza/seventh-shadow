extends Node

var collected_items: Array[String] = []

func is_collected(id: String) -> bool:
	return collected_items.has(id)

func mark_collected(id: String) -> void:
	if not collected_items.has(id):
		collected_items.append(id)

var next_spawn_point: String = ""
