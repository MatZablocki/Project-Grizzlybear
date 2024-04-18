extends Node3D

@onready var timer = $Timer
@onready var enemy = load("res://Scenes/enemy.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	var temp = enemy.instantiate()
	
	add_sibling(temp)
	pass # Replace with function body.
