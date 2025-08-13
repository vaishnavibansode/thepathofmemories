extends CharacterBody2D

class_name Enemy

const speed = 30

var is_enemy_chase : bool
var health = 80
var health_max = 80
var health_min =0

var dead: bool = false
var taking_damage : bool = false
var damage_to_deal = 20
var is_dealing_damage : bool = false

var dir: Vector2
const gravity = 900
var knockback_force = 200
var is_roaming : bool = true

func _process(delta):
	if !is_on_floor():
		velocity.y = ++ gravity * delta
		velocity.x = 0
	move(delta)
	move_and_slide()
	
func move(delta):
	if !dead:
		if !is_enemy_chase:
			velocity += dir * speed * delta
		is_roaming = true
	elif dead:
		velocity.x = 0

		


func _on_direction_timer_timeout() -> void:
	$direction_timer.wait_time = choose([1.5,2.0,2.5])
	if !is_enemy_chase:
		dir = choose([Vector2.RIGHT, Vector2.LEFT])
		velocity.x=0

	

func choose(array):
	array.shuffle()
	return array.front()
	 
