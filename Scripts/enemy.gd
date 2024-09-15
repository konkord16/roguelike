class_name Enemy
extends Entity

@onready var player : Entity = get_tree().get_first_node_in_group("player")
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func chase() -> void:
	if is_instance_valid(player) and not navigation_agent.is_target_reached():
		direction = global_position.direction_to(navigation_agent.get_next_path_position())


func _on_chase_timer_timeout() -> void:
	if is_instance_valid(player):
		navigation_agent.target_position = player.global_position
