extends CharacterBody2D

@onready var coral = get_node("/root/Main/Coral") #fetches the coral node
<<<<<<< HEAD
var health = 2
=======
>>>>>>> 01c6f31d43959c5f1272b171cd9b5aa091bbb288

signal died

func _physics_process(delta):
<<<<<<< HEAD
	if health <= 0:
		die()
	
=======
>>>>>>> 01c6f31d43959c5f1272b171cd9b5aa091bbb288
	var direction = global_position.direction_to(coral.global_position) #goes to the coral
	velocity = direction * 400.0
	move_and_slide()

	#rotation = atan(velocity.y / velocity.x) #temporarily removed because it was not playing nice with collision
	# rotation_degrees = snapped(rotation_degrees, 45) 
	
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	else:
		$Sprite2D.flip_h = true
		
<<<<<<< HEAD
func take_damage():
	health -= 1
	modulate = Color(1, 0.5, 0.5, 1)
		
=======
>>>>>>> 01c6f31d43959c5f1272b171cd9b5aa091bbb288
func die(): #oh no its dead
	queue_free()
	died.emit()
