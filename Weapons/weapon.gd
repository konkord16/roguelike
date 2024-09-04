class_name BaseWeapon
extends Node2D

signal started_self_stun_attack
signal ended_self_stun_attack
signal dashed(direction : Vector2, force : float)
@export var damage : float
@export var knockback_force : float
@export var combo_length := 1
@onready var animator : AnimationPlayer = $AnimationPlayer
var combo_hit := 0


func attack() -> void:
	if not animator.is_playing():
		if global_rotation < 0:
			z_index = -1
		else:
			z_index = 0
		animator.play("attack0")


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if not body.has_method("get_hit"):
		return
	var attack := Attack.new()
	attack.damage = damage
	attack.position = global_position
	attack.knockback_force = knockback_force
	body.get_hit(attack)
