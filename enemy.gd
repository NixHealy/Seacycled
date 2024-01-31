extends CharacterBody2D

@onready var coral = get_node("/root/Main/Coral") #fetches the coral node

signal died

func _physics_process(delta):
	var direction = global_position.direction_to(coral.global_position) #goes to the coral
	velocity = direction * 300.0
	move_and_slide()

	#rotation = atan(velocity.y / velocity.x) #temporarily removed because it was not playing nice with collision
	# rotation_degrees = snapped(rotation_degrees, 45) 
	
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	else:
		$Sprite2D.flip_h = true
		
func die(): #oh no its dead
	queue_free()
	died.emit()
