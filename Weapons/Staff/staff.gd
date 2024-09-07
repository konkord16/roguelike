extends Weapon


func _on_hurtbox_body_entered(body: Node2D) -> void:
	deal_damage(body)
