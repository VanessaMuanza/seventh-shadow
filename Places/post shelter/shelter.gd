extends Node2D


func _ready() -> void:
	if GameState.next_dialog != "":
		var timeline = GameState.next_dialog
		GameState.next_dialog = ""
		await get_tree().create_timer(1.0).timeout
		GameState.player.can_move = false
		Dialogic.timeline_ended.connect(_on_dialog_ended, CONNECT_ONE_SHOT)
		Dialogic.start(timeline)


func _on_dialog_ended() -> void:
	GameState.player.can_move = true
