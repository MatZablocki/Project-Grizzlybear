extends CharacterBody3D

@onready var camera_mount = $CameraMount
@onready var animation_player = $AnimationPlayer
@onready var iFrames_timer = $iFrames
@onready var knockback_timer = $knockbackTimer

const SPEED = 8.0
const JUMP_VELOCITY = 8.5

@export var health = 3
@export var damage = 1

var sens_horizontal = 0.1
var sens_vertical = sens_horizontal

var took_damage = false
@export var iFrames : bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event.is_action_pressed("ui_text_backspace"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event.is_action_pressed("escape"):
		get_tree().quit()
		
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x*sens_horizontal))
		camera_mount.rotate_x(deg_to_rad(-event.relative.y*sens_vertical))
		camera_mount.rotation.x = clamp(camera_mount.rotation.x, -1.3,0.75)
	if event.is_action_pressed("left_click"):
		animation_player.play("weapon_swing")
	if event.is_action_pressed("roll"):
		animation_player.play("roll")
		
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	if(!took_damage):
		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func take_damage(body):
	if iFrames: return
	velocity = (get_global_position() - body.get_global_position()).normalized() * SPEED * 2
	health -= body.damage
	took_damage = true
	iFrames = true
	iFrames_timer.start()
	knockback_timer.start()
	if(health <= 0): get_tree().quit()

func _on_hurt_box_body_entered(body):
	print(body)
	if body.has_method("take_damage"):
		body.take_damage(self)


func _on_knockback_timer_timeout():
	took_damage = false
	pass # Replace with function body.


func _on_i_frames_timeout():
	iFrames = false
	pass # Replace with function body.
