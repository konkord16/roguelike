extends Enemy

@export var attack_range := 25.0

func _physics_process(delta: float) -> void:
	super(delta)
	if player_pos.length() > attack_range:
		chase()
	elif not %Claw.animator.is_playing():
		%Claw.attack(player.global_position)
