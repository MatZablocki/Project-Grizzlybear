extends RigidBody3D

@onready var player = $"../Player"
@onready var iFrames = $iFrames

@export var speed = 1
@export var health = 3
@export var damage = 1
var took_damage = false
var velocity
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _physics_process(delta):
	
	look_at(player.position)
	rotation = Vector3(0,rotation.y,0)
	var direction = (player.get_global_position() - get_global_position()).normalized()
	#if(took_damage):pass
		
	velocity = direction * speed * delta
	
	move_and_collide(velocity)


func _on_weapon_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(self)

func take_damage(body):
	if(took_damage): return
	apply_impulse(-velocity*300)
	health -= body.damage
	took_damage = true
	iFrames.start()
	if(health<=0): queue_free()
	


func _on_timer_timeout():
	took_damage = false
	pass # Replace with function body.
