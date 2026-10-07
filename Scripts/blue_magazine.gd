extends CharacterBody2D

@export var itemRes: InventoryItem

@onready var player = get_tree().get_first_node_in_group("player")

const MAX_SPEED = 50.0
const ACCELERATION = 0.5

var speed = 0.0
var is_being_picked_up = false

func _physics_process(_delta: float) -> void:
	var collision = move_and_collide(velocity)
	if collision:
		_handle_picked_up()

func _ready():
	if GameState.is_collected(name):
		queue_free()
		return

func _handle_picked_up():
	player.inventory.insert(itemRes)
	GameState.mark_collected(name)
	queue_free()
