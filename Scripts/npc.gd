class_name NPC extends CharacterBody2D

@export var group_name: String
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@export var npc_name : String
@export var npc_id : String

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
			
func start_dialog():
	print("Hello")
