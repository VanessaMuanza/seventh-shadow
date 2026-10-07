extends CharacterBody2D

const WALK_SPEED = 80.0
const RUN_SPEED = 300.0

@export var vision_range := 250.0
@export var attack_distance := 40.0
@export var lose_sight_time := 3.0

enum State { WANDER, CHASE }
var state := State.WANDER

var direction := Vector2.DOWN
var last_direction := Vector2.DOWN
var wander_time := 0.0
var time_since_seen := 0.0
var last_known_position := Vector2.ZERO
var caught := false

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var ray_cast_2d: RayCast2D = $Sprite2D/RayCast2D
@onready var jumpscare_audio: AudioStreamPlayer2D = $JumpscareAudio
@onready var blood_fx: AnimatedSprite2D = $GameOverLayer/BloodFx
@onready var game_over_layer: CanvasLayer = $GameOverLayer
@onready var game_over_label: Label = $GameOverLayer/GameOverLabel
@onready var black_rect: ColorRect = $GameOverLayer/BlackRect


func _ready() -> void:
	game_over_layer.hide()

func _physics_process(delta: float) -> void:
	var player = GameState.player
	if player == null or caught:
		return
	
	for i in get_slide_collision_count():
		if get_slide_collision(i).get_collider() == player:
			trigger_jumpscare()
			return

	# si l'ennemi voit le joueur
	if can_see(player):
		state = State.CHASE
		time_since_seen = 0.0
		last_known_position = player.global_position
	elif state == State.CHASE:
		time_since_seen += delta
		if time_since_seen >= lose_sight_time:
			state = State.WANDER

	#son comportement selon son état
	match state:
		State.WANDER:
			process_wander(delta)
			velocity = direction * WALK_SPEED
			sprite_2d.speed_scale = 1.0
		State.CHASE:
			direction = (last_known_position - global_position).normalized()
			velocity = direction * RUN_SPEED
			sprite_2d.speed_scale = 1.4

			if global_position.distance_to(player.global_position) <= attack_distance:
				trigger_jumpscare()
				return

			# Arrivé au dernier endroit connu et il s'arrête
			if global_position.distance_to(last_known_position) < 5.0:
				velocity = Vector2.ZERO

	if velocity != Vector2.ZERO:
		last_direction = direction
		play_animation("run", last_direction)
	else:
		play_animation("idle", last_direction)

	move_and_slide()


func can_see(player: Node2D) -> bool:
	if global_position.distance_to(player.global_position) > vision_range:
		return false
	ray_cast_2d.target_position = ray_cast_2d.to_local(player.global_position)
	ray_cast_2d.force_raycast_update()
	return ray_cast_2d.get_collider() == player


func process_wander(delta: float) -> void:
	wander_time -= delta
	if wander_time <= 0.0:
		wander_time = randf_range(1.5, 3.5)
		var dirs = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT, Vector2.ZERO]
		direction = dirs.pick_random()


func play_animation(prefix: String, dir: Vector2) -> void:
	var suffix := "right" if dir.x > 0 else "left" if dir.x < 0 else "up" if dir.y < 0 else "down"
	sprite_2d.play(prefix + "_" + suffix)


func trigger_jumpscare() -> void:
	caught = true
	velocity = Vector2.ZERO
	GameState.player.can_move = false
	
	game_over_layer.show()
	black_rect.modulate.a = 0.0
	game_over_label.modulate.a = 0.0
	
	blood_fx.position = get_viewport_rect().size / 2
	blood_fx.show()
	
	jumpscare_audio.play()
	blood_fx.play("blood")
	var tween = create_tween()
	tween.tween_property(black_rect, "modulate:a", 1.0, 0.3)
	
	#texte arrive quand anim fini
	await blood_fx.animation_finished
	var text_tween = create_tween()
	text_tween.tween_property(game_over_label, "modulate:a",1.0, 0.5)
	
	await text_tween.finished
	await get_tree().create_timer(5.0).timeout 

	await FadeTransition.fade_out()
	GameState.next_scene_path = "res://Places/post shelter/shelter_room.tscn"
	GameState.next_spawn_point = "ShelterEnt"
	GameState.next_dialog = "CaughtByMonster"
	get_tree().change_scene_to_file("res://Scenes/loading_scene.tscn")
	
