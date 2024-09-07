class_name Weapon
extends Node2D

signal attacked
signal started_self_stun_attack
signal ended_self_stun_attack
signal dashed(direction : Vector2, force : float)
@export var damage : float
@export var knockback_force : float
@export var combo_length := 1
@onready var animator : AnimationPlayer = $AnimationPlayer
var combo_hit := 0


func attack() -> bool:
	if not (%Combo.time_left == 0 and combo_hit < combo_length and animator.get_queue().size() == 0):
		return false
	attacked.emit()
	if global_rotation < 0:
		z_index = -1
	else:
		z_index = 0
	animator.queue("attack" + str(combo_hit))
	combo_hit += 1
	%Combo.wait_time = animator.current_animation_length * 0.5
	%Combo.start()
	%ComboCooldown.start()
	return true

func _on_combo_cooldown_timeout() -> void:
	combo_hit = 0

func deal_damage(body: Node2D) -> void:
	if not body.has_method("get_hit"):
		return
	var attack := Attack.new()
	attack.damage = damage
	attack.position = global_position
	attack.knockback_force = knockback_force
	body.get_hit(attack)

func dash(angle : float, force : float) -> void:
	dashed.emit(Vector2.RIGHT.rotated(rotation + angle), force)

func _on_animation_player_animation_started(anim_name: StringName) -> void:
	look_at(get_global_mouse_position())
