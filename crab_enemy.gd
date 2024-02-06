extends CharacterBody2D

@onready var coral = get_node("/root/Main/Coral") #fetches the coral node
var health = 1

signal died

func _physics_process(delta):
	if health <= 0:
		die()

	# Move the crab only along the x-axis
	var direction = global_position.direction_to(coral.global_position)
	velocity.x = direction.x * 200
	velocity.y = 0 # Ensure no movement along the y-axis
	move_and_slide()
	
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	else:
		$Sprite2D.flip_h = true

func take_damage():
	health -= 1
	modulate = Color(1, 0.5, 0.5, 1)
		
func die(): #oh no its dead
	queue_free()
	died.emit()
