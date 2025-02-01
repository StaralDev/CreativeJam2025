extends CharacterBody2D

enum States {ABLE, AIRSTALL, DEAD}
var state = States.ABLE
const SPEED = 200.0
const JUMP_VELOCITY = -400.0
var movement_speed = 400.0
var gravity_multiplier = 1
@onready var sprite = $AnimatedSprite2D
var can_airstall = true
var can_doublejump = true
var am_duck = false
var duckDoubleJumps = 2
@export var trail: Line2D
var duck_timer = Timer

func _ready() -> void:
	sprite.play("Run")
	duck_timer = get_node("DuckTime")

func _physics_process(delta: float) -> void:
	if state == States.DEAD:
		sprite.play("Dead")
		var game_over_screen = load("res://Scenes/game_over_screen.tscn").instantiate()
		owner.add_child(game_over_screen)
		get_tree().paused = true
		return
	
	# Add the gravity.
	if not is_on_floor() and state != States.AIRSTALL:
		velocity += get_gravity() * delta * gravity_multiplier
	if is_on_floor():
		can_doublejump = true
		duckDoubleJumps = 2
	
	velocity.x = movement_speed
	
	if Input.is_action_just_pressed("Airstall") and can_airstall and not is_on_floor():
		state = States.AIRSTALL
		$LockedIcon.show()
		can_airstall = false
		velocity.y = 0
		$AirstallTime.paused = false
		if am_duck == true:
			sprite.play("DuckDash")
		$AirstallTime.start()
		$SoundStall.play()
	
	if Input.is_action_just_pressed("Jump") and is_on_floor() and state != States.AIRSTALL:
		velocity.y = JUMP_VELOCITY
		$JumpingParticles.emitting = true
		$SoundJump.play()
		#print("The player jumped!")
	elif Input.is_action_just_pressed("Jump") and can_doublejump and not is_on_floor() and state != States.AIRSTALL:
		if am_duck == true && duckDoubleJumps != 0:
			velocity.y = JUMP_VELOCITY
			duckDoubleJumps -= 1
			$SoundJump.play()
		elif am_duck == true:
			can_doublejump = false
		elif am_duck == false:
			velocity.y = JUMP_VELOCITY
			can_doublejump = false
			$SoundJump.play()
	
	if Input.is_action_just_pressed("Duck"):
		# The player's hurtbox needs to be adjusted eventually.
		if velocity.y < 0:
			velocity.y = 0
		
	if Input.is_action_just_released("SpeedUp") || Input.is_action_just_released("SpeedDown"):
		movement_speed = 400.0
	
	if state != States.AIRSTALL:
		if Input.is_action_pressed("Duck"):
			if am_duck == true:
				pass
			else:
				if is_on_floor() and sprite.animation != "Run Duck":
					sprite.play("Run Duck")
				elif not is_on_floor() and sprite.animation != "Midair Duck":
					sprite.play("Midair Duck")
			gravity_multiplier = 10
		else:
			if am_duck == true:
				if is_on_floor() and sprite.animation != "DuckRun":
					sprite.play("DuckRun")
				elif not is_on_floor() and sprite.animation != "Midair":
					sprite.play("DuckJump")
			else:
				if is_on_floor() and sprite.animation != "Run":
					sprite.play("Run")
				elif not is_on_floor() and sprite.animation != "Midair":
					sprite.play("Midair")
			gravity_multiplier = 1
	if state == States.AIRSTALL and Input.is_action_just_pressed("Duck"):
		$AirstallTime.paused = true
		self.modulate.b = 1
		_on_airstall_time_timeout()
	
	move_and_slide()
	
	#if 
	#self.modulate.r = $AirstallTime.time_left
	if $LockedIcon.visible:
		self.modulate.b = 1 - $AirstallTime.time_left
	$LockedIcon.modulate.a = $AirstallTime.time_left # I don't need to use time_left / total_time since the wait time is 1 second

func _on_airstall_time_timeout() -> void:
	if state != States.DEAD:
		state = States.ABLE
		$AirstallCooldown.start()
		$LockedIcon.hide()


func _on_airstall_cooldown_timeout() -> void:
	can_airstall = true


func _on_trail_timer_timeout() -> void:
	trail.add_point(position)
	
func to_duck():
	sprite.play("DuckRun")
	$DuckCollision.disabled = false
	$NormalCollision.disabled = true
	am_duck = true
	duck_timer.start(7)
	
func to_player():
	sprite.play("Run")
	$DuckCollision.disabled = true
	$NormalCollision.disabled = false
	am_duck = false


func _on_duck_time_timeout() -> void:
	to_player()
