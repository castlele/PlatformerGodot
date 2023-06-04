extends CharacterBody2D
class_name Player


enum AnimationState { IDLE, RUN, JUMP }


@export var playerData: PlayerData

const GRAVITY = 800.0
const LADDER_FALLING_SPEED = 1000.0
const MAX_FALLING_SPEED = 350
const LANDING_FRAME_INDEX = 1

@onready var animatedSprite = $AnimatedSprite2D
@onready var ladderChecker = $LadderChecker


func _physics_process(delta):
    apply_gravity(delta)
    move()

    jump()

    var was_in_air = not is_on_floor()

    move_and_slide()

    apply_landing(was_in_air)


func get_damage():
    playerData.hp -= 1

    if playerData.hp == 0:
        get_tree().reload_current_scene()
    else:
         velocity.y = playerData.JUMP_VELOCITY
         _animate(AnimationState.JUMP)


func jump():
    if Input.is_action_pressed("jump") and (is_on_floor() or _is_on_ladder()):
        velocity.y = playerData.JUMP_VELOCITY
        _animate(AnimationState.JUMP)


func move():
    var direction = Input.get_axis("move_left", "move_right")
    var animation: AnimationState

    if direction:
        _apply_acceleration(direction)
        _h_flip(direction)
        animation = AnimationState.RUN
    else:
        _apply_friction()
        animation = AnimationState.IDLE

    if is_on_floor():
        _animate(animation)


func apply_gravity(delta: float):
    if _is_on_ladder() and  not Input.is_action_pressed("jump"):
        velocity.y = LADDER_FALLING_SPEED * delta

    elif not is_on_floor() and abs(velocity.y) < MAX_FALLING_SPEED:
        velocity.y += GRAVITY * delta


func apply_landing(was_in_air: bool):
    if is_on_floor() and was_in_air:
        _animate(AnimationState.RUN)
        animatedSprite.frame = LANDING_FRAME_INDEX


func _is_on_ladder() -> bool:
    return ladderChecker.is_colliding() and ladderChecker.get_collider() is Ladder

func _apply_acceleration(direction: float):
    velocity.x = move_toward(velocity.x, playerData.SPEED * direction, playerData.SPEED)


func _apply_friction():
    velocity.x = move_toward(velocity.x, 0, playerData.SPEED)


func _h_flip(direction: float):
    animatedSprite.flip_h = direction > 0


func _animate(state: AnimationState):
    var str_state_name = AnimationState.keys()[state].to_lower()
    animatedSprite.play(str_state_name)
