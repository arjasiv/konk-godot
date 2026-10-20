extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_dead = false
var is_attacking = false

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	
	if is_dead:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("quick_attack") and not is_attacking:
		attack()
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("ui_left", "ui_right")
	
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = true
	elif direction < 0:
		animated_sprite.flip_h = false
	
	# Play animations
	if not is_attacking:
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
		else:
			animated_sprite.play("jump")
	
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func die() :
	if is_dead or is_attacking:
		return 
	
	is_dead = true
	
	await get_tree().create_timer(0.3).timeout
	animated_sprite.play("death")
	
	while not is_on_floor():
		velocity.x = 0
		velocity.y += gravity * get_physics_process_delta_time()
		move_and_slide()
		await get_tree().physics_frame
		
	velocity = Vector2.ZERO
	await animated_sprite.animation_finished
	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()
	
func attack():
	is_attacking = true
	animated_sprite.play("quick_attack")
	await animated_sprite.animation_finished
	is_attacking = false
