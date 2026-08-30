extends Area2D

var player_entered = false
var can_interact = true

func _on_body_entered(body):
	if body is NPC:
		GameState.npc_locations["Rita"] = "inside"
		body.queue_free()
		return
	if body is CharacterBody2D:
		player_entered = true

func _on_body_exited(body):
	if body is NPC:
		return
	if body is CharacterBody2D:
		player_entered = false

func _physics_process(_delta):
	if player_entered  == true :
		if Input.is_action_just_pressed("ui_accept"):
			GameState.next_spawn_point = "RitaHouseSpawn"
			get_tree().change_scene_to_file("res://Scenes/rita's interior.tscn")

func _ready():
	set_deferred("monitoring", false)
	await get_tree().physics_frame
	await get_tree().physics_frame
	set_deferred("monitoring", true)
