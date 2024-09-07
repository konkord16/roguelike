class_name Entity
extends CharacterBody2D

@export var move_speed := 200.0
@export var MAX_HEALTH := 1.0
@export var knockback_multiplier := 1.0
@onready var animator : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
var hp : float
var direction : Vector2
var knockback : Vector2
var invincible := false
var hurt := false
var can_move := true


func _ready() -> void:
	hp = MAX_HEALTH


func _physics_process(delta: float) -> void:
	velocity = direction * move_speed + knockback
	knockback = lerp(knockback, Vector2.ZERO, 0.25)
	if knockback.length() < 5:
		knockback = Vector2.ZERO
	move_and_slide()
	direction = Vector2.ZERO

func _process(delta: float) -> void:
	if hurt or not can_move:
		return
	if direction:
		animator.play("run")
	else:
		animator.play("idle")
	if direction.x > 0:
		sprite.scale.x = 1
	elif direction.x < 0:
		sprite.scale.x = -1


func get_hit(attack : Attack) -> void:
	if invincible or hurt:
		return
	hurt = true
	hp -= attack.damage
	animator.play("hit")
	dash(-to_local(attack.position), attack.knockback_force)
	await animator.animation_finished
	if hp <= 0:
		# Death sequence
		queue_free()
		pass
	else:
		hurt = false


func dash(direction : Vector2, force : float) -> void:
	knockback += direction.normalized() * force * knockback_multiplier

func _on_started_self_stun_attack() -> void:
	can_move = false

func _on_ended_self_stun_attack() -> void:
	can_move = true
