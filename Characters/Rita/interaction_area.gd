extends Area2D

var can_talk = false

func _on_interaction_area_body_entered(body):
	if body.is_in_group("player"):
		can_talk = true

	if can_talk and Input.is_action_just_pressed("E"):
		DialogueManager.show_dialogue_balloon(load("res://dialogue/dialogue_manager.dialogue"),"start")
		return
		
func _on_interaction_area_body_exited(body):
	if body.is_in_group("player"):
		can_talk = false
