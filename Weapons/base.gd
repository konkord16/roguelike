extends Weapon

@onready var sparks := preload("res://Scenes/Sparks/sparks.tscn")

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body is Entity:
		deal_damage(body)


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.owner is Weapon:
		dash(PI, 300)
		%Hurtbox.set_deferred("monitoring", false)
		var sparks_inst : GPUParticles2D = sparks.instantiate()
		sparks_inst.global_position = area.global_position - global_position
		sparks_inst.emitting = true
		add_sibling(sparks_inst)
		await sparks_inst.finished
		sparks_inst.queue_free()
