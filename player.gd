extends KinematicBody2D

const MOTION_SPEED = 260 # Pixels/second.

# Animation variables
var last_motion = Vector2(0, 1)

# Player dragging flag
var drag_enabled = false

func _physics_process(_delta):
	var motion = Vector2()
	motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	motion.y /= 2
	motion = motion.normalized() * MOTION_SPEED
	#warning-ignore:return_value_discarded
	move_and_slide(motion)
	animates_player(motion)
	
func get_animation_motion(motion: Vector2):
	var norm_direction = motion.normalized()
	if norm_direction.y >= 0.707:
		return "down"
	elif norm_direction.y <= -0.707:
		return "up"
	elif norm_direction.x <= -0.707:
		return "left"
	elif norm_direction.x >= 0.707:
		return "right"
	return "down"

func animates_player(motion: Vector2):
		if motion != Vector2.ZERO:
		# gradually update last_direction to counteract the bounce of the analog stick
			last_motion = 0.5 * last_motion + 0.5 * motion
		
		# Choose walk animation based on movement direction
			var animation = get_animation_motion(last_motion) + "_run"
		
		# Choose FPS based on movement speed and then play the walk animation
			$Sprite.frames.set_animation_speed(animation, 2 + 8 * motion.length())
			$Sprite.play(animation)
		else:
		# Choose idle animation based on last movement direction and play it
			var animation = get_animation_motion(last_motion) + "_idle"
			$Sprite.play(animation)
