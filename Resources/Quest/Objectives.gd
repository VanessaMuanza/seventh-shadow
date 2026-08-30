extends Resource

class_name Objectives


@export var id: String
@export var description: String
@export var target_id: String
@export var target_type: String
#talk to objectives
@export var objective_dialog: String = ""
#collection objectives
@export var required_quantity: int = 0
@export var collected_quantity: int = 0
#objective state
@export var is_completed: bool = false
