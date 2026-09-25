extends Node2D

@export_group("Quest Setting")
@export var quest_name: String #nom de la quête
@export var quest_description: String
@export var reached_goal_text : String #texte donner au joueur a la fin 
var trust_level: int = 0
signal trust_updated(trust_level: int)

signal quest_updated(quest_id: String)
signal objective_updated(quest_id: String,objective_id: String)
signal quest_list_updated()
var quests = {} # dictionnaire qui conntient mes quêtes

signal quest_added(quest: Quest)

#add quest
func add_quest(quest: Quest):
	if quests.has(quest.quest_id):
		return
	
	quests[quest.quest_id] = quest
	quest.state = "in_progress"
	
	quest_updated.emit(quest.quest_id)
	quest_list_updated.emit()
	quest_added.emit(quest)

const QUEST_PATHS := {
	"rita_crystal": "res://Scripts/quest/rita_crystal.tres",
	"rita_meeting": "res://Scripts/quest/rita_meeting.tres",
	"meet_scientist": "res://Scripts/quest/meet_scientist.tres"
}

func _ready() -> void:
	TimeManager.updated.connect(_on_time_updated)

func _on_time_updated(date_time: Datetime):
	var crystal_quest = get_quest("rita_crystal")
	
	if date_time.hours >= 19 and crystal_quest and crystal_quest.state == "completed" and not GameState.is_collected("rita_meeting_reminder"):
		start_quest("rita_meeting")
		GameState.mark_collected("rita_meeting_reminder")


func start_quest(quest_id: String):
	if not QUEST_PATHS.has(quest_id):
		print("quest not found", quest_id)
	
	var quest = load(QUEST_PATHS[quest_id])

	if quest:
		add_quest(quest)
		print("quest added", quest.quest_name)
	else:
		print("quest not found", quest_id)

#remove quest
func remove_quest(quest_id: String):
	quests.erase(quest_id)


#get quest
func get_quest(quest_id: String)-> Quest:
	return quests.get(quest_id, null)
	
#update quest
func update_quest(quest_id: String, state: String):
	var quest = get_quest(quest_id)
	if quest:
		quest.state = state
		quest_updated.emit(quest_id)
		quest_list_updated.emit()

#get quest in progress/selected
func get_selected_quests() -> Array:
	var selected_quests = []
	for quest in quests.values():
		if quest.state == "in_progress":
			selected_quests.append(quest)
	return selected_quests

#complete objective
func complete_objective(quest_id: String, objective_id: String):
	var quest = get_quest(quest_id)
	if quest:
		quest.complete_objective(objective_id)
		objective_updated.emit(quest_id, objective_id)
		quest_list_updated.emit()


#show quest log
func show_hide_log():
	var quest_ui = get_tree().current_scene.get_node("QuestUi")
	quest_ui.show_hide_log()
	
func is_quest_completed(quest_id: String) -> bool:
	var quest = get_quest(quest_id)
	
	if quest:
		return quest.state == "completed"
	return false 

func give_crystal() -> bool:
	var inventory = load("res://inventory/playerInventory.tres")
	for i in range(inventory.slots.size()):
		var slot: InventorySlot = inventory.slots[i]
		if slot.item and slot.item.name == "crystal":
			inventory.removeItemAtIndex(i)
			inventory.updated.emit()

			QuestManager.complete_objective("rita_crystal", "crystal")
			QuestManager.add_trust()
			Dialogic.start("Rita_QuestFinished")
			return true 
	return false

	print("The player doesn't have the crystal")
	

func receive_crystal()-> bool:
	var inventory = load("res://inventory/playerInventory.tres")
	var crystal = load("res://Scenes/quest/Diamant.tres")
	if crystal:
		inventory.insert(crystal)
		GameState.mark_collected("wizard_crystal_given")
		return true

	return false


#trust level augumente
func add_trust(amount: int = 2) -> void:
	trust_level += amount
	print("TRUST LEVEL AUGMENTÉ:", trust_level)
	trust_updated.emit(trust_level)
