extends CharacterBody2D


#const SPEED: float = 100.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var JUMP_VELOCITY:float = -250.0
@export var max_speed:float = 150.0
@export var instant_move: bool = false
@export var turn_speed: float = 1200.0
@export var acceleration: float = 800.0
@export var deceleration: float = 900.0


func _physics_process(delta: float) -> void:
	# Get the input direction 1,0,-1
	var input_direction :float = Input.get_axis("left", "right")
	var target_speed: float = input_direction*max_speed
	var curr_acceleration = acceleration
	var curr_brake = deceleration
	
	# Add the gravity. and animation.
	if not is_on_floor():
		velocity += get_gravity() * delta
		animated_sprite.play("jump")
	else:
		if input_direction == 0:
			animated_sprite.play("new_run")
		else:
			animated_sprite.play("new_run")
			
	# Handle jump.
	if Input.is_action_just_pressed("up"):
		velocity.y = JUMP_VELOCITY

	
	
	#Flip the sprite
	if input_direction > 0:
		animated_sprite.flip_h = false
	elif input_direction < 0:
		animated_sprite.flip_h = true
	
	
	if instant_move:
		velocity.x = target_speed
	else:
		if abs(target_speed)>0.1:
			if sign(target_speed)!= sign(velocity.x) and abs(velocity.x)>0.1:
				velocity.x = move_toward(velocity.x, target_speed, turn_speed*delta);
			else:
				velocity.x = move_toward(velocity.x, target_speed, curr_acceleration*delta);
		else: 
			velocity.x = move_toward(velocity.x, 0, curr_brake*delta)
			

	# Apply Movement 
	#if input_direction:
	#	velocity.x = input_direction * SPEED
	#else:
	#	velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
