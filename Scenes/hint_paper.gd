extends StaticBody2D

@onready var interactable: Area2D = $Interactable
@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact():
	GameState.player.can_move = false
	Dialogic.timeline_ended.connect(_on_dialog_ended, CONNECT_ONE_SHOT)
	Dialogic.start("HintPaper")

func _on_dialog_ended():
	GameState.player.can_move = true
