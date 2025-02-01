extends CharacterBody2D

enum States {ABLE, AIRSTALL, DEAD}
var state = States.ABLE
const SPEED = 400.0
const JUMP_VELOCITY = -400.0
var movement_speed = 400.0
var gravity_multiplier = 1
@onready var sprite = $AnimatedSprite2D
var can_airstall = true
var can_doublejump = true
@export var trail: Line2D

func _ready() -> void:
	sprite.play("Run")

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
	
	velocity.x = movement_speed
	
	if Input.is_action_just_pressed("Airstall") and can_airstall and not is_on_floor():
		state = States.AIRSTALL
		$LockedIcon.show()
		can_airstall = false
		velocity.y = 0
		$AirstallTime.paused = false
		$AirstallTime.start()
		$SoundStall.play()
	
	if Input.is_action_just_pressed("Jump") and is_on_floor() and state != States.AIRSTALL:
		velocity.y = JUMP_VELOCITY
		$JumpingParticles.emitting = true
		$SoundJump.play()
		#print("The player jumped!")
	elif Input.is_action_just_pressed("Jump") and can_doublejump and not is_on_floor() and state != States.AIRSTALL:
		velocity.y = JUMP_VELOCITY
		can_doublejump = false
		$SoundJump.play()
	
	if Input.is_action_just_pressed("Duck"):
		# The player's hurtbox needs to be adjusted eventually.
		if velocity.y < 0:
			velocity.y = 0

	if Input.is_action_pressed("SpeedUp"):
		movement_speed = 600.0

	if Input.is_action_pressed("SpeedDown"):
		movement_speed = 200.0
		
	if Input.is_action_just_released("SpeedUp") || Input.is_action_just_released("SpeedDown"):
		movement_speed = 400.0
	
	if state != States.AIRSTALL:
		if Input.is_action_pressed("Duck"):
			if is_on_floor() and sprite.animation != "Run Duck":
				sprite.play("Run Duck")
			elif not is_on_floor() and sprite.animation != "Midair Duck":
				sprite.play("Midair Duck")
			gravity_multiplier = 10
		else:
			gravity_multiplier = 1
			if is_on_floor() and sprite.animation != "Run":
				sprite.play("Run")
			elif not is_on_floor() and sprite.animation != "Midair":
				sprite.play("Midair")
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
