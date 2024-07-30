#need to create new sprites for directions as mirroring didnt work - 4 directions might be better than 8? used this as a tutorial: https://www.youtube.com/watch?v=uNReb-MHsbg&t=30s
extends CharacterBody2D


var acceleration = 800
var friction = 500
var max_speed = 120
var can_dodge = true
var dodge_cooldown = 1.2
var dodge_duration = 0.4
var dodging = false

enum {IDLE, MOVE}
var state = IDLE

@onready var animationTree = $AnimationTree
@onready var state_machine = animationTree["parameters/playback"]

####@onready var dodge_cooldown_timer = $DodgeCooldownTimer
####@onready var dodge_duration_timer = $DodgeLengthTimer


var blend_position : Vector2 = Vector2.ZERO
var blend_pos_paths = [
	"parameters/idle/idle_bs2d/blend_position",
	"parameters/move/move_bs2d/blend_position"
]
var animTree_state_keys = [
	"idle",
	"move"
]

func _physics_process(delta):
	move(delta)
	animate()
	if Input.is_action_just_pressed("dodge") and velocity.length() > 0 and can_dodge == true: ##checking that player wants to dodge, isn't stationary and can dodge
		perform_dodge()
		
	
	
func move(delta):
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down") #, "move_up_left", "move_up_right", "move_down_left", "move_down_right"
	if input_vector == Vector2.ZERO:
		state = IDLE
		apply_friction(friction * delta)
	else:
		state = MOVE
		apply_movement(input_vector * acceleration * delta)
		blend_position = input_vector
	
	move_and_slide()
	
func perform_dodge():
	$DodgeCooldownTimer.start(dodge_cooldown)##starts the dodge cooldown timer and sets the timer's wait time to dodge_cooldown  ####dodge_cooldown_timer.wait_time = dodge_cooldown             ##reset DodgeTimer
	dodging = true ##shows the player is now dodging
	$DodgeLengthTimer.start(dodge_duration)
	while dodging == true:
		acceleration = 1200##set acceleration higher then decrease it, max velocity higher
		max_speed = 400
	##give i-frames
	##stop from dodging again until cooldown
	pass

func apply_friction(amount) -> void:
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO
		
func apply_movement(amount) -> void:
	velocity += amount
	velocity = velocity.limit_length(max_speed)
	
func animate() -> void:
	state_machine.travel(animTree_state_keys[state])
	animationTree.set(blend_pos_paths[state], blend_position)
	
	
func _on_dodge_cooldown_timer_timeout():
	can_dodge = true
	
func _on_dodge_length_timer_timeout():
	dodging = false

	




######################################################################

#@onready var _animated_sprite = $AnimatedSprite2D

#@export var speed = 400
#var screen_size

#func _ready():
#	screen_size = get_viewport_rect().size

#func _process(delta):
#	#idk how to do it yet as i havent had a look at the ui stuff but we should eventually use the menu keyboard action layout options that users can remap
#	var velocity = Vector2.ZERO 
#	if Input.is_action_pressed("move_right"):
#		_animated_sprite.flip_h = false
#		velocity.x += 1
#		_animated_sprite.play("right")
#	if Input.is_action_pressed("move_left"):
#		_animated_sprite.flip_h = true
#		_animated_sprite.play("right")
#		velocity.x -= 1
#	if Input.is_action_pressed("move_down"):
#		_animated_sprite.play("down")
#		velocity.y += 1
#	if Input.is_action_pressed("move_up"):
#		_animated_sprite.play("up")
#		velocity.y -= 1
#	if Input.is_action_pressed("move_up") and Input.is_action_pressed("move_right"):
#		_animated_sprite.play("up_right")
#	if velocity.length() > 0:
#		velocity = velocity.normalized() * speed
#		$AnimatedSprite2D.play()
#	
#	if velocity.length() == 0:
#		$AnimatedSprite2D.stop()
#		
#	position += velocity * delta
#	position = position.clamp(Vector2.ZERO, screen_size)



#####################################################


#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


#func _physics_process(delta):
#	# Add the gravity.
#	if not is_on_floor():
#		velocity.y += gravity * delta
#
#	# Handle jump.
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#		velocity.y = JUMP_VELOCITY
#
#	# Get the input direction and handle the movement/deceleration.
#	# As good practice, you should replace UI actions with custom gameplay actions.
#	var direction = Input.get_axis("ui_left", "ui_right")
#	if direction:
#		velocity.x = direction * SPEED
#	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)
#
#	move_and_slide()






