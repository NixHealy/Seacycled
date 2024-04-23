extends Enemy

var moving = true

var tex1 = load("res://img/trash_netting.png")
var tex2 = load("res://img/trash_can.png")
var tex3 = load("res://img/trash_bottle.png")
var tex4 = load("res://img/trash_bottle_2.png")
var tex5 = load("res://img/trash_bag.png")

var norm_rotate
var rotate_clockwise = true

func _ready():
	randomize()
	
	health = 1
	
	if FileAccess.file_exists("user://options.ini"):
		config.load("user://options.ini")
		var contrast = false
		contrast = config.get_value("Options", "contrast")
		%Sprite2D.material.set_shader_parameter("active", contrast)
		
	var num = randi_range(0, 4)
	if num == 0: 
		%Sprite2D.set_texture(tex1)
	if num == 1: 
		%Sprite2D.set_texture(tex2)
	if num == 2: 
		%Sprite2D.set_texture(tex3)
	if num == 3: 
		%Sprite2D.set_texture(tex4)
	if num == 4: 
		%Sprite2D.set_texture(tex5)
		
	var tex_size = %Sprite2D.texture.get_size()
	%CollisionShape2D.shape.set_size(Vector2(tex_size.x + 20, tex_size.y + 20))
	
	norm_rotate = randf_range(0, 359)
	global_rotation_degrees = norm_rotate
	
	num = randi_range(0, 1)
	if num == 0:
		rotate_clockwise = false
	else:
		rotate_clockwise = true
	
func _physics_process(delta):
		
	if health <= 0:
		die()
	
	for i in get_slide_collision_count():
		moving = false
	
	var targetPosition = global_position.direction_to(coral.global_position)
	var direction = targetPosition #goes to the coral
	
	# Some extra math to add variety to the pollution spawn and direction
	direction.x -= direction.x / 2
	velocity = direction * 70.0
	
	if (moving):
		move_and_slide()
		if rotate_clockwise == true:
			global_rotation_degrees += 0.1
		else:
			global_rotation_degrees -= 0.1
