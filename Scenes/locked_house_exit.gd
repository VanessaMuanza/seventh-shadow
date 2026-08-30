extends Area2D

var entered = false
var can_interact = true

func _on_body_entered(body):
	if body is NPC:
		return
	if body is CharacterBody2D:
		entered = true


func _on_body_exited(body):
	if body is NPC:
		return
	if body is CharacterBody2D:
		entered = true
	
func _physics_process (_delta):
	if entered == true:
		if Input.is_action_just_pressed("ui_accept"):
			GameState.next_spawn_point = "DungeonExitMarker"
			get_tree().change_scene_to_file("res://Scenes/main.tscn")
