extends Control

@onready var days: Label = $DayControl/Days
@onready var hours: Label = $ClockControl/Hours
@onready var minutes: Label = $ClockControl/Minutes
@onready var date: Label = $DayControl/Date

var week_days = [
	"Mon.",
	"Tue.",
	"Wed.",
	"Thu.",
	"Fri.",
	"Sat.",
	"Sun."
]

func _ready() -> void:
	TimeManager.updated.connect(_on_time_system_updated)
	_on_time_system_updated(TimeManager.date_time)

func _on_time_system_updated(date_time: Datetime) -> void:
	update_label(date, date_time.days, false)
	update_day(date_time.days)
	update_label(hours, date_time.hours)
	update_label(minutes, date_time.minutes)
	
func update_day(day_number: int) -> void:
	var day_index = (day_number - 1) % 7
	days.text = week_days[day_index]



func add_zero(label: Label, value: int) -> void:
	if value < 10:
		label.text += '0'
		
func update_label(label: Label, value: int, should_have_zero: bool = true) -> void:
	label.text = ""
	
	if should_have_zero:
		add_zero(label, value)
	label.text += str(value)
