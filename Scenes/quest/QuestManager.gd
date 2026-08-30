extends Node2D

@export_group("Quest Setting")
@export var quest_name: String #nom de la quête
@export var quest_description: String
@export var reached_goal_text : String #texte donner au joueur a la fin 

signal quest_updated(quest_id: String)
signal objective_updated(quest_id: String,objective_id: String)
signal quest_list_updated()
var quests = {} # dictionnaire qui conntient mes quêtes

#add quest
func add_quest(quest: Quest):
	if quests.has(quest.quest_id):
		return
	
	quests[quest.quest_id] = quest
	quest.state = "in_progress"
	
	quest_updated.emit(quest.quest_id)
	quest_list_updated.emit()

func start_quest(quest_id: String):
	var quest = load("res://Scripts/quest/rita_crystal.tres")

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
