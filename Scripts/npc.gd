class_name NPC extends CharacterBody2D

@export var group_name: String
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@export var npc_name : String
@export var npc_id : String

var player_in_area = false

@export var quest_to_give: Quest

			
func _ready() -> void:
	Dialogic.timeline_ended.connect(_on_dialog_ended)

func _on_dialog_ended() -> void:
	GameState.player.can_move = true


func _process(delta: float) -> void:
	if player_in_area and Dialogic.current_timeline:
		if Input.is_action_just_pressed("ui_interact"):
			run_dialog("RitaGiving")

func run_dialog(RitaGiving: String) -> void:
	var quest = QuestManager.get_quest("rita_crystal")
	var meeting_quest = QuestManager.get_quest("rita_meeting")

	if quest == null:
		GameState.player.can_move = false
		Dialogic.start(RitaGiving)

	elif quest.state == "in_progress":
		GameState.player.can_move = false
		Dialogic.start("Rita_QuestInProgress")

	elif quest.state == "completed":
		if meeting_quest and meeting_quest.state == "in_progress":
			var hour = TimeManager.date_time.hours
			if hour >= 19 and hour < 22:
				GameState.player.can_move = false
				Dialogic.start("RitaMeeting")
			else:
				GameState.player.can_move = false
				Dialogic.start("FailedMeeting")

		elif meeting_quest and meeting_quest.state == "completed":
			GameState.player.can_move = false
			Dialogic.start("RitaDefault")

		elif not GameState.is_collected("rita_finished_shown"):
			GameState.player.can_move = false
			Dialogic.start("Rita_QuestFinished")
			GameState.mark_collected("rita_finished_shown")
	
	
func check_crystal():
	var quest = QuestManager.get_quest("rita_crystal")
	if quest and quest.state == "completed":
		Dialogic.start("Rita_QuestFinished")
	else:
		Dialogic.start("Rita_QuestInProgress")

func accept_quest() -> void:
	QuestManager.add_quest(quest_to_give)


func _on_chat_detectio_body_entered(body):
	if body.has_method("player"):
		player_in_area = true


func _on_chat_detectio_body_exited(body):
		if body.has_method("player"):
			player_in_area = false 
			
