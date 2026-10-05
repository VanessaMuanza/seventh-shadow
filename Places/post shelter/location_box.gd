extends Area2D

@onready var canvas_layer: CanvasLayer = $LocationsBox/CanvasLayer

var entered = false

func _ready() -> void:
	canvas_layer.hide()

func _on_body_entered(body):
	if body is NPC:
		return
	if body is CharacterBody2D:
		entered = true
		canvas_layer.show()

func _on_body_exited(body):
	if body is NPC:
		return
	if body is CharacterBody2D:
		entered = false
		canvas_layer.hide()
