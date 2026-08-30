extends Area2D

var entered = false

func _on_body_entered(body: Node2D) -> void:
	if body is NPC:
		return
	if body is CharacterBody2D:
		entered = true

func _on_body_exited(body: Node2D) -> void:
	if body is NPC:
		return
	if body is CharacterBody2D:
		entered = false
		
func _physics_process (_delta):
	if entered == true:
		if Input.is_action_just_pressed("ui_accept"):
			GameState.next_spawn_point = "DungeonEnt"
			get_tree().change_scene_to_file("res://Scenes/dungeon_entrance.tscn")
