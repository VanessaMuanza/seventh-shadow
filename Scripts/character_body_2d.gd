#PLAYER SCRIPT
extends CharacterBody2D


@export var inventory: Inventory


const SPEED = 400.0

var last_direction: Vector2 = Vector2.RIGHT
#npc 
var can_move = true

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var quest_ui: Control = $QuestUi


func _physics_process(_delta: float) -> void:
	if can_move:
		process_mouvement()
		process_animation()
		move_and_slide()
		push_rigid_bodies()
		
func push_rigid_bodies() -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is RigidBody2D:
			var push_direction = -collision.get_normal()
			collider.apply_central_impulse(push_direction * 15.0)

func process_mouvement() -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("left", "right", "up", "down")
	
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		last_direction = direction
	else:
		velocity = Vector2.ZERO
	
	#turn raycast towards player direction
	if velocity != Vector2.ZERO:
		ray_cast_2d.target_position = velocity.normalized() * 175
		


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
		

func _ready():
	GameState.player = self
	if GameState.next_spawn_point != "":
		var spawn_node = get_tree().current_scene.find_child(GameState.next_spawn_point, true, false)
		if spawn_node:
			global_position = spawn_node.global_position
			print("Joueur repositionné à: ", position, " point utilisé: ", GameState.next_spawn_point)
		GameState.next_spawn_point = ""
	
		
func _input(event: InputEvent) -> void:
#interaction with Npc
	if can_move:
		if event.is_action_pressed("ui_interact"):
			var target = ray_cast_2d.get_collider()
			if target != null:
				if target.is_in_group("NPC"):
					print("i'm talking to an npc")
					#can't move if textbox open
					target.run_dialog("RitaGiving")

				elif target.is_in_group("Item"):
					print("Hello item")
				#if item needed for a quest, remove item 
				#or put in inventory regardless
					target.start_interact()

func player():
	pass
