extends Enemy

func _ready():
	health = 1

func _physics_process(delta):	
	if health <= 0:
		die()
	
	var direction = global_position.direction_to(coral.global_position) #goes to the coral
	velocity = direction * 400.0
	move_and_slide()
