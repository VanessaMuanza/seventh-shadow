extends CharacterBody2D


const SPEED = 500.0

var last_direction: Vector2 = Vector2.RIGHT

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

func _physics_process(_delta: float) -> void:
	process_mouvement() 
	process_animation()
	move_and_slide()


func process_mouvement() -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("left", "right", "up", "down")
	
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		last_direction = direction
	else:
		velocity = Vector2.ZERO
	


func process_animation() -> void:
	if velocity != Vector2.ZERO:
		play_animation("run", last_direction)
	else:
		play_animation("idle", last_direction)

func play_animation(prefix: String, dir: Vector2) -> void:
	if dir.x > 0:
		sprite_2d.play(prefix + "_right")
	elif dir.x < 0:
		sprite_2d.play(prefix + "_left")
	elif dir.y < 0:
		sprite_2d.play(prefix + "_up")
	elif dir.y > 0:
		sprite_2d.play(prefix + "_down")
