extends CharacterBody2D

var player_in_area := false


func _ready() -> void:
	Dialogic.timeline_ended.connect(_on_dialog_ended)


func _on_dialog_ended() -> void:
	GameState.player.can_move = true


func _process(_delta: float) -> void:
	if player_in_area and not Dialogic.current_timeline:
		if Input.is_action_just_pressed("ui_interact"):
			run_dialog()


func run_dialog(_timeline: String = "") -> void:
	var book_quest = QuestManager.get_quest("blue_book")

	if book_quest == null:
		start_dialog("MeetScientist")

	elif book_quest.state == "in_progress":
		if QuestManager.take_book():
			start_dialog("BlueBookFound")
		else:
			start_dialog("BlueBookInProgress")



func start_dialog(timeline: String) -> void:
	print("Timeline lancée : ", timeline)
	GameState.player.can_move = false
	Dialogic.start(timeline)



func _on_chat_detectio_body_entered(body):
	if body.has_method("player"):
		player_in_area = true


func _on_chat_detectio_body_exited(body):
	if body.has_method("player"):
		player_in_area = false
