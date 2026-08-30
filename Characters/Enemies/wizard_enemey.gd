extends CharacterBody2D

var player_in_area = false

func _ready() -> void:
	Dialogic.timeline_ended.connect(_on_dialog_ended)

func _on_dialog_ended() -> void:
	GameState.player.can_move = true


func _process(delta: float) -> void:
	if player_in_area:
		if Input.is_action_just_pressed("ui_interact"):
			run_dialog("WizardGiving")

func run_dialog(WizardGiving: String) -> void:
	GameState.player.can_move = false
	if GameState.is_collected("wizard_crystal_given"):
		Dialogic.start("Wizard_AlreadyGiven")
	else:
		Dialogic.start(WizardGiving)

func mark_crystal_given() -> void:
	print("mark_crystal_given appelée")
	GameState.mark_collected("wizard_crystal_given")


func _on_chat_detectio_body_entered(body):
	if body.has_method("player"):
		player_in_area = true


func _on_chat_detectio_body_exited(body):
	if body.has_method("player"):
			player_in_area = false 
