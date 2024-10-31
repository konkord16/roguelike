extends Entity



func _physics_process(delta: float) -> void:
	super(delta)
	if can_move:
		direction = Input.get_vector("left", "right", "up", "down")
	if Input.is_action_just_pressed("attack"):
		current_weapon.attack(get_global_mouse_position())
	if Input.is_action_pressed("special"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("swap_weapon") and not current_weapon.animator.is_playing():
		if current_weapon == weapons[0]:
			current_weapon = weapons[1]
		else:
			current_weapon = weapons[0]
