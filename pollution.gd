extends Enemy

var moving = true

func _ready():
	health = 1

func _physics_process(delta):	
	if health <= 0:
		die()
	
	for i in get_slide_collision_count():
		moving = false
	
	var targetPosition = global_position.direction_to(coral.global_position)
	var direction = targetPosition #goes to the coral
	
	direction.x -= direction.x / 2
	velocity = direction * 200.0
	
	if (moving):
		move_and_slide()
