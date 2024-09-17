class_name Weapon
extends Node2D
## Combo timer is handled automatically. It represents time until the next hit in the combo.
## Combo cooldown is meant to be set up manually. It's the time between combos.
## 
## When making a weapon change the sprite, collision shape, animations, damage, knockback,
## combo length, combo cooldown, ability cooldown, particles if necessary.

signal attacked
signal started_self_stun_attack
signal ended_self_stun_attack
signal dashed(direction : Vector2, force : float)
@export var damage : float
@export var knockback_force : float
@export var combo_length := 1
@onready var animator : AnimationPlayer = $AnimationPlayer
@onready var combo_cooldown : Timer = %ComboCooldown
var combo_hit := 0
var direction : Vector2

func _ready() -> void:
	if owner.is_in_group("player"):
		%Hurtbox.collision_mask = 0b1100
	elif owner is Enemy:
		%Hurtbox.collision_mask = 0b1010


func attack(new_direction : Vector2) -> bool:
	if not (%Combo.time_left == 0 and combo_hit < combo_length and animator.get_queue().size() == 0):
		return false
	direction = new_direction
	animator.queue("attack" + str(combo_hit))
	combo_hit += 1
	%Combo.wait_time = animator.current_animation_length * 0.5
	%Combo.start()
	%ComboCooldown.start()
	return true


func _on_combo_cooldown_timeout() -> void:
	combo_hit = 0


func deal_damage(body: Node2D, damage_mult := 1.0) -> void:
	if not body.has_method("get_hit"):
		return
	var attack := Attack.new()
	attack.damage = damage * damage_mult
	attack.position = global_position
	attack.knockback_force = knockback_force
	body.get_hit(attack)


func dash(angle : float, force : float) -> void: # Make the owner dash
	dashed.emit(Vector2.RIGHT.rotated(rotation + angle), force)


func _on_animation_player_animation_started(anim_name: StringName) -> void:
	look_at(direction)
	if global_rotation < 0:
		z_index = -1
	else:
		z_index = 0
	attacked.emit()
