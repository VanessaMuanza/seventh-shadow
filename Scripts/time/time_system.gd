class_name TimeSystem 
extends Node

signal updated

@export_category("Start Time")
@export_range(1, 999) var start_day: int = 1
@export_range(0, 23) var start_hour: int = 0
@export_range(0, 59) var start_minute: int = 0
@export_range(0, 59) var start_second: int = 0

@export var date_time: Datetime = Datetime.new()
@export var ticks_index: int = 6
@export var ticks_pr_second_options: Array[int] = [2, 4, 8, 16, 32, 64, 128, 256, 512, 1024]

var is_paused: bool = false


func _process(delta: float) -> void:
	handle_input()
	
	if is_paused:
		return
	
	date_time.increase_by_sec(delta * ticks_pr_second_options[ticks_index])
	updated.emit(date_time)

func handle_input() -> void:
	if Input.is_action_just_pressed("dec_speed"):
		ticks_index -= 1
	if Input.is_action_just_pressed("inc_speed"):
		ticks_index += 1
	if Input.is_action_just_pressed("pause_time"):
		is_paused = !is_paused

	ticks_index = clamp(ticks_index, 0, ticks_pr_second_options.size() - 1)
