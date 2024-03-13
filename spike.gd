extends CharacterBody2D

#maybe add health
var health = 1
var stunned = false

func _ready():
	position = Vector2(20,0).rotated(rotation)

func _physics_process(delta):
	velocity = Vector2(200, 0).rotated(rotation)
	move_and_slide()
	
func get_stunned():
	pass

func get_poisoned():
	pass
