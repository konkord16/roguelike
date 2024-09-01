extends BaseEntity

const SPEED = 100

func _physics_process(delta: float) -> void:
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	velocity = Input.get_vector("left", "right", "up", "down") * SPEED
