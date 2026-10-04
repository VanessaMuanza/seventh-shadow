extends StaticBody2D

@onready var interactable: Area2D = $Interactable
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact():
	if sprite_2d.frame != 0:
		return
		
	if use_key():
		sprite_2d.frame = 1
		animation_player.play("GraveOpening")
		interactable.is_interactable = false
	else:
		Dialogic.start("Lock_NeedKey")

func use_key():
	var inventory = load("res://inventory/playerInventory.tres")
	for i in range(inventory.slots.size()):
		var slot: InventorySlot = inventory.slots[i]
		if slot.item and slot.item.name == "GraveKey":
			inventory.removeItemAtIndex(i)
			inventory.updated.emit()
			return true
	return false
