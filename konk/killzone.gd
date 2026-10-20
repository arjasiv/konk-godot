extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("die"):
		if not get_parent().is_hurt and not get_parent().is_dead:
			body.die()
