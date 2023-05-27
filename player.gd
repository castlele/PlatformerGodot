extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 800.0

# TODO: check for ProjectSettings
# var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("move_left", "move_right")
	
	if direction:
		velocity.x = direction * SPEED
		_h_flip(direction)
	else:
		velocity.x = 0

	move_and_slide()
	
func _h_flip(direction: float):
	var multiplier: int
	if direction > 0.0:
		multiplier = 1
	else:
		multiplier = -1
		
	scale.x = scale.y * multiplier
