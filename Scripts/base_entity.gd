class_name BaseEntity
extends CharacterBody2D

@export var MAX_HEALTH : float
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
	velocity = direction + knockback
	knockback = lerp(knockback, Vector2.ZERO, 0.25)
	if knockback.length() < 5:
		knockback = Vector2.ZERO
	move_and_slide()


func _process(delta: float) -> void:
	if hurt:
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
	if invincible:
		return
	hurt = true
	hp -= attack.damage
	animator.play("hit")
	knockback = -to_local(attack.position).normalized() * attack.knockback_force
	await animator.animation_finished
	if hp <= 0:
		# Death sequence
		queue_free()
		pass
	else:
		hurt = false
