extends StaticBody2D

@onready var interactable: Area2D = $Interactable
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	interactable.interact = _on_interact
	
func _on_interact():
	if sprite_2d.frame == 0:
		sprite_2d.frame = 1
		animation_player.play("TombOpening")
		interactable.is_interactable = false
		await animation_player.animation_finished
		give_key()

func give_key() -> void:
	var inventory = load("res://inventory/playerInventory.tres")
	var key = load("res://inventory/Items/GraveKey.tres")
	if key:
		inventory.insert(key)
