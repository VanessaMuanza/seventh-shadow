class_name NPC extends CharacterBody2D

@export var group_name: String
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@export var npc_name : String
@export var npc_id : String


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
	if player_in_area:
		if Input.is_action_just_pressed("ui_interact"):
			run_dialog("RitaGiving")


func run_dialog(RitaGiving: String) -> void:
	GameState.player.can_move = false
	do_behavior = false
	
	var quest  = QuestManager.get_quest("rita_crystal")
	
	if quest == null:
		Dialogic.start(RitaGiving)
	
	elif quest.state == "in_progress":
		Dialogic.start("Rita_QuestInProgress")
	
	elif quest.state == "completed":
		Dialogic.start("Rita_QuestFinished")
	
	

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
