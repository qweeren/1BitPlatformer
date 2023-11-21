extends CharacterBody2D

@onready var player_sprite = $AnimatedSprite2D
@onready var spawn_point = %SpawnPoint
@onready var particles = $CPUParticles2D

@export_category("Player Properties") # You can tweak these changes according to your likings
@export var move_speed : float = 125
@export var jump_force : float = 300
@export var gravity : float = 20
@export var max_jump_count : int = 2
var jump_count : int = 2
var is_grounded : bool = false
var play_walk_sfx : bool = false
var slide_speed : int = 20

func _physics_process(delta):
	# Calling functions
	movement()
	player_animations()
	flip_player()
# --------- CUSTOM FUNCTIONS ---------- #

# <-- Player Movement Code -->
func movement():
	# Gravity
	if is_on_wall_only():
		if $dbJumpTimer.time_left <= 0:
			jump_count = max_jump_count
			player_sprite.modulate = "a3cdf7"
			$dbJumpTimer.start(0.5)
	
	if !is_on_floor():
		velocity.y += gravity
	elif is_on_floor():
		jump_count = max_jump_count
		player_sprite.modulate = "a3cdf7"
	
	handle_jumping()
	
			# Move Player
	var inputAxis = Input.get_axis("left", "right")
	playSFX(inputAxis)
	velocity = Vector2(inputAxis * move_speed, velocity.y)
	move_and_slide()


func playSFX(input):
	if input and is_on_floor():
		if $walkTimer.time_left <= 0:
			$walkTimer.start(0.3)
			$WalkSFX.play()

# Handles jumping functionality (double jump or single jump, can be toggled from inspector)
func handle_jumping():
	if Input.is_action_just_pressed("up"):
		if jump_count > 0:
			jump()
			jump_count -= 1

# Player jump
func jump():
	velocity.y = -jump_force
	player_sprite.modulate = "ffffff"
	if not is_on_floor():
		$dbJumpSFX.play()
		jump_particles()
	else:
		$JumpSFX.play()

func jump_particles():
	particles.emitting = true
	await get_tree().create_timer(0.05).timeout
	particles.emitting = false

# Handle Player Animations
func player_animations():
	if is_on_floor():
		if abs(velocity.x) > 0:
			player_sprite.play("run", 1.5)
		else:
			player_sprite.play("idle")
	else:
		player_sprite.play("jump")

# Flip player sprite based on X velocity
func flip_player():
	if velocity.x < 0: 
		player_sprite.flip_h = true
	elif velocity.x > 0:
		player_sprite.flip_h = false

func death():
	print("dead")

# --------- SIGNALS ---------- #

# Reset the player's position to the current level spawn point if collided with any trap
func _on_collision_body_entered(_body):
	if _body.is_in_group("Traps"):
		death()
