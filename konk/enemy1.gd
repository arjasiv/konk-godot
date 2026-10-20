extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var is_hurt = false
var is_dead = false

func blink():
	is_hurt = true
	animated_sprite_2d.play("enemy1_blink")
	is_hurt = false
		
func death():
	if is_dead: 
		return
		
	is_dead = true
	animated_sprite_2d.play("enemy1_death")
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.queue_free()
