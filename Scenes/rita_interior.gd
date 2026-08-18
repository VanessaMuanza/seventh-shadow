extends Area2D


var entered = false


func _on_body_entered(body):
	entered = true 


func _on_body_exited(body):
	entered = false
	
func _physics_process (_delta):
	if entered == true:
		if Input.is_action_just_pressed("ui_accept"):
			print("Rita zone triggered, going to: res://Scenes/rita's interior.tscn")
			GameState.next_spawn_point = "RitaHouse"
			get_tree().change_scene_to_file("res://Scenes/main.tscn")
