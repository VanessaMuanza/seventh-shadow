class_name NPC extends CharacterBody2D

@export var group_name: String
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@export var npc_name : String
@export var npc_id : String


var target_position: Vector2
var has_target: bool = false

#dialog vars. not useful


var player_in_area = false

@export var dialog_resource : Dialog
@export var quest_to_give: Quest

var current_state = "start"
var current_branch_index = 0

var do_behavior: bool = true
var state: String = "idle"
var direction: Vector2 = Vector2.DOWN
var last_direction: Vector2 = Vector2.DOWN

func _physics_process(delta: float) -> void:
	move_and_slide()
	process_animation()


func update_direction(target_position: Vector2) -> void:
	direction = global_position.direction_to(target_position)
	last_direction = direction

func update_animation() -> void:
	process_animation()

func process_animation() -> void:
	if velocity != Vector2.ZERO:
		play_animation("run", last_direction)
	else:
		play_animation("idle", last_direction)


func play_animation(prefix: String, dir: Vector2) -> void:
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			sprite_2d.play(prefix + "_right")
		else:
			sprite_2d.play(prefix + "_left")
	else:
		if dir.y < 0:
			sprite_2d.play(prefix + "_up")
		else:
			sprite_2d.play(prefix + "_down")
			
func _ready() -> void:
	Dialogic.timeline_ended.connect(_on_dialog_ended)

func _on_dialog_ended() -> void:
	GameState.player.can_move = true


func _process(delta: float) -> void:
	if player_in_area and not Dialogic.current_timeline:
		if Input.is_action_just_pressed("ui_interact"):
			run_dialog("RitaGiving")

func run_dialog(RitaGiving: String) -> void:
	var quest = QuestManager.get_quest("rita_crystal")
	var meeting_quest = QuestManager.get_quest("rita_meeting")

	if quest == null:
		GameState.player.can_move = false
		do_behavior = false
		Dialogic.start(RitaGiving)

	elif quest.state == "in_progress":
		GameState.player.can_move = false
		do_behavior = false
		Dialogic.start("Rita_QuestInProgress")

	elif quest.state == "completed":
		if meeting_quest and meeting_quest.state == "in_progress":
			var hour = TimeManager.date_time.hours
			if hour >= 19 and hour < 22:
				GameState.player.can_move = false
				do_behavior = false
				Dialogic.start("RitaMeeting")
			else:
				GameState.player.can_move = false
				do_behavior = false
				Dialogic.start("FailedMeeting")

		elif meeting_quest and meeting_quest.state == "completed":
			GameState.player.can_move = false
			do_behavior = false
			Dialogic.start("RitaDefault")

		elif not GameState.is_collected("rita_finished_shown"):
			GameState.player.can_move = false
			do_behavior = false
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
			
#Rita's first quest
var quest = QuestManager.get_quest("rita_crystal")
