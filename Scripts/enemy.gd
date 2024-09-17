class_name Enemy
extends Entity

@onready var player : Entity = get_tree().get_first_node_in_group("player")
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
var player_pos : Vector2 ## Player position local to the enemy
var player_alive := true

func _physics_process(delta: float) -> void:
	super(delta)
	if is_instance_valid(player):
		player_pos = to_local(player.global_position)
	else:
		player_alive = false
		return


func chase() -> void:
	if player_alive and not navigation_agent.is_target_reached():
		direction = global_position.direction_to(navigation_agent.get_next_path_position())


func _on_chase_timer_timeout() -> void:
	if player_alive:
		navigation_agent.target_position = player.global_position
