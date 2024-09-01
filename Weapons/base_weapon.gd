class_name BaseWeapon
extends Node2D


@export var damage : float
@export var knockback_force : float

func attack() -> void:
	if %Cooldown.time_left > 0:
		return
	%AnimationPlayer.play("attack")


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if not body.has_method("get_hit"):
		return
	var attack := Attack.new()
	attack.damage = damage
	attack.position = global_position
	attack.knockback_force = knockback_force
	body.get_hit(attack)
