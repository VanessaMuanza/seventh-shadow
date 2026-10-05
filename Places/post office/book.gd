extends CharacterBody2D

@onready var interactable: Area2D = $Interactable
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	interactable.interact = _on_interact

	if GameState.is_collected("blue_book_taken"):
		queue_free()

func _on_interact():
	if give_book():
		queue_free()

func give_book() -> bool:
	var inventory = load("res://inventory/playerInventory.tres")
	var book = load("res://Places/post office/book.tres") 
	if book:
		inventory.insert(book)
		GameState.mark_collected("blue_book_taken")
		return true
	return false
