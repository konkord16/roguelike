extends BaseWeapon

func attack() -> void:
	super()
	dashed.emit(Vector2.RIGHT.rotated(rotation), 200)
	started_self_stun_attack.emit()
	await animator.animation_finished
	ended_self_stun_attack.emit()
