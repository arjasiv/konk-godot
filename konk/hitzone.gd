extends Area2D

var hitzoneCounter = 0
var was_attacking = false

func _physics_process(_delta):
	for body in get_overlapping_bodies():
		if body is CharacterBody2D:
			
			# Let player attack only when not already attacking
			if body.is_attacking and not was_attacking:
				hitzoneCounter += 1

				if hitzoneCounter >= 3:
					get_parent().death()
				else:
					get_parent().blink()

			was_attacking = body.is_attacking
