extends Entity


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if not body.has_method("get_hit"):
		return
	var attack := Attack.new()
	attack.damage = 1
	attack.position = global_position
	attack.knockback_force = 300
	body.get_hit(attack)
