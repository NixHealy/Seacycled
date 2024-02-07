extends CharacterBody2D

class_name Enemy

@onready var coral = get_node("/root/Main/Coral") #fetches the coral node
var health = 2
var speed = 200.0

signal died

func _physics_process(delta):
	if health <= 0:
		die()
	
	var direction = global_position.direction_to(coral.global_position) #goes to the coral
	velocity = direction * speed
	move_and_slide()

	#rotation = atan(velocity.y / velocity.x) #temporarily removed because it was not playing nice with collision
	# rotation_degrees = snapped(rotation_degrees, 45) 
	
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	else:
		$Sprite2D.flip_h = true
		
func take_damage():
	health -= 1
	modulate = Color(1, 0.5, 0.5, 1)
		
func die(): #oh no its dead
	if is_in_group("enemy"):
		var new_chumk = preload("res://chumk.tscn").instantiate()
		add_child(new_chumk)
		new_chumk.reparent(get_node("/root/Main"))
	queue_free()
	died.emit()
