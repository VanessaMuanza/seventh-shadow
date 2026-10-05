extends StaticBody2D

@onready var interactable: Area2D = $Interactable
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	interactable.interact = _on_interact

	if GameState.is_collected("card_taken"):
		queue_free()

func _on_interact():
	if give_card():
		queue_free()

func give_card() -> bool:
	var inventory = load("res://inventory/playerInventory.tres")
	var card = load("res://Places/post office/card.tres") 
	if card:
		inventory.insert(card)
		GameState.mark_collected("card_taken")

		QuestManager.complete_objective("find_card", "find_card")
		QuestManager.update_quest("find_card", "completed")
		QuestManager.start_quest("open_safe")
		return true
	return false
