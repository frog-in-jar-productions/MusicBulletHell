extends CharacterBody2D


const ACCELERATION = 800
const FRICTION = 500
const MAX_SPEED = 120

enum {IDLE, RUN}
var state = IDLE

@onready var animationTree = $AnimationTree
@onready var state_machine = animationTree["parameters/playback"]

var blend_position : Vector2 = Vector2.ZERO
var blend_pos_paths = [
	"parameters/idle/idle_bs2d/blend_position",
	"parameters/move/move_bs2d/blend_position"
]
var animTree_state_keys = [
	"idle",
	"run"
]

func _physics_process(delta):
	pass
	
func move(delta):
	var inpute_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_vector == Vector2.ZERO:
		state = IDLE
	else:
		state = RUN
		
		blend_position = input_vector
	move_and_slide()






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
