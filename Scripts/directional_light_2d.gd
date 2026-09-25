extends DirectionalLight2D


@export var day_color : Color
@export var night_color: Color
@export var day_start: Datetime
@export var night_start: Datetime
@export var time_transition: int = 30 # transition en minutes
@export var time_system: TimeSystem

var in_transition: bool = false

enum DayState {DAY, NIGHT}
var current_state: DayState

@onready var time_map: Dictionary = {
	DayState.DAY: day_start,
	DayState.NIGHT: night_start,
}

@onready var transition_map: Dictionary = {
	DayState.DAY: DayState.NIGHT,
	DayState.NIGHT: DayState.DAY,
}

@onready var color_map: Dictionary = {
	DayState.DAY: day_color,
	DayState.NIGHT: night_color
}

func _ready() -> void:
	TimeManager.updated.connect(update)

	current_state = get_state(TimeManager.date_time)
	update(TimeManager.date_time)

func get_state(game_time: Datetime) -> DayState:
	var total_minutes = game_time.hours * 60 + game_time.minutes
	var day_minutes = day_start.hours * 60 + day_start.minutes
	var night_minutes = night_start.hours * 60 + night_start.minutes

	if total_minutes >= day_minutes and total_minutes < night_minutes:
		return DayState.DAY
	else:
		return DayState.NIGHT


func update(game_time: Datetime) -> void:
	var actual_state = get_state(game_time)

	# Si on n'est pas en transition et que l'heure a changé de période
	if not in_transition and actual_state != current_state:
		current_state = actual_state

	var next_state = transition_map[current_state]
	var time_change = time_map[next_state]
	var time_diff = time_change.diff_time(game_time)


	if in_transition:
		update_transition(time_diff, next_state)

	elif time_diff > 0 and time_diff < (time_transition * 60):
		in_transition = true
		update_transition(time_diff, next_state)

	else:
		color = color_map[current_state]


func update_transition(time_diff: int, next_state: DayState) -> void:
	var ratio = 1.0 - (time_diff as float / (time_transition * 60.0))
	ratio = clamp(ratio, 0.0, 1.0)

	print("ratio=", ratio)

	if ratio >= 1.0:
		current_state = next_state
		in_transition = false
		color = color_map[current_state]
	else:
		color = color_map[current_state].lerp(color_map[next_state], ratio)
