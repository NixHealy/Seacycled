extends CharacterBody2D

func _ready():
	position = Vector2(20,0).rotated(rotation)

func _physics_process(delta):
	velocity = Vector2(200, 0).rotated(rotation)
	move_and_slide()
