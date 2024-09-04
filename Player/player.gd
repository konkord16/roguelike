extends Entity

const SPEED = 100
@export var current_weapon : BaseWeapon

func _ready() -> void:
	super()
	$RegularSword.dashed.connect(dash) # In the future i'm gonna be connecting the signals once the player picks up the weapon
	$RegularSword.started_self_stun_attack.connect(_on_started_self_stun_attack)
	$RegularSword.ended_self_stun_attack.connect(_on_ended_self_stun_attack)

func _physics_process(delta: float) -> void:
	if can_move:
		current_weapon.look_at(get_global_mouse_position())
	super(delta)


func _unhandled_input(event: InputEvent) -> void:
	if not can_move:
		direction = Vector2.ZERO
		return
	direction = Input.get_vector("left", "right", "up", "down") * SPEED
	if Input.is_action_just_pressed("attack"):
		current_weapon.attack()
		sprite.scale.x = sign(to_local(get_global_mouse_position()).x)
