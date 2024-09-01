# used this as a tutorial: https://www.youtube.com/watch?v=uNReb-MHsbg&t=30s
extends CharacterBody2D

##current bugs:
##need to make it so that once they start dodgin they cant stop and that the dodge goes in a specific direction for the duration
##currently the dodge animations only work in the cardinal directions and make the model dissapear when trying to go up right etc
##need to make it so that once a dodge starts the animation plays all the way thorugh, i think this will come with locking the character into a specific direction for the duration as currently it can default back to the idle state
##my brain - it shid

var acceleration = 800
var friction = 500
var max_speed = 120
var can_dodge = true
var dodge_cooldown = 1.2
var dodge_duration = 0.4
var dodging = false
const DEFAULT_ACCELERATION = 800
const DEFAULT_SPEED = 120 ##total speed will be base speed + class bonus + passive bonus

enum {IDLE, MOVE, DODGE_ROLL}
var state = IDLE

@onready var animationTree = $AnimationTree
@onready var state_machine = animationTree["parameters/playback"]

@onready var dodge_cooldown_timer = $DodgeCooldownTimer
@onready var dodge_duration_timer = $DodgeLengthTimer

var blend_position : Vector2 = Vector2.ZERO
var blend_pos_paths = [
	"parameters/idle/idle_bs2d/blend_position",
	"parameters/move/move_bs2d/blend_position",
	"parameters/dodge_roll/dodge_roll_bs2d/blend_position"
]
var animTree_state_keys = [
	"idle",
	"move",
	"dodge_roll"
]

func _physics_process(delta):

	if Input.is_action_just_pressed("dodge") and can_dodge == true: ##checking that player wants to dodge, isn't stationary and can dodge
		start_dodge()
		
	move(delta)
	animate()	
	
func move(delta):
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down") 
	if input_vector == Vector2.ZERO:
		state = IDLE
		apply_friction(friction * delta)
	elif input_vector != Vector2.ZERO:
		if dodging == true:
			state = DODGE_ROLL
		else:
			state = MOVE
		apply_movement(input_vector * acceleration * delta)
		blend_position = input_vector
	
	move_and_slide()
	
func start_dodge():
	dodge_cooldown_timer.start(dodge_cooldown)     
	dodging = true ##shows the player is now dodging
	dodge_duration_timer.start(dodge_duration)
	can_dodge = false ##you now cannot dodge until dodge timer resets again
	acceleration = 1200##set acceleration higher then decrease it, max velocity higher
	max_speed = acceleration
	##need to make it so that when dodge, velocity changes in the direction that is inputted for the dodge, ie the player can instantly change directions without having to decelerate - friction max?
	##depending on the dodge, we need to lock it into a singular position. with some classes and their dodges i think continued movement but i-frames is ok but for like the standard dodge roll it probably needs to lock into the dodge direction for the duration of the dodge


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
	acceleration = DEFAULT_ACCELERATION
	max_speed = DEFAULT_SPEED
	
