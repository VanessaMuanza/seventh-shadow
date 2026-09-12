@tool
extends NPCBehavior

const COLORS = [Color(1,0,0), Color(1,1,0), Color(0,1,1), Color(0,0,1), Color(1,0,1)]
const ARRIVAL_THRESHOLD := 4.0

@export var walk_speed : float = 30.0

var patrol_locations: Array[PatrolLocation]
var current_location_index : int = 0
var target : PatrolLocation
var is_moving: bool = false

func _ready() -> void:
	super._ready()
	gather_patrol_locations()
	if Engine.is_editor_hint():
		child_entered_tree.connect(gather_patrol_locations)
		child_order_changed.connect(gather_patrol_locations)
		return
	if patrol_locations.size() < 2:
		process_mode = Node.PROCESS_MODE_DISABLED
		return
	target = patrol_locations[0]
	call_deferred("start")

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if not npc.do_behavior:
		return
	if is_moving and npc.global_position.distance_to(target.target_position) < ARRIVAL_THRESHOLD:
		is_moving = false
		start()

func gather_patrol_locations(_n: Node = null) -> void:
	patrol_locations = []
	for c in get_children():
		if c is PatrolLocation:
			patrol_locations.append(c)

	for i in patrol_locations.size():
		var _p = patrol_locations[i] as PatrolLocation
		if not _p.transform_changed.is_connected(gather_patrol_locations):
			_p.transform_changed.connect(gather_patrol_locations)
		_p.update_label(str(i))
		_p.modulate = _get_color_by_index(i)

		var _next: PatrolLocation
		if i < patrol_locations.size() - 1:
			_next = patrol_locations[i + 1]
		else:
			_next = patrol_locations[0]
		_p.update_line(_next.position)

func start() -> void:
	if npc.do_behavior == false or patrol_locations.size() < 2:
		npc.velocity = Vector2.ZERO
		return

	npc.global_position = target.target_position
	npc.state = "idle"
	npc.velocity = Vector2.ZERO
	npc.update_animation()

	var wait_time: float = target.wait_time

	current_location_index += 1
	if current_location_index >= patrol_locations.size():
		current_location_index = 0
	target = patrol_locations[current_location_index]

	await get_tree().create_timer(wait_time).timeout

	if npc.do_behavior == false:
		npc.velocity = Vector2.ZERO
		return

	npc.state = "run"
	var _dir = npc.global_position.direction_to(target.target_position)
	npc.direction = _dir
	npc.velocity = walk_speed * _dir
	npc.update_direction(target.target_position)
	npc.update_animation()
	is_moving = true

func _get_color_by_index(i: int) -> Color:
	var color_count: int = COLORS.size()
	while i > color_count - 1:
		i -= color_count
	return COLORS[i]
