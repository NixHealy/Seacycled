extends Enemy

var moving = true

func _ready():
	health = 1

func _physics_process(delta):	
	if health <= 0:
		die()
	
	for i in get_slide_collision_count():
		moving = false
	
	var direction = global_position.direction_to(coral.global_position) #goes to the coral
	velocity = direction * 400.0
	if (moving):
		move_and_slide()
