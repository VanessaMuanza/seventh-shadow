class_name TimeSystem 
extends Node

@export var date_time: Datetime
@export var ticks_per_second: int = 6

func _process(delta: float) -> void:
	date_time.increase_by_sec(delta * ticks_per_second)
