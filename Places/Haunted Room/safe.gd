extends StaticBody2D

@onready var interactable: Area2D = $Interactable
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var end_canvas: CanvasLayer = $EndCanva
@onready var black_rect: ColorRect = $EndCanva/BlackRect
@onready var end_label: Label = $EndCanva/EndLabel
@onready var end_menu: Control = $EndCanva/Control



func _ready() -> void:
	interactable.interact = _on_interact
	end_canvas.hide()

func _on_interact():
	if sprite_2d.frame != 0:
		return

	if use_card():
		sprite_2d.frame = 1
		interactable.is_interactable = false
		GameState.player.can_move = false
		Dialogic.timeline_ended.connect(_on_dialog_ended, CONNECT_ONE_SHOT)
		Dialogic.start("SafeOpened")
	else:
		Dialogic.start("Safe_NeedCard")
	
func _on_dialog_ended() -> void:
	GameState.player.can_move = true
	end_canvas.show()
	black_rect.modulate.a = 0.0
	end_label.modulate.a = 0.0
	end_menu.modulate.a = 0.0
	
	var tween = create_tween()
	tween.tween_property(black_rect, "modulate:a", 1.0, 1.5)
	tween.tween_property(end_label, "modulate:a", 1.0, 1.0)
	tween.tween_property(end_menu, "modulate:a", 1.0, 1.0)


func use_card() -> bool:
	var inventory = load("res://inventory/playerInventory.tres")
	for i in range(inventory.slots.size()):
		var slot: InventorySlot = inventory.slots[i]
		if slot.item and slot.item.name == "Card":
			inventory.removeItemAtIndex(i)
			inventory.updated.emit()
			return true
	return false
