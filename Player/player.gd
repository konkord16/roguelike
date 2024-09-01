extends BaseEntity

const SPEED = 100
@export var current_weapon : BaseWeapon

func _physics_process(delta: float) -> void:
	current_weapon.look_at(get_global_mouse_position())
	super(delta)

func _unhandled_input(event: InputEvent) -> void:
	if not can_move:
		return
	direction = Input.get_vector("left", "right", "up", "down") * SPEED
	if Input.is_action_just_pressed("attack"):
		current_weapon.attack()
