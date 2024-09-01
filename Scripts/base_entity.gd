class_name BaseEntity
extends CharacterBody2D

@onready var animator : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var hp_comp : HealthComponent = $HealthComponent
var hurt := false

func _ready() -> void:
	hp_comp.connect("hit", get_hit)

func _process(delta: float) -> void:
	if not hurt:
		if velocity:
			animator.play("run")
		else:
			animator.play("idle")
		if velocity.x > 0:
			sprite.scale.x = 1
		elif velocity.x < 0:
			sprite.scale.x = -1

func get_hit() -> void:
	hurt = true
	animator.play("hit")
	await animator.animation_finished
	if hp_comp.health <= 0:
		# Death sequence
		pass
	else:
		hurt = false
