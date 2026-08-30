extends Resource

class_name Quest

@export var quest_id: String
@export var quest_name: String
@export var state: String = "not_started"
@export var unlock_id: String
@export var objectives: Array[Objectives] = []
@export var rewards: Array[Rewards] = []
@export var quest_description: String

#pas utile, efface stp
func ready():
	NinePatchRect. visible = false
#show hide quest log
func show_hide_log():
	NinePatchRect.visible = !NinePatchRect.visible

#check objective state
func is_completed() -> bool:
	for objective in objectives:
		if not objective.is_completed:
			return false
	return true
	
#update quest state
func complete_objective(objective_id: String, quantity: int = 1):
	for objective in objectives:
		if objective_id == objective_id:
			
			#collection objective
			if objective.target_type == "collection":
				objective.collected_quantity += quantity
				
				if objective.collected_quantity >= objective.required_quantity:
					objective.is_completed = true
					
				#talk to objective
			elif objective.target_type == "talk-to":
				objective.is_completed = true
			break
			
#if all the objectives are completed, mark the quest as complete
	if is_completed():
		state = "completed"
