extends Entity

@export var current_weapon : Weapon

func _ready() -> void:
	super()
	for weapon in %Weapons.get_children():# In the future i'm gonna be connecting the signals once the player picks up the weapon
		weapon.dashed.connect(dash)
		weapon.started_self_stun_attack.connect(_on_started_self_stun_attack)
		weapon.ended_self_stun_attack.connect(_on_ended_self_stun_attack)
		weapon.attacked.connect(_on_weapon_attack)
		

func _physics_process(delta: float) -> void:
	super(delta)
	if can_move:
		direction = Input.get_vector("left", "right", "up", "down")
	if Input.is_action_just_pressed("attack"):
		current_weapon.attack(get_global_mouse_position())
	if Input.is_action_pressed("special"):
		get_tree().reload_current_scene()


func _on_weapon_attack() -> void:
	locked_rotation = true
	sprite.scale.x = sign(to_local(get_global_mouse_position()).x)
	await current_weapon.combo_cooldown.timeout
	locked_rotation = false
