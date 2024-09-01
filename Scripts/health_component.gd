class_name HealthComponent
extends CollisionShape2D

signal hit
@export var MAX_HEALTH : float
var health : float

func _ready() -> void:
	health = MAX_HEALTH

func take_damage(attack : Attack) -> void:
	health -= attack.damage
	hit.emit()
