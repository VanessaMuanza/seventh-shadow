extends CharacterBody2D



@onready var player = get_tree().get_first_node_in_group("player")

const MAX_SPEED = 50.0
const ACCELERATION = 0.5

var speed = 0.0
var is_being_picked_up = false


func _physics_process(delta: float) -> void:
	if is_being_picked_up:
		speed = lerp(speed, MAX_SPEED, ACCELERATION * delta)
		velocity = global_position.direction_to(player.global_position) * speed
		
	var collision = move_and_collide(velocity)

	if collision:
		_handle_picked_up()


func _handle_picked_up():
		queue_free()
