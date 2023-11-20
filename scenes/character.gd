extends CharacterBody2D

const SPEED = 7500.0
const JUMP_VELOCITY = -300.0
@onready var animated_sprite_2d = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 40000.0

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta * get_process_delta_time()
		animated_sprite_2d.animation = "jump"


	# Handle Jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED * get_process_delta_time()
		animated_sprite_2d.animation = "run"
	else:
		velocity.x = move_toward(velocity.x, 0, 25)
		animated_sprite_2d.animation = "idle"

	move_and_slide()
	var isLeft = velocity.x < 0
	animated_sprite_2d.flip_h = isLeft
