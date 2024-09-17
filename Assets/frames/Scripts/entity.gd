class_name Entity
extends CharacterBody2D

signal got_hit
@export var move_speed := 200.0
@export var MAX_HEALTH := 1.0
@export var knockback_mult := 1.0
@onready var animator : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
var weapons : Array
var current_weapon : Weapon
var hp : float
var direction : Vector2 ## Movement direction
var knockback : Vector2 ## Is added to velocity
var invincible := false
var hurt := false
var can_move := true
var locked_rotation:= false


func _ready() -> void:
	hp = MAX_HEALTH
	for weapon in %Weapons.get_children():# In the future i'm gonna be connecting the signals once the player picks up the weapon
		weapons.append(weapon)
		weapon.dashed.connect(dash)
		weapon.started_self_stun_attack.connect(_on_started_self_stun_attack)
		weapon.ended_self_stun_attack.connect(_on_ended_self_stun_attack)
		weapon.attacked.connect(_on_weapon_attack)
	current_weapon = weapons[0]

func _physics_process(delta: float) -> void:
	if not can_move:
		direction = Vector2.ZERO
	velocity = direction * move_speed + knockback
	knockback = lerp(knockback, Vector2.ZERO, 0.25)
	if knockback.length() < 5:
		knockback = Vector2.ZERO
	move_and_slide()
	direction = Vector2.ZERO

func _process(delta: float) -> void:
	if hurt:
		return
	if direction:
		animator.play("run")
	else:
		animator.play("idle")
	if direction.x and not locked_rotation:
		sprite.scale.x = sign(direction.x)


func get_hit(attack : Attack) -> void:
	if invincible or hurt:
		return
	hurt = true
	hp -= attack.damage
	animator.play("hit")
	got_hit.emit()
	dash(-to_local(attack.position), attack.knockback_force)
	await animator.animation_finished
	if hp <= 0:
		# Death sequence
		queue_free()
		pass
	else:
		hurt = false


func dash(direction : Vector2, force : float) -> void:
	knockback += direction.normalized() * force * knockback_mult


func _on_started_self_stun_attack() -> void:
	can_move = false


func _on_ended_self_stun_attack() -> void:
	can_move = true

func add_weapon(weapon : Weapon) -> void:
	pass

func remove_weapon() -> void:
	pass
	

func _on_weapon_attack() -> void:
	locked_rotation = true
	sprite.scale.x = sign(to_local(current_weapon.direction)).x
	await current_weapon.combo_cooldown.timeout
	locked_rotation = false
